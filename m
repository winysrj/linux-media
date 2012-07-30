Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56412 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2G3RHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 13:07:16 -0400
Received: by bkwj10 with SMTP id j10so2926378bkw.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2012 10:07:14 -0700 (PDT)
Message-ID: <5016BF3D.1070104@gmail.com>
Date: Mon, 30 Jul 2012 19:07:09 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: David Basden <davidb-git@rcpt.to>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	Hans-Frieder Vogt <hfvogt@gmx.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: rtl28xxu - rtl2832 frontend attach
References: <4FB92428.3080201@gmail.com> <4FB94F2C.4050905@iki.fi> <4FB95E4B.9090006@googlemail.com> <4FC0443F.8030004@gmail.com> <4FC32233.1040407@googlemail.com> <4FC3902D.3090506@googlemail.com> <4FE9EEB4.9010005@gmail.com> <4FEA9849.5010105@googlemail.com> <5016328E.3040909@gmail.com> <20120730125647.GJ9047@faith.oztechninja.com>
In-Reply-To: <20120730125647.GJ9047@faith.oztechninja.com>
Content-Type: multipart/mixed;
 boundary="------------070304040201090605000908"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070304040201090605000908
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 07/30/2012 02:56 PM, David Basden wrote:
>>>>> Right now I really don't know where I should look for the solution of
>>>>> the problem. It seems that the tuner reset does not have any effect on the 
>>>>> tuner whatsoever.
> 
> Can I suggest setting GPIO5 to 1, leave it there, and see if it breaks. If it
> doesn't, GPIO5 on the RTL isn't setup correctly somehow.
> 
> At the same time, I was rereading code from:
> 
> http://git.linuxtv.org/anttip/media_tree.git/blob/3efd26330fda97e06279cbca170ae4a0dee53220:/drivers/media/dvb/dvb-usb/rtl28xxu.c#l898
> 
> and at no point is GPIO5 actually set to an output or enabled that I can find.
> rtl2832u_frontend_attach skips doing so. (Actually, I seem to remember running
> into this problem while trying to use some DVB driver code as an example of
> how to setup the RTL to talk to the FC0012)
> 
> Try giving the patch below a go. Sorry, I don't have a build environment to
> hand, so there might be a typo I haven't picked up, but the upshot is that 
> I'm moving the FC0012 detection to the end, setting up GPIO5, resetting the
> tuner and then trying to probe for the FC0012.
> 
> Please let me know if this helps :)
> 
> David
> 
> --- a/rtl28xxu.c	2012-07-30 22:31:53.789638678 +1000
> +++ b/rtl28xxu.c	2012-07-30 22:48:35.774607232 +1000
> @@ -550,15 +550,6 @@
>  
>  	priv->tuner = TUNER_NONE;
>  
> -	/* check FC0012 ID register; reg=00 val=a1 */
> -	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0012);
> -	if (ret == 0 && buf[0] == 0xa1) {
> -		priv->tuner = TUNER_RTL2832_FC0012;
> -		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
> -		info("%s: FC0012 tuner found", __func__);
> -		goto found;
> -	}
> -
>  	/* check FC0013 ID register; reg=00 val=a3 */
>  	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0013);
>  	if (ret == 0 && buf[0] == 0xa3) {
> @@ -640,6 +631,71 @@
>  		goto unsupported;
>  	}
>  
> +	/* If it's a FC0012, we need to bring GPIO5/RESET
> +	   out of floating or it's not going to show up.
> +	   We set GPIO5 to an output, enable the output, then
> +	   reset the tuner by bringing GPIO5 high then low again.
> +
> +	   We're testing this last so that we don't accidentally
> +	   mess with other hardware that wouldn't like us messing
> +	   with whatever is connected to the rtl2832's GPIO5
> +	*/
> +
> +	/* close demod I2C gate */
> +	ret = rtl28xxu_ctrl_msg(adap->dev, &req_gate_close);
> +	if (ret)
> +		goto err;
> +
> +	/* Set GPIO5 to be an output */
> +	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_DIR, &val);
> +	if (ret)
> +		goto err;
> +
> +	val &= 0xdf;
> +	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_DIR, val);
> +	if (ret)
> +		goto err;
> +
> +	/* enable as output GPIO5 */
> +	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_OUT_EN, &val);
> +	if (ret)
> +		goto err;
> +
> +	val |= 0x20;
> +	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_EN, val);
> +	if (ret)
> +		goto err;
> +
> +	/* set GPIO5 high to reset fc0012 (if it exists) */
> +	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_OUT_VAL, &val);
> +	if (ret)
> +		goto err;
> +
> +	val |= 0x20; 
> +	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_VAL, val);
> +	if (ret)
> +		goto err;
> +
> +	/* bring GPIO5 low again after reset */
> +	val &= 0xdf;
> +	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_VAL, val);
> +	if (ret)
> +		goto err;
> +
> +	/* re-open demod I2C gate */
> +	ret = rtl28xxu_ctrl_msg(adap->dev, &req_gate_open);
> +	if (ret)
> +		goto err;
> +
> +	/* check FC0012 ID register; reg=00 val=a1 */
> +	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0012);
> +	if (ret == 0 && buf[0] == 0xa1) {
> +		priv->tuner = TUNER_RTL2832_FC0012;
> +		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
> +		info("%s: FC0012 tuner found", __func__);
> +		goto found;
> +	}
> +
>  unsupported:
>  	/* close demod I2C gate */
>  	ret = rtl28xxu_ctrl_msg(adap->dev, &req_gate_close);
> 

