Return-path: <mchehab@pedra>
Received: from mailfe05.c2i.net ([212.247.154.130]:42182 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756757Ab1EWSwJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 14:52:09 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Inlined functions should be static.
Date: Mon, 23 May 2011 20:50:55 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <201105231607.13668.hselasky@c2i.net> <Pine.LNX.4.64.1105232022460.30305@axis700.grange> <4DDAA788.80908@redhat.com>
In-Reply-To: <4DDAA788.80908@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105232050.55676.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 23 May 2011 20:29:28 Mauro Carvalho Chehab wrote:
> Em 23-05-2011 15:23, Guennadi Liakhovetski escreveu:
> > On Mon, 23 May 2011, Hans Petter Selasky wrote:
> >> --HPS
> > 
> > (again, inlining would save me copy-pasting)
> 
> Yeah... hard to comment not-inlined patches...
> 
> >> -inline u32 stb0899_do_div(u64 n, u32 d)
> >> +static inline u32 stb0899_do_div(u64 n, u32 d)
> > 
> > while at it you could as well remove the unneeded in a C file "inline"
> > attribute.
> 
> hmm... foo_do_div()... it seems to be yet-another-implementation
> of asm/div64.h. If so, it is better to just remove this thing
> and use the existing function.
> 

The reason for this patch is that some version of GCC generated some garbage 
code on this function under certain conditions. Removing inline completly on 
this static function in a C file is fine by me. Do I need to create another 
patch?

--HPS
