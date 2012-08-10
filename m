Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:39253 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758194Ab2HJJsA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 05:48:00 -0400
Date: Fri, 10 Aug 2012 10:47:58 +0100
From: Sean Young <sean@mess.org>
To: Partha Guha Roy <partha.guha.roy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Philips saa7134 IR remote problem with linux kernel v2.6.35
Message-ID: <20120810094758.GA18223@pequod.mess.org>
References: <CADTwmX8-yf3iNhrOozQGFnHg=H+rq6rti8AO=uRBzsj+OHEdyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADTwmX8-yf3iNhrOozQGFnHg=H+rq6rti8AO=uRBzsj+OHEdyQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 08, 2012 at 12:23:46AM +0600, Partha Guha Roy wrote:
> I have a saa7134 analog tv card (Avermedia PCI pure m135a) with an IR
> remote. The IR remote is recognized by a standard keyboard and lirc
> used to work fine with this. However, from kernel v2.6.35, the IR
> remote does not work properly. The major problem is that every
> keystroke is registered after the next keystroke. So, if I press the
> sequence "123" on the remote, it actually comes up with only "12". If
> I then if I wait for 5 seconds, the "3" gets lost.
> 
> Now I tried to bisect the kernel and it lead to the following commit:
> 
> commit e40b1127f994a427568319d1be9b9e5ab1f58dd1
> Author: David Härdeman <david@hardeman.nu>
> Date:   Thu Apr 15 18:46:00 2010 -0300
> 
>     V4L/DVB: ir-core: change duration to be coded as a u32 integer
> 
>     This patch implements the agreed upon 1:31 integer encoded pulse/duration
>     struct for ir-core raw decoders. All decoders have been tested after the
>     change. Comments are welcome.
> 
>     Signed-off-by: David Härdeman <david@hardeman.nu>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> I am willing to test patches if needed.

Are you runnning the lircd user space process for input or relying on
the in-kernel decoders? Also what remote are you using (or more 
specifically, what IR protocol does it use)?

Can you reproduce the issue on a more contemporary kernel?

Note that the commit only affects kernel space IR decoders so it should
not affect lircd.

I wouldn't be surprised if the 15ms delay for processing in 
saa7134_raw_decode_irq (bottom of saa7134-input.c) needs increasing.


Sean
