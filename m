Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35938 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZBHVay (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Feb 2009 16:30:54 -0500
Subject: Re: Looking for cheap big-endian system with PCI slot
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200902082219.53360.hverkuil@xs4all.nl>
References: <200902082219.53360.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 16:31:45 -0500
Message-Id: <1234128705.3108.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-02-08 at 22:19 +0100, Hans Verkuil wrote:
> Hi all,
> 
> I wonder if anyone knows a reasonably priced big-endian system with a PCI 
> slot that I can use to test PCI capture cards with a big-endian linux 
> installation. Preferable something small like a mini-ITX board.
> 
> I haven't been able to find anything yet, but perhaps someone has an idea of 
> where to find something like this?

This looks like it has promise:

http://www.linux-mips.org/wiki/Mips_Malta

I don't know where to get one though, but it looks like one might be
able to select the endianess that gets used.

(I have a recollection that PA-RISC, and maybe MIPS, would let you
specify endianess with a processor control register, but it's been a
while.)

Regards,
Andy

> Thanks,
> 
> 	Hans
> 

