Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46713 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761139AbZE2Vk3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 17:40:29 -0400
Subject: Re: [v4l-dvb-maintainer] tuner-xc2028.c for Taiwan DVB-T
 BANDWIDTH_6_MHZ
From: Andy Walls <awalls@radix.net>
To: Terry Wu <terrywu2009@gmail.com>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
In-Reply-To: <6ab2c27e0905270450s51e41413k95fadbc5820ad353@mail.gmail.com>
References: <6ab2c27e0905270450s51e41413k95fadbc5820ad353@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 17:41:58 -0400
Message-Id: <1243633318.3185.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terry,

The linux-media list is the appropriate place for posting patches (I've
Cc:'ed the list).  v4l-dvb-maintainer is inactive as far as I know.

Guidelines for posting patches can be found here:

http://www.linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

Regards,
Andy


On Wed, 2009-05-27 at 19:50 +0800, Terry Wu wrote:
> Hi,
> 
> Here is the modified
> v4l-dvb/linux/drivers/media/common/tuners/tuner-xc2028.c
>  for Taiwan DVB-T (BANDWIDTH_6_MHZ) :
> http://tw1965.myweb.hinet.net/
> http://tw1965.myweb.hinet.net/Linux/v4l-dvb/tuners/tuner-xc2028.c
> static int xc2028_set_params(struct dvb_frontend *fe,
>      struct dvb_frontend_parameters *p)
> {
> struct xc2028_data *priv = fe->tuner_priv;
> unsigned int       type=0;
> fe_bandwidth_t     bw = BANDWIDTH_8_MHZ;
> u16                demod = 0;
> 
> tuner_dbg("%s called\n", __func__);
> 
> switch(fe->ops.info.type) {
> case FE_OFDM:
> bw = p->u.ofdm.bandwidth;
> 
> if (bw == BANDWIDTH_6_MHZ) /* Terry Wu added for Taiwan DVB-T 6MHz bandwidth
> */
>                 {
>     type |= (DTV6 | QAM | D2633);
>     priv->ctrl.type = XC2028_D2633;
>                 }
> 
> break;
> case FE_QAM:
> tuner_info("WARN: There are some reports that "
>    "QAM 6 MHz doesn't work.\n"
>    "If this works for you, please report by "
>    "e-mail to: v4l-dvb-maintainer@linuxtv.org\n");
> bw = BANDWIDTH_6_MHZ;
> type |= QAM;
> break;
> ...
> static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
>     enum tuner_mode new_mode,
>     unsigned int type,
>     v4l2_std_id std,
>     u16 int_freq)
> {
> struct xc2028_data *priv = fe->tuner_priv;
> int    rc = -EINVAL;
> unsigned char    buf[4];
> u32    div, offset = 0;
> 
> tuner_dbg("%s called\n", __func__);
> 
> mutex_lock(&priv->lock);
> 
> tuner_dbg("should set frequency %d kHz\n", freq / 1000);
> 
> if (check_firmware(fe, type, std, int_freq) < 0)
> goto ret;
> 
> /* On some cases xc2028 can disable video output, if
> * very weak signals are received. By sending a soft
> * reset, this is re-enabled. So, it is better to always
> * send a soft reset before changing channels, to be sure
> * that xc2028 will be in a safe state.
> * Maybe this might also be needed for DTV.
> */
> if (new_mode == T_ANALOG_TV) {
> rc = send_seq(priv, {0x00, 0x00});
> } else if (priv->cur_fw.type & ATSC) {
> offset = 1750000;
> } else if (priv->cur_fw.type & DTV6) { /* Terry Wu added for Taiwan DVB-T
> 6MHz bandwidth */
> offset = 1750000; /* Terry Wu added for Taiwan DVB-T 6MHz bandwidth */
> } else {
> offset = 2750000;
> /*
> * We must adjust the offset by 500kHz in two cases in order
> * to correctly center the IF output:
> * 1) When the ZARLINK456 or DIBCOM52 tables were explicitly
> *    selected and a 7MHz channel is tuned;
> * 2) When tuning a VHF channel with DTV78 firmware.
> */
> if (((priv->cur_fw.type & DTV7) &&
>      (priv->cur_fw.scode_table & (ZARLINK456 | DIBCOM52))) ||
>     ((priv->cur_fw.type & DTV78) && freq < 470000000))
> offset -= 500000;
> }
> 
> div = (freq - offset + DIV / 2) / DIV;
> 
> 
> Terry


