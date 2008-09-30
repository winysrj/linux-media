Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.emergencycommunicationsystems.com ([24.123.23.170]
	helo=unifiedpaging.messagenetsystems.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rob.krakora@messagenetsystems.com>)
	id 1KkgfT-00088A-9H
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 16:57:40 +0200
Message-ID: <48E23E55.4080706@messagenetsystems.com>
Date: Tue, 30 Sep 2008 10:57:25 -0400
From: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48E23B85.10208@messagenetsystems.com>
In-Reply-To: <48E23B85.10208@messagenetsystems.com>
Cc: geisj@messagenetsystems.com
Subject: Re: [linux-dvb] [Fwd: [Alsa-user] alsa kernel module versioning
	problem]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Robert Vincent Krakora wrote:
> Hello,
>
> I am experiencing the same problem as described in the link below. How 
> does one play with the #ifdefs in the compat.h file to negate these 
> errors?
>
> http://www.linuxtv.org/pipermail/linux-dvb/2006-September/012747.html
>
> Thanks in advance.
>
> Best Regards,
>
> ------------------------------------------------------------------------
>
> Subject:
> [Alsa-user] alsa kernel module versioning problem
> From:
> Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
> Date:
> Tue, 23 Sep 2008 16:01:55 -0400
> To:
> alsa-user@lists.sourceforge.net, geisj@messagenetsystems.com
>
> To:
> alsa-user@lists.sourceforge.net, geisj@messagenetsystems.com
>
>
> I am running alsa on CentOS5 and get the following errors from em28xx_audio:
>
> How can this be resolved?
>
> em28xx v4l2 driver version 0.0.1 loaded
> em28xx new video device (2040:6513): interface 0, class 255
> em28xx: device is attached to a USB 2.0 bus
> em28xx: you're using the experimental/unstable tree from mcentral.de
> em28xx: there's also a stable tree available but which is limited to
> em28xx: linux <=2.6.19.2
> em28xx: it's fine to use this driver but keep in mind that it will move
> em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
> em28xx: proved to be stable
> em28xx #0: Alternate settings: 8
> em28xx #0: Alternate setting 0, max size= 0
> em28xx #0: Alternate setting 1, max size= 0
> em28xx #0: Alternate setting 2, max size= 1448
> em28xx #0: Alternate setting 3, max size= 2048
> em28xx #0: Alternate setting 4, max size= 2304
> em28xx #0: Alternate setting 5, max size= 2580
> em28xx #0: Alternate setting 6, max size= 2892
> em28xx #0: Alternate setting 7, max size= 3072
> attach_inform: eeprom detected.
> em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
> em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
> em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
> em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
> em28xx #0: i2c eeprom 70: 32 00 38 00 35 00 33 00 34 00 37 00 37 00 37 00
> em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
> em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
> em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
> em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 f9 8f
> em28xx #0: i2c eeprom c0: 1e f0 74 02 01 00 01 79 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
> em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 f9 8f
> em28xx #0: i2c eeprom f0: 1e f0 74 02 01 00 01 79 00 00 00 00 00 00 00 00
> EEPROM ID= 0x9567eb1a
> Vendor/Product ID= 2040:6513
> AC97 audio (5 sample rates)
> 500mA max power
> Table at 0x24, strings=0x1e82, 0x186a, 0x0000
> tveeprom 2-0050: Hauppauge model 65201, rev A1C0, serial# 2002937
> tveeprom 2-0050: tuner model is Xceive XC3028 (idx 120, type 71)
> tveeprom 2-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB 
> Digital (eeprom 0xd4)
> tveeprom 2-0050: audio processor is None (idx 0)
> tveeprom 2-0050: has radio
> tuner 2-0061: chip found @ 0xc2 (em28xx #0)
> attach inform (default): detected I2C address c2
> /home/silentm/MessageNet/v4l-dvb-kernel-cd030297f684/v4l/tuner-core.c: 
> setting tuner callback
> tuner 0x61: Configuration acknowledged
> /home/silentm/MessageNet/v4l-dvb-kernel-cd030297f684/v4l/tuner-core.c: 
> setting tuner callback
> /home/silentm/MessageNet/v4l-dvb-kernel-cd030297f684/v4l/xc3028-tuner.c: 
> attach request!
> /home/silentm/MessageNet/v4l-dvb-kernel-cd030297f684/v4l/tuner-core.c: 
> xc3028 tuner successfully loaded
> attach_inform: tvp5150 detected.
> tvp5150 2-005c: tvp5150am1 detected.
> Loading base firmware: xc3028_init0.i2c.fw
> Loading default analogue TV settings: xc3028_BG_PAL_A2_A.i2c.fw
> xc3028-tuner.c: firmware 2.7
> ANALOG TV REQUEST
> em28xx #0: V4L2 device registered as /dev/video0
> em28xx #0: Found Hauppauge WinTV HVR 950
> usbcore: registered new driver em28xx
> em28xx_audio: disagrees about version of symbol snd_pcm_new
> em28xx_audio: Unknown symbol snd_pcm_new
> em28xx_audio: disagrees about version of symbol snd_card_register
> em28xx_audio: Unknown symbol snd_card_register
> em28xx_audio: disagrees about version of symbol snd_card_free
> em28xx_audio: Unknown symbol snd_card_free
> em28xx_audio: disagrees about version of symbol snd_card_new
> em28xx_audio: Unknown symbol snd_card_new
> em28xx_audio: disagrees about version of symbol snd_pcm_lib_ioctl
> em28xx_audio: Unknown symbol snd_pcm_lib_ioctl
> em28xx_audio: disagrees about version of symbol snd_pcm_set_ops
> em28xx_audio: Unknown symbol snd_pcm_set_ops
> em28xx_audio: disagrees about version of symbol 
> snd_pcm_hw_constraint_integer
> em28xx_audio: Unknown symbol snd_pcm_hw_constraint_integer
> em28xx_audio: disagrees about version of symbol snd_pcm_period_elapsed
> em28xx_audio: Unknown symbol snd_pcm_period_elapsed
> em2880-dvb.c: DVB Init
> Loading base firmware: xc3028_8MHz_init0.i2c.fw
> Loading default dtv settings: xc3028_DTV8_2633.i2c.fw
> xc3028-tuner.c: firmware 2.7
> Sending extra call for Digital TV!
> /home/silentm/MessageNet/v4l-dvb-kernel-cd030297f684/v4l/xc3028-tuner.c: 
> attach request!
> DVB: registering new adapter (em2880 DVB-T)
> DVB: registering frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
> Em28xx: Initialized (Em2880 DVB Extension) extension
> [
>   


-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
