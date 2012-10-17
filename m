Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28089 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2JQRyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 13:54:49 -0400
Message-ID: <507EF0E5.6030308@austin.rr.com>
Date: Wed, 17 Oct 2012 12:54:45 -0500
From: Keith Pyle <kpyle@austin.rr.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: HD-PVR fails consistently on Linux, works on Windows
References: <5063BD18.4060309@austin.rr.com>
In-Reply-To: <5063BD18.4060309@austin.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/12 21:42, Keith Pyle wrote:
> I recently purchased a Hauppauge HD-PVR (the 1212 version, label on 
> bottom 49001LF, Rev F2).  I have consistent capture failures on Linux 
> where data from the device simply stops, generally within a few 
> minutes of starting a capture.  Yet, the device works flawlessly on 
> Windows with the same USB and component cables, same power supply, and 
> same physical position.  This suggests that the device itself has 
> acceptable power, is not overheating, etc.  I'll detail below the 
> testing I've done thus far and would appreciate any suggestions on how 
> to further test or address the problem.
>
> The good news is that I have a highly reproducible failure on Linux, 
> but then that's the bad news too.
>
> Thanks.
>
> Keith
>
> -- Linux tests --
> I started trying to use the HD-PVR directly with my MythTV backend. I 
> have subsequently switched all of my testing to simple direct captures 
> from the /dev/video? device using /bin/cat to eliminate as many 
> variables as possible.
>
> I've done a large number of tests with combinations of the following:
>
> OS: gentoo 3.4.7, gentoo 3.5.4
> HD-PVR firmware: 1.5.7.0 (0x15), 1.7.1.30059 (0x1e)
> Input resolution: fixed to 720p, fixed to 1080i, floating based on input
> USB ports: motherboard ports on Intel DP45SG, motherboard ports on MSI 
> X58 Pro-E, ports on SIIG USB PCIe card
>
> Captures fail consistently.
Here's some interesting new information.  On noticing that the 3.6 
kernel included several USB related commits, I updated the kernel of my 
test system (MSI X58 Pro-E) from 3.5.4 to 3.6.2.  I ran a series of 
capture tests with firmware 0x1e and all other variables exactly as 
before - same USB cable, port, physical position, etc.  I have 20 
successful 1-hour captures and 1 failure.  There are no logged messages 
for the failed capture but the timing coincides within a minute after 
initializing a wireless joystick on a different USB bus.  I've been 
unable to reproduce this failure, so I cannot conclusively state that 
there is a correlation.

The results of the kernel change are dramatic.  Under 3.5.x and earlier, 
the failure rate for 1-hour captures was 100%.  Most failed in less than 
10 minutes.  There were some instances of hard hangs on the HD-PVR 
(i.e., power cycle required).  With 3.6.2, it is less than 5% failure.  
The one failure was a truncated recording.

I am continuing capture tests on my test system to build more data. I 
will next be updating my MythTV backend to 3.6 and trying the capture 
tests on it since it has a different motherboard.

It would be quite interesting if others with HD-PVR problems see similar 
results for 3.6.2 or better.

Keith