�sorry for the delay,
After applied patch no luck - in attach is dmesg for working original
Realtek driver(dvb_usb_rtl2832), and second one(dvb-usb-rtl28xxu)
rtl2832 part by Thomas with tuner issue, still not working.
Most intriguing is tuner get stucked by tuning(t-zapping)!

Cheers,
poma

ps.
Thank you so far, really thorough explanation!




--------------070304040201090605000908
Content-Type: text/plain; charset=UTF-8;
 name="dvb-usb-rtl28xxu-dmesg.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="dvb-usb-rtl28xxu-dmesg.txt"


dvb-usb-rtl28xxu-dmesg.txt
…
rtl28xxu_module_init:
rtl28xxu_probe: interface=0
check for warm bda 2831
check for warm 14aa 160
check for warm 14aa 161
something went very wrong, device was not found in current device list - let's see what comes next.
check for warm ccd a9
check for warm 1f4d b803
dvb-usb: found a 'G-Tek Electronics Group Lifeview LV5TDLX DVB-T' in warm state.
power control: 1
rtl2832u_power_ctrl: onoff=1
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
all in all I will use 24576 bytes for streaming
allocating buffer 0
buffer 0: ffff8800cf827000 (dma: 3481432064)
allocating buffer 1
buffer 1: ffff8800cf828000 (dma: 3481436160)
allocating buffer 2
buffer 2: ffff8800cf829000 (dma: 3481440256)
allocating buffer 3
buffer 3: ffff8800cf82a000 (dma: 3481444352)
allocating buffer 4
buffer 4: ffff8800cf82b000 (dma: 3481448448)
allocating buffer 5
buffer 5: ffff8800cf82c000 (dma: 3481452544)
allocation successful
DVB: registering new adapter (G-Tek Electronics Group Lifeview LV5TDLX DVB-T)
DVB: register adapter0/demux0 @ minor: 0 (0x00)
DVB: register adapter0/dvr0 @ minor: 1 (0x01)
DVB: register adapter0/net0 @ minor: 2 (0x02)
rtl2832u_frontend_attach:
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
No compatible tuner found
dvb-usb: no frontend was attached by 'G-Tek Electronics Group Lifeview LV5TDLX DVB-T'
Registered IR keymap rc-empty
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:04.1/usb2/2-3/rc/rc0/input12
rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:04.1/usb2/2-3/rc/rc0
dvb-usb: schedule remote query interval to 400 msecs.
power control: 0
rtl2832u_power_ctrl: onoff=0
dvb-usb: G-Tek Electronics Group Lifeview LV5TDLX DVB-T successfully initialized and connected.
rtl28xxu_probe: interface=1
usbcore: registered new interface driver dvb_usb_rtl28xxu
…


--------------070304040201090605000908
Content-Type: text/plain; charset=UTF-8;
 name="dvb_usb_rtl2832-dmesg.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="dvb_usb_rtl2832-dmesg.txt"


dvb_usb_rtl2832-dmesg.txt
…
+info debug open_rtl2832u_usb_module_init
dvb-usb: found a 'DVB-T TV Stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (DVB-T TV Stick)
DVB: register adapter0/demux0 @ minor: 0 (0x00)
DVB: register adapter0/dvr0 @ minor: 1 (0x01)
DVB: register adapter0/net0 @ minor: 2 (0x02)
+rtl2832u_fe_attach : chialing 0409-1
 +usb_init_setting 
 +usb_init_bulk_setting 
