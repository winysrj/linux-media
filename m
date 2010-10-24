Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57345 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab0JXO13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 10:27:29 -0400
Received: by mail-ww0-f44.google.com with SMTP id 15so2607723wwe.1
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 07:27:28 -0700 (PDT)
From: Albin Kauffmann <albin.kauffmann@gmail.com>
To: fabio tirapelle <ftirapelle@yahoo.it>,
	Sasha Sirotkin <demiurg@femtolinux.com>
Subject: Re: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
Date: Sun, 24 Oct 2010 16:27:21 +0200
Cc: linux-media@vger.kernel.org
References: <259225.84971.qm@web25402.mail.ukl.yahoo.com> <201010192032.50484.albin.kauffmann@gmail.com> <968618.5175.qm@web25407.mail.ukl.yahoo.com>
In-Reply-To: <968618.5175.qm@web25407.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010241627.22121.albin.kauffmann@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 19 October 2010 21:56:51 fabio tirapelle wrote:
> The WinTV did work correctly with ubuntu 9.10. In Ubuntu 9.10 the
> package linux-firmware-nonfree didn't include the dvb-fe-tda10048-1.0.fw. I
> remember that Ubuntu 9.10 used for my card the dvb-fe-tda10046.fw.
> 
> Now, Ubuntu 10.04 loads for my card the dvb-fe-tda10048-1.0.fw
> Its seems that with the 9.10 version, the card is recognized as
> WinTV-HVR-1100 or 1110 and now as WinTV-HVR-1120.

This is actually strange because the Wiki states that the card is using an 
"NXP TDA10048 digital demodulator" 
(http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1120). Anyway, this may 
worth the cost to build an old kernel to see if this effectively works well ;)

> I wait until you recompile the kernel  with the v4l. Please tell me if this
> solves the problem

I have tried several scenarios :
 - the last 2.6.36 Linux kernel
 - the kernel 2.6.35 with sources from the HG repository 
(http://linuxtv.org/hg/v4l-dvb/)
 - the media tree git (http://git.linuxtv.org/media_tree.git)

In all situations, I get the same behaviour. After a random number of reboots, 
the TV (DVB-T) is not working and I get this message displayed in loop in 
`dmesg`:

tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
tda18271_init: [1-0060|M] error -5 on line 830
tda18271_tune: [1-0060|M] error -5 on line 908
tda18271_set_params: [1-0060|M] error -5 on line 989

Also, even when the TV is working, I get these error messages in `dmesg:

[...]
tda829x 1-004b: type set to tda8290
tda18271 1-0060: attaching existing instance
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
tda10048_firmware_upload: waiting for firmware upload (dvb-fe-
tda10048-1.0.fw)...
tda10048_firmware_upload: firmware read 24878 bytes.
tda10048_firmware_upload: firmware uploading
tda18271_write_regs: [1-0060|M] ERROR: idx = 0x13, len = 1, i2c_transfer 
returned: -5
tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
tda18271_set_analog_params: [1-0060|M] error -5 on line 1045
tda18271_write_regs: [1-0060|M] ERROR: idx = 0x13, len = 1, i2c_transfer 
returned: -5
tda10048_firmware_upload: firmware uploaded
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xeb200000 irq 20 registered as card -1
tda18271_read_regs: [1-0060|M] ERROR: i2c_transfer returned: -5
tda18271_ir_cal_init: [1-0060|M] error -5 on line 811
tda18271_init: [1-0060|M] error -5 on line 835
tda18271_tune: [1-0060|M] error -5 on line 908
tda18271_set_analog_params: [1-0060|M] error -5 on line 1045


I may take a look at sources to understand what is happening. So, if someone 
have an idea, please tell me ;)

Thanks,

-- 
Albin Kauffmann
