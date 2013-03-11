Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42776 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab3CKDK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 23:10:57 -0400
References: <loom.20130309T225537-954@post.gmane.org> <1362881375.13530.10.camel@palomino.walls.org> <CAJGQ9=82aZe1j34=JkHUcsuVtcZ1tJRwB+sqBpEd3zBH3xSW6Q@mail.gmail.com>
In-Reply-To: <CAJGQ9=82aZe1j34=JkHUcsuVtcZ1tJRwB+sqBpEd3zBH3xSW6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: cannot unload cx18_alsa to hibernate Mint13 64 computer
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 10 Mar 2013 23:11:01 -0400
To: Dixon Craig <dixonjnk@gmail.com>
CC: linux-media@vger.kernel.org
Message-ID: <f56c7b48-032e-40d5-a339-84d64b5abce6@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dixon Craig <dixonjnk@gmail.com> wrote:

>Thanks Andy
>
>Pulse was indeed respawning.
>Once I got it killed for certain, I was able to rmmod cx18_alsa and
>cx18,
>then hibernate and wake up worked without problem.
>
>On wake up,  I tried   modprobe  cx18_alsa, but it just hung. I exited
>by
>pressing ctrl-c, and lsmod reported it had not loaded, but that cx18
>had.
>
>My sound config is a bit of a mess right now after days of randomly
>trying
>things to get things working, so once I get things cleaned up I will
>see if
>I can figure out how I can reload TV drivers after hibernate and report
>back to this list in case someone else is faced with this.
>
>Thanks again for your timely help.
>Dixon

modprobe cx18 will prompt a reload of cx18-alsa on its own.

BTW you should also unload cx18 before hibernation.  The cx18 driver really doesn't support power management and can't  save and restore CX23418 state short of reinitializing the whole chip anyway.

Regards,
Andy
