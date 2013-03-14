Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52607 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868Ab3CNRwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 13:52:38 -0400
Received: by mail-ie0-f171.google.com with SMTP id 10so3385180ied.2
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2013 10:52:38 -0700 (PDT)
Message-ID: <51420E62.2000601@gmail.com>
Date: Thu, 14 Mar 2013 11:52:34 -0600
From: Dixon Craig <dixonjnk@gmail.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: cannot unload cx18_alsa to hibernate Mint13 64 computer
References: <loom.20130309T225537-954@post.gmane.org> <1362881375.13530.10.camel@palomino.walls.org> <CAJGQ9=82aZe1j34=JkHUcsuVtcZ1tJRwB+sqBpEd3zBH3xSW6Q@mail.gmail.com> <f56c7b48-032e-40d5-a339-84d64b5abce6@email.android.com>
In-Reply-To: <f56c7b48-032e-40d5-a339-84d64b5abce6@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2013 09:11 PM, Andy Walls wrote:
> modprobe cx18 will prompt a reload of cx18-alsa on its own. BTW you 
> should also unload cx18 before hibernation. The cx18 driver really 
> doesn't support power management and can't save and restore CX23418 
> state short of reinitializing the whole chip anyway. Regards, Andy 


I got hibernation and my hauppuage pvr1600 card sorted out on my Linux 
mint 13.

1. I removed all pulseaudio - Alsa seems to do everything I need and no 
more problems from pulseaudio respawning
2. I switched to a generic 3.2.0-38 kernel. I was using tuxonice kernel, 
but newer generic now supports my motherboard for hibernation. Tuxonice 
kernel would seg. fault when thawing when I tried to reload cx18 module.
3. I wrote a script to unload cx18_alsa, cx18 first like this

#!/bin/bash
#hibernate2.sh script to unload capture card modules; modify sudoers so 
you can call with root privilages
modprobe -r cx18_alsa
modprobe -r cx18
/usr/sbin/pm-hibernate
modprobe cx18

I tried to reload cx18_alsa, then cx18 after recovering from hibernation 
as per Ubuntu forum post, but for some reason this would mess up cx18. 
As per your instructions, for some reason modprobe cx18 causes both 
cx18_alsa and cx18 to load cleanly.

thanks again
Dixon