RTL2832U usb_init_bulk_setting : USB2.0 HIGH SPEED (480Mb/s)
 -usb_init_bulk_setting 
 +usb_epa_fifo_reset 
 -usb_epa_fifo_reset 
 -usb_init_setting 
 +gpio3_out_setting 
 -gpio3_out_setting 
 +demod_ctl1_setting 
 -demod_ctl1_setting 
 +suspend_latch_setting 
 -suspend_latch_setting 
 +demod_ctl_setting 
 -demod_ctl_setting 
 +set_tuner_power 
 -set_tuner_power 
 +check_tuner_type
error!! read_rtl2832_tuner_register: ret=-32, DA=0xc0, len=1, offset=0x0, data=(
0xf8,
)
error!! read_rtl2832_tuner_register: ret=-32, DA=0xac, len=1, offset=0x1, data=(
0xf8,
)
error!! read_rtl2832_tuner_register: ret=-32, DA=0xc0, len=1, offset=0x0, data=(
0xf8,
)
error!! read_rtl2832_tuner_register: ret=-32, DA=0xc0, len=1, offset=0x0, data=(
0xf8,
)
error!! read_rtl2832_tuner_register: ret=-32, DA=0xc0, len=2, offset=0x7e, data=(
0xf8,
0xd,
)
error try= 1!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, data=(
0xfb,
0xd9,
)
error try= 2!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, data=(
0xfb,
0xd9,
)
error try= 3!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, data=(
0xfb,
0xd9,
)
error try= 4!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, data=(
0xfb,
0xd9,
)
error try= 5!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, data=(
0xfb,
0xd9,
)
error try= 1!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(
0x8,
)
error try= 2!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(
0x8,
)
error try= 3!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(
0x8,
)
error try= 4!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(
0x8,
)
error try= 5!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(
0x8,
)
RTL2832U check_tuner_type : FC0012 tuner on board...
 +check_dtmb_support 
 +set_demod_2836_power  onoff = 1
error!! read_demod_register: ret=-32, DA=0x3e, len=1, page=0, offset=0x1, data=(
0xa0,
)
 -set_demod_2836_power  onoff = 1 fail
error!! read_demod_register: ret=-32, DA=0x3e, len=2, page=5, offset=0x10, data=(
0xfb,
0xd9,
)
 -check_dtmb_support  RTL2836 NOT FOUND.....
 +set_demod_2836_power  onoff = 0
error!! read_demod_register: ret=-32, DA=0x3e, len=1, page=0, offset=0x1, data=(
0xa0,
)
 -set_demod_2836_power  onoff = 0 fail
 -check_dtmb_support 
 +check_dvbc_support 
 +set_demod_2840_power  onoff = 1
 +rtl2840_on_hwreset 
error!! read_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x1, data=(
0x25,
)
error!! read_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x1, data=(
0x25,
)
 +rtl2840_on_hwreset  Page 0, addr 0x01 = 0x25
error!! read_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x1, data=(
0x25,
)
 +rtl2840_on_hwreset  Page 0, addr 0x01 = 0x25
 -rtl2840_on_hwreset 
error!! read_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0x25,
)
error try = 1!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0xa5,
)
error try = 2!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0xa5,
)
error try = 3!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0xa5,
)
error try = 4!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0xa5,
)
error try = 5!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0xa5,
)
 -set_demod_2840_power  onoff = 1
error!! read_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0x10,
)
 -check_dvbc_support  RTL2840 NOT FOUND.....
 +set_demod_2840_power  onoff = 0
error!! read_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0x25,
)
error try = 1!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0x25,
)
error try = 2!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0x25,
)
error try = 3!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0x25,
)
error try = 4!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0x25,
)
error try = 5!! write_demod_register: ret=-32, DA=0x44, len=1, page=0, offset=0x4, data=(
0x25,
)
 -set_demod_2840_power  onoff = 0
 -check_dvbc_support 
demod_type is 0
 +build_nim_module
 +build_2832_nim_module
 build_2832_nim_module BuildRtl2832Fc0012Module
 -build_2832_nim_module
 -build_nim_module
-rtl2832u_fe_attach
dvb_register_frontend
DVB: registering adapter 0 frontend 0 (Realtek DVB-T RTL2832)...
DVB: register adapter0/frontend0 @ minor: 3 (0x03)
dvb_frontend_clear_cache() Clearing cache for delivery system 3
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:04.1/usb2/2-3/input/input13
dvb-usb: schedule remote query interval to 287 msecs.
dvb-usb: DVB-T TV Stick successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_rtl2832u
…


--------------070304040201090605000908--
