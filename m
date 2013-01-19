Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55558 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab3ASWSa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 17:18:30 -0500
Message-ID: <1358633873.1927.12.camel@palomino.walls.org>
Subject: Re: [ivtv-users] cx18 module causes freeze after kernel upgrade
From: Andy Walls <awalls@md.metrocast.net>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
Cc: linux-media@vger.kernel.org
Date: Sat, 19 Jan 2013 17:17:53 -0500
In-Reply-To: <BAY171-W223641922205DB68CCF27C81120@phx.gbl>
References: <BAY171-W223641922205DB68CCF27C81120@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2013-01-18 at 14:23 -0500, Kyle Lil wrote:
> I'm having trouble getting drivers installed for my Hauppauge HVR-1600
> in recent kernels. In Mythbuntu 12.04, I first tried upgrading to 3.4
> kernel or 3.3 kernel. After installing each of these, I booted into
> the new kernel, then downloaded and built a fresh copy of media_build
> from the git server.

Why?  What is wrong with the cx18 module (and supporting modules) in the
stock 3.4 or 3.3 kernel?

FYI, the ^media_build^ is only a partial rebuild of the sources for the
latest ^media_tree^ kernel, with some backward compatability patches so
things at least compile.  No guarantee that things are going to work.

If you rebuild and install the ^media_tree^ kernel and all the modules,
then you will have the bleeding edge V4L-DVB modules with a vanilla
kernel.  You will not have any security or valued added patches from
Cannonical, but you will have the bleeding edge V4L-DVB modules with
their intended kernel and they shouldn't crash.

>  On reboot, for both kernels, the system would hang. A bunch of trace
> information would scroll by and a hard reboot was required. (I'm not
> really sure how to retrieve that info).

Take a picture with a digital camera and email direct to me:
awalls@md.metrocast.net .  If the "Code" bytes in the photo are not
readable, please transcribe them by hand (there are only 64 of them) and
send them as well.


>  I thought the issue might have been related to using a newer kernel
> than the Ubuntu 12.04 repositories gave me. 

Maybe.  I don't know from where media_build is picking up the kernel
headers.

> 
> So I upgraded to Ubuntu 12.10 (and kernel 3.5.0-21). Unfortunately,
> I'm having the same experience. If I install the media_build tree and
> try "sudo modprobe cx18", the system immediately hangs with no log
> output (that I know how to retrieve - I had tail -f /var/log/messages
> running in a separate terminal window) and again the system hangs
> during boot.

During your experimentation blacklist the cx18 driver
in /etc/modprobe.d/blacklist.conf .  That way on reboot, you get to
decide when your machine hangs by typing modprobe cx18 manually.


>  The last good working kernel I have with v4l-dvb drivers is 3.2.0-32.
> 
> 
> Any help would be greatly appreciated. Please let me know if there is
> any additional info I can provide (or if there is a different list I
> should be sending to). 

Certainly, questions related to media_build should be directed to the
Linux media list: linux-media@vger.kernel.org .  I don't use the
media_build backward-compatability build system, myself.

Regards,
Andy
> 
> Thanks,
> Kyle



