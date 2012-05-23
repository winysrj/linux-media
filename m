Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48904 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab2EWVBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 17:01:30 -0400
Received: by obbtb18 with SMTP id tb18so11548398obb.19
        for <linux-media@vger.kernel.org>; Wed, 23 May 2012 14:01:30 -0700 (PDT)
Message-ID: <4FBD5026.4070306@gmail.com>
Date: Wed, 23 May 2012 17:01:26 -0400
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, atrpms-users@atrpms.net
Subject: Re: HVR1600 and Centos 6.2 x86_64 -- Strange Behavior
References: <4FBBF83C.8040201@gmail.com> <CAGoCfiwgpnAFZ0axsZqzWBzjGffLZPeZ8bnA_vaL1jcia0rk5A@mail.gmail.com> <e95d008d-1d5a-4fde-b858-0041a9253a47@email.android.com>
In-Reply-To: <e95d008d-1d5a-4fde-b858-0041a9253a47@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/22/2012 06:06 PM, Andy Walls wrote:
> Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> 
>> On Tue, May 22, 2012 at 4:34 PM, Bob Lightfoot
>> <boblfoot@gmail.com> wrote:
>>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>> 
>>> Dear LinuxTv and AtRpms Communities: In the most recent three
>>> kernels {2.6.32-220.7.1 ; 2.6.32-220.13.1 ; 2.6.32-220.17.1}
>>> released for CentOS 6.2 I have experienced what can only be
>>> described as a strange behavior of the V4L kernel modules with
>>> the Hauppage HVR 1600 Card.  If I reboot the PC in question {HP
>>> Pavillion Elite M9040n} I will lose sound on the Analog TV
>>> Tuner.  If I Power off the PC, leave it off for 30-60 seconds
>>> and start it back up then I have sound with the Analog TV Tuner
>>> every time.  Not sure what is causing this, but thought the 
>>> condition was worth sharing.
>> 
>> Could you please clarify which HVR-1600 board you have (e.g. the
>> PCI ID)?  I suspect we're probably not resetting the audio
>> processor properly, but I would need to know exactly which board
>> you have in order to check that.
>> 
>> Devin
>> 
>> -- Devin J. Heitmueller - Kernel Labs http://www.kernellabs.com 
>> -- To unsubscribe from this list: send the line "unsubscribe
>> linux-media" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
> 
> Also, if you not done so already, verify that it is not a sound
> card playback issue.   Make a recording when you suspect the
> HVR1600 is not capturing sound. Then play the recording when you
> know your sound is working.
> 
> Also, does audio line in with Svideo or CVBS exhibit the same
> symptoms?
> 
> I had to go through a good bit of trial and error to get the
> CX23418's APU to capture audio reliably after boot up, so I am
> reluctant to mess with that unless needed.
> 
> We will want to try to narrow the problem down to one of the analog
> tuner, integrated CX25843, or APU.
> 
> Regards, Andy
> 
First Question the PCI ID -- the output of lspci -v is :
01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23418
Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast
Audio Decoder
        Subsystem: Hauppauge computer works Inc. WinTV HVR-1600
        Flags: bus master, medium devsel, latency 64, IRQ 17
        Memory at f4000000 (32-bit, non-prefetchable) [size=64M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx18
        Kernel modules: cx18

And although right now I cannot find the earlier instructions I
followed there was a post on the gossamer threads about the audio not
being detected and the card muting the output.  There was a command
{memory fails me right now} to query the card for the status of the
tuner which is showing the audio is undetermined and muted when this
issue happens.  It happens in both mythtv and cat > file.avi
recordings played back later.  It should be noted that audio playback
is fine despite the analog video sound being muted.

Bob Lightfoot

P.S. -- David & Andy - If you need more specific information just send
me the commands to run and I'll provide the feedback,

P.P.S. -- Appreciate all you guys do -- my linux video box runs
circles around my Vista Media Center.

Last P.S. - Linux Media Rocks.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPvVAmAAoJEKqgpLIhfz3XcFAH/3bViyDt/YxLBbxtHi+fvofY
cHWPBD1ls8QxPSfmumVU8fZR6qcg1RIg9FpbOcngXpnGdOjK0NXJ7oQngX34WCrR
1NJgl4fc1YEBM6QzoOVHXC9Yg6iQnAShru4PIyP4VmuwDNIT/y7HZnB06bGUd6Fv
1qxxKKzfwC4IxlzjX2jl3A+p/ujFJCGe/oIt+Q1JJho1Xq1rMYGEguQGyuPkLgjA
MtfmObGA7OhrFDbdJ9cagW1o3Uu3CXa53qq5QPTGDzw4H6agmjQgL2PVUdgbc2X9
ijB1kFTK9WwP4zbeVKUSejk8Jp1gC6n8ntBtdOe+I+uH6D0ONzznNCur2p+EbcU=
=NL8P
-----END PGP SIGNATURE-----
