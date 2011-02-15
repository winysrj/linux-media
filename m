Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab1BPQ1y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 11:27:54 -0500
Date: Tue, 15 Feb 2011 17:04:33 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Fernando Laudares Camargos <fernando.laudares.camargos@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: IR for remote control not working for Hauppauge WinTV-HVR-1150
 (SAA7134)
Message-ID: <20110215220433.GA3327@redhat.com>
References: <AANLkTi=jkLGgZDH6XytL1MEE7w5SckZjXoGPhFSCo40b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=jkLGgZDH6XytL1MEE7w5SckZjXoGPhFSCo40b@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

First off, video4linux-list is dead, you want linux-media (added to cc).

On Tue, Feb 15, 2011 at 06:27:29PM -0200, Fernando Laudares Camargos wrote:
> Hello,
> 
> I have a Hauppauge WinTV-HVR-1150 (model 67201) pci tv tuner working
> (video and audio) under Ubuntu 10.10 and kernel 2.6.35-25. But the IR
> sensor is not being detected and no input device is being created at
> /proc/bus/input.
> 
> I have tried to follow the information from Jarod Wilson and Mauro
> Carvalho Chehab in https://bugzilla.redhat.com/show_bug.cgi?id=665870
> (regarding Fedora 14) but couldn't resolve it myself.
> 
> I'm not a kernel/driver specialist but from looking at the code I've
> noticed that *perphaps* the support for the HVR-1150 has not been
> finished yet. Here are two examples that leaded to this observation
> (IMHO):
> 
> drivers/media/video/saa7134/saa7134-cards.c
> -------------------------------------------------------------------------------
> (...)
> int saa7134_board_init1(struct saa7134_dev *dev)
> {
> (...)
>        case SAA7134_BOARD_HAUPPAUGE_HVR1150:           *NO
> INSTRUCTIONS FOR THIS CASE*

No. It falls through and uses the same config as the HVR1120. Similar case
for all other instances you've referenced.

> I'm wondering if someone has the IR part of the HVR-1150 working under
> F14 or other or could give me a hand on trying to make it work (I have
> attached output from dmesg with the following saa7134 options set:
> disable_ir=0 i2c_debug=1 i2c_scan=1 ir_debug=1

As noted in the bug, I think there's actually one more patch of Mauro's
that isn't yet in the F14 kernel, that bug was updated as having the full
fix in 2.6.35.11-83.fc14 erroneously.

I'll try to address that soon.

-- 
Jarod Wilson
jarod@redhat.com

