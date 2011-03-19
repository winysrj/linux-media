Return-path: <mchehab@pedra>
Received: from fmmailgate02.web.de ([217.72.192.227]:36499 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1CSTNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2011 15:13:33 -0400
Message-ID: <4D85005A.4080101@web.de>
Date: Sat, 19 Mar 2011 20:13:30 +0100
From: =?UTF-8?B?QW5kcsOpIFdlaWRlbWFubg==?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: Jochen Reinwand <Jochen.Reinwand@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: Remote control TechnoTrend TT-connect S2-3650 CI
References: <201103191940.20876.Jochen.Reinwand@gmx.de>
In-Reply-To: <201103191940.20876.Jochen.Reinwand@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jochen,

On 19.03.2011 19:40, Jochen Reinwand wrote:
> I'm using a TechnoTrend TT-connect S2-3650 CI. The S2API support is great! I
> do not have any problems watching DVB-S and DVB-S2 content. Tuning is quite
> fast! It's working much better than my Hauppauge WinTV Nova-TD, but that's a
> different story...
>
> The only severe problem I have with the TechnoTrend is related to the remote
> control. Around 30% of the key presses produce two key events. It's not
> related to any lirc or X11 configuration issue. I verified it using the tool
> input-events on the device. There are really two separate events coming from
> the device.
>
> Is this due to a hardware problem, or is it a driver issue? My C and Kernel
> knowledge is not really the best. But there is some code in dvb-usb-remote.c
> that seems to be related to key repeats. Are the dvb remote input devices
> doing something special here? I'm also not able to modify behaviour of the
> device via "xset r rate" when using it as X11 input device. It's only
> affecting the real keyboard that is also attached.

I don't think that this is a hardware problem. I think it is related to 
the driver. When I added support for the S2-3650CI to Dominik Kuhlen's 
code for the PC-TV452e, I used the RC-code function "pctv452e_rc_query" 
for the S2-3650CI. I ran into this problem back then and thought that 
setting .rc_interval to 500 would "fix" the problem good enough. Since I 
never used the supplied remote with my box, I never looked into the 
problem again.

Unfortunately I do not know how to fix this problem. If anyone has some 
insights on reading remote control inputs, please take a look here and 
see if you can fix the problem:
http://mercurial.intuxication.org/hg/s2-liplianin/file/7e47ba1d4ae8/linux/drivers/media/dvb/dvb-usb/pctv452e.c#l1355
The remote is the same as the one shipped with the TT-S1500. So the code 
for reading the remote input should already exist.

Regards
  André
