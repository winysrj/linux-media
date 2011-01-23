Return-path: <mchehab@pedra>
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:58249 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1AWVul (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 16:50:41 -0500
Date: Sun, 23 Jan 2011 21:50:39 +0000 (GMT)
From: Alex Butcher <linuxtv@assursys.co.uk>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
cc: linux-media@vger.kernel.org
Subject: Re: Hauppauge Nova-T-500; losing one tuner. Regression?
In-Reply-To: <alpine.LFD.2.00.1101232038420.26778@sbhezbfg.of5.nffheflf.cev>
Message-ID: <alpine.LFD.2.00.1101232144230.26778@sbhezbfg.of5.nffheflf.cev>
References: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev> <AANLkTimtKKJkA35tn=wv+sONgWaUxjFcAQWfLfYzSOLW@mail.gmail.com> <alpine.LFD.2.00.1101232038420.26778@sbhezbfg.of5.nffheflf.cev>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 23 Jan 2011, Alex Butcher wrote:

>>> Can anyone offer any tips for regaining reliability? Failing that, is 
>>> there
>>> any further logging I can enable, and entries to look out for?
>> 
>> Exactly what errors are you seeing? I2c write errors in dmesg?
>
> No, nothing in the kernel logs, which is what I would expect if the hardware
> was crashing in some way.  Maybe it /was/ just that MythTV was using a tuner
> for EIT and so it couldn't stop the EIT scan to use it for a recording after
> all.

I'll amend that; I am seeing some i2c *read* errors:

# grep "dvb-usb: found a\|i2c" /var/log/kernel
Jan 23 09:35:11 mythtv kernel: [    8.520863] dvb-usb: found a 'Hauppauge
# Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware
Jan 23 09:35:11 mythtv kernel: [    9.281841] dvb-usb: found a 'Hauppauge
# Nova-T 500 Dual DVB-T' in warm state.
Jan 23 09:35:11 mythtv kernel: [    9.331015] DiB3000MC/P:i2c read error on
# 1025
Jan 23 09:35:11 mythtv kernel: [    9.344553] DiB3000MC/P:i2c read error on
# 1025
Jan 23 09:57:27 mythtv kernel: [    9.492571] dvb-usb: found a 'Hauppauge
# Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware
Jan 23 09:57:27 mythtv kernel: [   10.753056] dvb-usb: found a 'Hauppauge
# Nova-T 500 Dual DVB-T' in warm state.
Jan 23 09:57:27 mythtv kernel: [   10.798487] DiB3000MC/P:i2c read error on
# 1025
Jan 23 09:57:27 mythtv kernel: [   10.812815] DiB3000MC/P:i2c read error on
# 1025
Jan 23 10:17:20 mythtv kernel: [    8.918463] dvb-usb: found a 'Hauppauge
# Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware
Jan 23 10:17:20 mythtv kernel: [    9.951017] dvb-usb: found a 'Hauppauge
# Nova-T 500 Dual DVB-T' in warm state.
Jan 23 10:17:20 mythtv kernel: [   10.000206] DiB3000MC/P:i2c read error on
# 1025
Jan 23 10:17:20 mythtv kernel: [   10.013195] DiB3000MC/P:i2c read error on
# 1025
Jan 23 12:18:34 mythtv kernel: [    9.625172] dvb-usb: found a 'Hauppauge
# Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware
Jan 23 12:18:34 mythtv kernel: [   10.372691] dvb-usb: found a 'Hauppauge
# Nova-T 500 Dual DVB-T' in warm state.
Jan 23 12:18:34 mythtv kernel: [   10.418135] DiB3000MC/P:i2c read error on
# 1025
Jan 23 12:18:34 mythtv kernel: [   10.431338] DiB3000MC/P:i2c read error on
# 1025

But the timings don't seem to correspond with the start time of the failed
recordings, only boots. I'd written them off as being "normal", but in the
interests of completeness...

Best Regards,
Alex

