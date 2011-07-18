Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39609 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1GRVbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 17:31:08 -0400
Received: by iwn6 with SMTP id 6so3476677iwn.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 14:31:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E249779.4000503@iki.fi>
References: <201106070205.08118.jareguero@telefonica.net>
	<201107070057.06317.jareguero@telefonica.net>
	<4E1D927A.5090006@redhat.com>
	<201107142200.52970.jareguero@telefonica.net>
	<4E249779.4000503@iki.fi>
Date: Mon, 18 Jul 2011 17:31:07 -0400
Message-ID: <CAOcJUbyZ43z9AyNNDwQv8SAYvKHBjXU-oCqmuzDTU9ME3FT=ng@mail.gmail.com>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFE really needs to be implemented in the dvb-usb framework itself.  I
had started to work on this some time ago but had to stop working on
it due to lack of time, and the fact that there was no public driver
that I could use as a poster-child for the new functionality. In the
end, rather than implement MFE correctly, I implemented each frontend
as a separate adapter (which is *wrong* , but it sufficed for now) and
added a locking mechanism in the bridge driver to prevent the
frontends from being used simultaneously in an external driver that I
was working on.

If interested, I can post skeleton code that would illustrate how to
get that done, but the better solution would be to truly implement MFE
in dvb-usb.

As of now, there is no public release driver that can use MFE in the
dvb-usb framework.  That is part of why I had to stop working on this.
 Do you plan to implement it in the dvb-usb framework?  (...and
regression test the other dvb-usb drivers) ??

Regards,

Mike Krufky

