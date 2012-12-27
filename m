Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51690 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2L0ODN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 09:03:13 -0500
Received: by mail-wi0-f178.google.com with SMTP id hn3so5373817wib.11
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 06:03:11 -0800 (PST)
Subject: Re: HD-PVR fails consistently on Linux, works on Windows
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: =?iso-8859-1?Q?David_R=F6thlisberger?= <david@rothlis.net>
In-Reply-To: <507EF0E5.6030308@austin.rr.com>
Date: Thu, 27 Dec 2012 14:03:08 +0000
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <5B0E946A-300F-42B8-8133-F2DB999342B1@rothlis.net>
References: <5063BD18.4060309@austin.rr.com> <507EF0E5.6030308@austin.rr.com>
To: Keith Pyle <kpyle@austin.rr.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 Oct 2012, at 18:54, Keith Pyle wrote:
> On 09/26/12 21:42, Keith Pyle wrote:
> > I recently purchased a Hauppauge HD-PVR (the 1212 version, label on bottom
> > 49001LF, Rev F2). I have consistent capture failures on Linux where data from
> > the device simply stops, generally within a few minutes of starting a capture.
> > Yet, the device works flawlessly on Windows with the same USB and component
> > cables, same power supply, and same physical position. This suggests that the
> > device itself has acceptable power, is not overheating, etc. I'll detail below
> > the testing I've done thus far and would appreciate any suggestions on how to
> > further test or address the problem.
> 
> Here's some interesting new information. On noticing that the 3.6 kernel
> included several USB related commits, I updated the kernel of my test system
> (MSI X58 Pro-E) from 3.5.4 to 3.6.2. I ran a series of capture tests with
> firmware 0x1e and all other variables exactly as before - same USB cable, port,
> physical position, etc. I have 20 successful 1-hour captures and 1 failure.

We have run extensive tests comparing the HD PVR's stability on kernel 3.6.6
vs. kernel <3.6; having a single HD PVR connected to the PC vs. multiple HD
PVRs on the same USB controller; adding better heatsinks; running irqbalance.
None of these made any difference. The only significant improvement we found
was from removing the lid and adding fans pointing directly at the circuit
board. Even this didn't cure the problem completely, it only increased the
time-to-failure.

For details, including the time-to-failure measurements and the shell script we
used, see http://stb-tester.com/hardware.html#hauppauge-hd-pvr

Note that our workload is quite different from yours: An individual recording
typically lasts 2-10 minutes, but as soon as it has finished we start another
one, so we are stopping and starting all day. Hauppauge have hinted that under
these conditions the HD PVR is unreliable on Windows too, which implies a
problem in the hardware or firmware, rather than the Linux hdpvr driver.

Dave.

