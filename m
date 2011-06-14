Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:33724 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab1FNLKm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 07:10:42 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QWRW3-0005H0-EE
	for linux-media@vger.kernel.org; Tue, 14 Jun 2011 13:10:39 +0200
Received: from 5ad6ad1a.bb.sky.com ([90.214.173.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 13:10:39 +0200
Received: from jdg8tb by 5ad6ad1a.bb.sky.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 13:10:39 +0200
To: linux-media@vger.kernel.org
From: JD <jdg8tb@gmail.com>
Subject: Re: Latest media-tree results in system hang, an no IR.
Date: Tue, 14 Jun 2011 11:10:26 +0000 (UTC)
Message-ID: <loom.20110614T130028-939@post.gmane.org>
References: <BANLkTiksjC8SyYGdfLbF4eSYhR2c9qEzsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

JD <jdg8tb <at> gmail.com> writes:

> 
> With the latest media-tree, any access to my TV card (using tvtime and
> mplayer to watch through composite) results in my Arch Linux (2.6.39)
> system freezing. Here is the relavent part of my dmesg upon the
> freeze:
> 
> http://codepad.org/q5MxDqAI
> 
> I compiled the latest media-tree in order to, finally, get my infrared
> receiver working, however it still does not.
> An entry is made in /proc/bus/input/devices which points to
> /dev/input/event5; however. the /dev/lirc device node is not present,
> and using "irw" does not seem to recognise any input.
> 
> Is anyone else experiencing such issues, and has anyone managed to get
> IR actually working on the HVR-1120.
> 
> Thanks.
> 


I've have just tried this again on a fresh install of Arch Linux (Linux media
2.6.39-ARCH #1); however it is still a no-go.

My steps are as follows:

1. git clone git://linuxtv.org/media_build.git
2. ./build.sh (reports it built fine with no errors)
3. reboot system (errors are now reported during boot-up, see dmesg)

4. try to access tv card using any program (mplayer or tvtime to watch
composite), my X server crashes, I am thrown out to a TTY and the system appears
unresponsive.


dmesg (line 720 is where things start to appear interesting):
http://codepad.org/OaeWUfAp

lsmod:
http://codepad.org/GMHFddGU

lspci:
http://codepad.org/paZ5hoCU

Thanks.