On Mon, Jul 18, 2011 at 4:28 PM, Antti Palosaari <crope@iki.fi> wrote:
> Hello
> I did some review for this since I was interested of adding MFE for Anysee
> driver which is rather similar (dvb-usb-framework).
>
> I found this patch have rather major issue(s) which should be fixed
> properly.
>
> * it does not compile
> drivers/media/dvb/dvb-usb/dvb-usb.h:24:21: fatal error: dvb-pll.h: No such
> file or directory
>
> * it puts USB-bridge functionality to the frontend driver
>
> * 1st FE, TDA10023, is passed as pointer inside config to 2nd FE TDA10048.
> Much of glue sleep, i2c etc, those calls are wrapped back to to 1st FE...
>
> * no exclusive locking between MFEs. What happens if both are accessed same
> time?
>
>
> Almost all those are somehow chained to same issue, few calls to 2nd FE are
> wrapped to 1st FE. Maybe IOCTL override callback could help if those are
> really needed.
>
>
> regards
> Antti
>
> On 07/14/2011 11:00 PM, Jose Alberto Reguero wrote:
>>
>> The attached patch try to fix the problems mentioned.
>>
>> Jose Alberto
>>
>> Signed-off-by: Jose Alberto Reguero<jareguero@telefonica.net>
>>
>>
>>
>> ttusb2-3.diff
>>
>>
>> diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c
>> linux.new/drivers/media/dvb/dvb-usb/ttusb2.c
>> --- linux/drivers/media/dvb/dvb-usb/ttusb2.c � �2011-01-10
>> 16:24:45.000000000 +0100
>> +++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c � � � �2011-07-14
>> 12:55:36.645944109 +0200
>> @@ -30,6 +30,7 @@
>> �#include "tda826x.h"
>> �#include "tda10086.h"
>> �#include "tda1002x.h"
>> +#include "tda10048.h"
>> �#include "tda827x.h"
>> �#include "lnbp21.h"
>>
>> @@ -44,6 +45,7 @@
>> �struct ttusb2_state {
>> � � � �u8 id;
>> � � � �u16 last_rc_key;
>> + � � � struct dvb_frontend *fe;
>> �};
>>
>> �static int ttusb2_msg(struct dvb_usb_device *d, u8 cmd,
>> @@ -82,7 +84,7 @@
>> �{
>> � � � �struct dvb_usb_device *d = i2c_get_adapdata(adap);
>> � � � �static u8 obuf[60], ibuf[60];
>> - � � � int i,read;
>> + � � � int i, read1, read2;
>>
>> � � � �if (mutex_lock_interruptible(&d->i2c_mutex)< �0)
>> � � � � � � � �return -EAGAIN;
>> @@ -91,27 +93,33 @@
>> � � � � � � � �warn("more than 2 i2c messages at a time is not handled
>> yet. TODO.");
>>
>> � � � �for (i = 0; i< �num; i++) {
>> - � � � � � � � read = i+1< �num&& �(msg[i+1].flags& �I2C_M_RD);
>> + � � � � � � � read1 = i+1< �num&& �(msg[i+1].flags& �I2C_M_RD);
>> + � � � � � � � read2 = msg[i].flags& �I2C_M_RD;
>>
>> - � � � � � � � obuf[0] = (msg[i].addr<< �1) | read;
>> + � � � � � � � obuf[0] = (msg[i].addr<< �1) | (read1 | read2);
>> � � � � � � � �obuf[1] = msg[i].len;
>>
>> � � � � � � � �/* read request */
>> - � � � � � � � if (read)
>> + � � � � � � � if (read1)
>> � � � � � � � � � � � �obuf[2] = msg[i+1].len;
>> + � � � � � � � else if (read2)
>> + � � � � � � � � � � � obuf[2] = msg[i].len;
>> � � � � � � � �else
>> � � � � � � � � � � � �obuf[2] = 0;
>>
>> - � � � � � � � memcpy(&obuf[3],msg[i].buf,msg[i].len);
>> + � � � � � � � memcpy(&obuf[3], msg[i].buf, msg[i].len);
>>
>> � � � � � � � �if (ttusb2_msg(d, CMD_I2C_XFER, obuf, msg[i].len+3, ibuf,
>> obuf[2] + 3)< �0) {
>> � � � � � � � � � � � �err("i2c transfer failed.");
>> � � � � � � � � � � � �break;
>> � � � � � � � �}
>>
>> - � � � � � � � if (read) {
>> - � � � � � � � � � � � memcpy(msg[i+1].buf,&ibuf[3],msg[i+1].len);
>> - � � � � � � � � � � � i++;
>> + � � � � � � � if (read1 || read2) {
>> + � � � � � � � � � � � if (read1) {
>> + � � � � � � � � � � � � � � � memcpy(msg[i+1].buf,&ibuf[3],
>> msg[i+1].len);
>> + � � � � � � � � � � � � � � � i++;
>> + � � � � � � � � � � � } else if (read2)
>> + � � � � � � � � � � � � � � � memcpy(msg[i].buf,&ibuf[3], msg[i].len);
>> � � � � � � � �}
>> � � � �}
>>
>> @@ -190,6 +198,21 @@
>> � � � �.deltaf = 0xa511,
>> �};
>>
>> +static struct tda10048_config tda10048_config = {
>> + � � � .demod_address � �= 0x10>> �1,
>> + � � � .output_mode � � �= TDA10048_PARALLEL_OUTPUT,
>> + � � � .inversion � � � �= TDA10048_INVERSION_ON,
>> + � � � .dtv6_if_freq_khz = TDA10048_IF_4000,
>> + � � � .dtv7_if_freq_khz = TDA10048_IF_4500,
>> + � � � .dtv8_if_freq_khz = TDA10048_IF_5000,
>> + � � � .clk_freq_khz � � = TDA10048_CLK_16000,
>> + � � � .no_firmware � � �= 1,
>> +};
>> +
>> +static struct tda827x_config tda827x_config = {
>> + � � � .config = 0,
>> +};
>> +
>> �static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
>> �{
>> � � � �if (usb_set_interface(adap->dev->udev,0,3)< �0)
>> @@ -205,18 +228,32 @@
>>
>> �static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *adap)
>> �{
>> +
>> + � � � struct ttusb2_state *state;
>> � � � �if (usb_set_interface(adap->dev->udev, 0, 3)< �0)
>> � � � � � � � �err("set interface to alts=3 failed");
>> + � � � state = (struct ttusb2_state *)adap->dev->priv;
>> � � � �if ((adap->fe =
>> dvb_attach(tda10023_attach,&tda10023_config,&adap->dev->i2c_adap, 0x48)) ==
>> NULL) {
>> � � � � � � � �deb_info("TDA10023 attach failed\n");
>> � � � � � � � �return -ENODEV;
>> � � � �}
>> + � � � adap->fe->id = 1;
>> + � � � tda10048_config.fe = adap->fe;
>> + � � � if ((state->fe =
>> dvb_attach(tda10048_attach,&tda10048_config,&adap->dev->i2c_adap)) == NULL)
>> {
>> + � � � � � � � deb_info("TDA10048 attach failed\n");
>> + � � � � � � � return -ENODEV;
>> + � � � }
>> + � � � dvb_register_frontend(&adap->dvb_adap, state->fe);
>> + � � � if (dvb_attach(tda827x_attach, state->fe,
>> 0x61,&adap->dev->i2c_adap,&tda827x_config) == NULL) {
>> + � � � � � � � printk(KERN_ERR "%s: No tda827x found!\n", __func__);
>> + � � � � � � � return -ENODEV;
>> + � � � }
>> � � � �return 0;
>> �}
>>
>> �static int ttusb2_tuner_tda827x_attach(struct dvb_usb_adapter *adap)
>> �{
>> - � � � if (dvb_attach(tda827x_attach, adap->fe,
>> 0x61,&adap->dev->i2c_adap, NULL) == NULL) {
>> + � � � if (dvb_attach(tda827x_attach, adap->fe,
>> 0x61,&adap->dev->i2c_adap,&tda827x_config) == NULL) {
>> � � � � � � � �printk(KERN_ERR "%s: No tda827x found!\n", __func__);
>> � � � � � � � �return -ENODEV;
>> � � � �}
>> @@ -242,6 +279,19 @@
>> �static struct dvb_usb_device_properties ttusb2_properties_s2400;
>> �static struct dvb_usb_device_properties ttusb2_properties_ct3650;
>>
>> +static void ttusb2_usb_disconnect(struct usb_interface *intf)
>> +{
>> + � � � struct dvb_usb_device *d = usb_get_intfdata(intf);
>> + � � � struct ttusb2_state *state;
>> +
>> + � � � state = (struct ttusb2_state *)d->priv;
>> + � � � if (state->fe) {
>> + � � � � � � � dvb_unregister_frontend(state->fe);
>> + � � � � � � � dvb_frontend_detach(state->fe);
>> + � � � }
>> + � � � dvb_usb_device_exit(intf);
>> +}
>> +
>> �static int ttusb2_probe(struct usb_interface *intf,
>> � � � � � � � �const struct usb_device_id *id)
>> �{
>> @@ -422,7 +472,7 @@
>> �static struct usb_driver ttusb2_driver = {
>> � � � �.name � � � � � = "dvb_usb_ttusb2",
>> � � � �.probe � � � � �= ttusb2_probe,
>> - � � � .disconnect = dvb_usb_device_exit,
>> + � � � .disconnect = ttusb2_usb_disconnect,
>> � � � �.id_table � � � = ttusb2_table,
>> �};
>>
>> diff -ur linux/drivers/media/dvb/frontends/Makefile
>> linux.new/drivers/media/dvb/frontends/Makefile
>> --- linux/drivers/media/dvb/frontends/Makefile �2011-05-06
>> 05:45:29.000000000 +0200
>> +++ linux.new/drivers/media/dvb/frontends/Makefile � � �2011-07-05
>> 01:36:24.621564185 +0200
>> @@ -4,6 +4,7 @@
>>
>> �EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
>> �EXTRA_CFLAGS += -Idrivers/media/common/tuners/
>> +EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb/
>>
>> �stb0899-objs = stb0899_drv.o stb0899_algo.o
>> �stv0900-objs = stv0900_core.o stv0900_sw.o
>> diff -ur linux/drivers/media/dvb/frontends/tda10048.c
>> linux.new/drivers/media/dvb/frontends/tda10048.c
>> --- linux/drivers/media/dvb/frontends/tda10048.c � � � �2010-10-25
>> 01:34:58.000000000 +0200
>> +++ linux.new/drivers/media/dvb/frontends/tda10048.c � �2011-07-05
>> 01:57:47.758466025 +0200
>> @@ -30,6 +30,7 @@
>> �#include "dvb_frontend.h"
>> �#include "dvb_math.h"
>> �#include "tda10048.h"
>> +#include "dvb-usb.h"
>>
>> �#define TDA10048_DEFAULT_FIRMWARE "dvb-fe-tda10048-1.0.fw"
>> �#define TDA10048_DEFAULT_FIRMWARE_SIZE 24878
>> @@ -214,6 +215,8 @@
>> � � � �{ TDA10048_CLK_16000, TDA10048_IF_3800, �10, 3, 0 },
>> � � � �{ TDA10048_CLK_16000, TDA10048_IF_4000, �10, 3, 0 },
>> � � � �{ TDA10048_CLK_16000, TDA10048_IF_4300, �10, 3, 0 },
>> + � � � { TDA10048_CLK_16000, TDA10048_IF_4500, � 5, 3, 0 },
>> + � � � { TDA10048_CLK_16000, TDA10048_IF_5000, � 5, 3, 0 },
>> � � � �{ TDA10048_CLK_16000, TDA10048_IF_36130, 10, 3, 0 },
>> �};
>>
>> @@ -429,6 +432,19 @@
>> � � � �return 0;
>> �}
>>
>> +static int tda10048_set_pll(struct dvb_frontend *fe)
>> +{
>> + � � � struct tda10048_state *state = fe->demodulator_priv;
>> +
>> + � � � dprintk(1, "%s()\n", __func__);
>> +
>> + � � � tda10048_writereg(state, TDA10048_CONF_PLL1, 0x0f);
>> + � � � tda10048_writereg(state, TDA10048_CONF_PLL2,
>> (u8)(state->pll_mfactor));
>> + � � � tda10048_writereg(state, TDA10048_CONF_PLL3,
>> tda10048_readreg(state, TDA10048_CONF_PLL3) | ((u8)(state->pll_nfactor) |
>> 0x40));
>> +
>> + � � � return 0;
>> +}
>> +
>> �static int tda10048_set_if(struct dvb_frontend *fe, enum fe_bandwidth bw)
>> �{
>> � � � �struct tda10048_state *state = fe->demodulator_priv;
>> @@ -478,6 +494,9 @@
>> � � � �dprintk(1, "- pll_nfactor = %d\n", state->pll_nfactor);
>> � � � �dprintk(1, "- pll_pfactor = %d\n", state->pll_pfactor);
>>
>> + � � � /* Set the �pll registers */
>> + � � � tda10048_set_pll(fe);
>> +
>> � � � �/* Calculate the sample frequency */
>> � � � �state->sample_freq = state->xtal_hz * (state->pll_mfactor + 45);
>> � � � �state->sample_freq /= (state->pll_nfactor + 1);
>> @@ -710,12 +729,16 @@
>> � � � �if (config->disable_gate_access)
>> � � � � � � � �return 0;
>>
>> - � � � if (enable)
>> - � � � � � � � return tda10048_writereg(state, TDA10048_CONF_C4_1,
>> - � � � � � � � � � � � tda10048_readreg(state, TDA10048_CONF_C4_1) |
>> 0x02);
>> - � � � else
>> - � � � � � � � return tda10048_writereg(state, TDA10048_CONF_C4_1,
>> - � � � � � � � � � � � tda10048_readreg(state, TDA10048_CONF_C4_1)&
>> �0xfd);
>> + � � � if (config->fe&& �config->fe->ops.i2c_gate_ctrl) {
>> + � � � � � � � return config->fe->ops.i2c_gate_ctrl(config->fe, enable);
>> + � � � } else {
>> + � � � � � � � if (enable)
>> + � � � � � � � � � � � return tda10048_writereg(state,
>> TDA10048_CONF_C4_1,
>> + � � � � � � � � � � � � � � � tda10048_readreg(state,
>> TDA10048_CONF_C4_1) | 0x02);
>> + � � � � � � � else
>> + � � � � � � � � � � � return tda10048_writereg(state,
>> TDA10048_CONF_C4_1,
>> + � � � � � � � � � � � � � � � tda10048_readreg(state,
>> TDA10048_CONF_C4_1)& �0xfd);
>> + � � � }
>> �}
>>
>> �static int tda10048_output_mode(struct dvb_frontend *fe, int serial)
>> @@ -772,20 +795,45 @@
>> � � � �return 0;
>> �}
>>
>> +static int tda10048_sleep(struct dvb_frontend *fe)
>> +{
>> + � � � struct tda10048_state *state = fe->demodulator_priv;
>> + � � � struct tda10048_config *config =&state->config;
>> + � � � struct dvb_usb_adapter *adap;
>> +
>> + � � � dprintk(1, "%s()\n", __func__);
>> +
>> + � � � if (config->fe) {
>> + � � � � � � � adap = fe->dvb->priv;
>> + � � � � � � � if (adap->dev->props.power_ctrl)
>> + � � � � � � � � � � � adap->dev->props.power_ctrl(adap->dev, 0);
>> + � � � }
>> +
>> + � � � return 0;
>> +}
>> +
>> �/* Establish sane defaults and load firmware. */
>> �static int tda10048_init(struct dvb_frontend *fe)
>> �{
>> � � � �struct tda10048_state *state = fe->demodulator_priv;
>> � � � �struct tda10048_config *config =&state->config;
>> + � � � struct dvb_usb_adapter *adap;
>> � � � �int ret = 0, i;
>>
>> � � � �dprintk(1, "%s()\n", __func__);
>>
>> + � � � if (config->fe) {
>> + � � � � � � � adap = fe->dvb->priv;
>> + � � � � � � � if (adap->dev->props.power_ctrl)
>> + � � � � � � � � � � � adap->dev->props.power_ctrl(adap->dev, 1);
>> + � � � }
>> +
>> +
>> � � � �/* Apply register defaults */
>> � � � �for (i = 0; i< �ARRAY_SIZE(init_tab); i++)
>> � � � � � � � �tda10048_writereg(state, init_tab[i].reg,
>> init_tab[i].data);
>>
>> - � � � if (state->fwloaded == 0)
>> + � � � if ((state->fwloaded == 0)&& �(!config->no_firmware))
>> � � � � � � � �ret = tda10048_firmware_upload(fe);
>>
>> � � � �/* Set either serial or parallel */
>> @@ -1174,6 +1222,7 @@
>>
>> � � � �.release = tda10048_release,
>> � � � �.init = tda10048_init,
>> + � � � .sleep = tda10048_sleep,
>> � � � �.i2c_gate_ctrl = tda10048_i2c_gate_ctrl,
>> � � � �.set_frontend = tda10048_set_frontend,
>> � � � �.get_frontend = tda10048_get_frontend,
>> diff -ur linux/drivers/media/dvb/frontends/tda10048.h
>> linux.new/drivers/media/dvb/frontends/tda10048.h
>> --- linux/drivers/media/dvb/frontends/tda10048.h � � � �2010-07-03
>> 23:22:08.000000000 +0200
>> +++ linux.new/drivers/media/dvb/frontends/tda10048.h � �2011-07-05
>> 02:02:42.775466043 +0200
>> @@ -51,6 +51,7 @@
>> �#define TDA10048_IF_4300 �4300
>> �#define TDA10048_IF_4500 �4500
>> �#define TDA10048_IF_4750 �4750
>> +#define TDA10048_IF_5000 �5000
>> �#define TDA10048_IF_36130 36130
>> � � � �u16 dtv6_if_freq_khz;
>> � � � �u16 dtv7_if_freq_khz;
>> @@ -62,6 +63,10 @@
>>
>> � � � �/* Disable I2C gate access */
>> � � � �u8 disable_gate_access;
>> +
>> + � � � u8 no_firmware;
>> +
>> + � � � struct dvb_frontend *fe;
>> �};
>>
>> �#if defined(CONFIG_DVB_TDA10048) || \
>
>
> --
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at �http://vger.kernel.org/majordomo-info.html
>
