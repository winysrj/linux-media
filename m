Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:16379 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaBSN6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 08:58:33 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1800EI3XHJ0410@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Feb 2014 08:58:31 -0500 (EST)
Date: Wed, 19 Feb 2014 22:58:26 +0900
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Rune Petersen <rune@megahurts.dk>, linux-media@vger.kernel.org
Subject: Re: Some questions timeout in rc_dev
Message-id: <20140219225826.5f5cefbe.m.chehab@samsung.com>
In-reply-to: <20140218140236.GA10790@pequod.mess.org>
References: <53013379.70403@megahurts.dk>
 <20140218140236.GA10790@pequod.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 18 Feb 2014 14:02:37 +0000
Sean Young <sean@mess.org> escreveu:

> On Sun, Feb 16, 2014 at 10:54:01PM +0100, Rune Petersen wrote:
> > The intent of the timeout member in the rc_dev struct is a little unclear to me.
> > In rc-core.h it is described as:
> > 	@timeout: optional time after which device stops sending data.
> > 
> > But if I look at the usage, it is used to detect idle in ir_raw.c
> > which again is used by the RC-6 decoder to detect end of RC-6 6A
> > transmissions.
> > 
> > This leaves me with a few questions:
> >  - Without the timeout (which is optional) the RC-6 decoder will not work
> >    properly with RC-6 6A transmissions wouldn't that make it required?
> 
> That sounds like a bug to me. The decoders shouldn't rely on the length 
> of trailing space, probably it would be best to not rely on receiving the
> trailing space if possible.

The trailing space is needed, because of some weird variants. For example,
there are some RC5-like protocols that have less bits. See for example the
15-bits variant at drivers/media/rc/ir-rc5-sz-decoder.

So, as a general rule, we're always waiting for a trailing space, to be sure
that the protocol matches. 
-- 

Cheers,
Mauro
