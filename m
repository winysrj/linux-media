Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57786 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0AUCVs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 21:21:48 -0500
Subject: Re: SSH key parser
From: Andy Walls <awalls@radix.net>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <1a297b361001200424i24f9c1d2v2535aa18c80b3874@mail.gmail.com>
References: <1a297b361001200424i24f9c1d2v2535aa18c80b3874@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 Jan 2010 21:21:29 -0500
Message-Id: <1264040489.3098.54.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-01-20 at 16:24 +0400, Manu Abraham wrote:
> Hi all,
> 
> I have been working with some T&M applications. Does anybody know of a
> good SSH key parser that I need to use, for remote authentication in
> such applications. Or does SSH sound like using a hammer against a fly
> in such a circumstance ?

Well, computer and communications security is more than just a good key
parser.  It also involves protocols, procedures, audits, proper clocks,
etc.  But I digress....


I don't know what you mean by T&M, but maybe you might find dropbear SSH
useful:

http://matt.ucc.asn.au/dropbear/dropbear.html

I make no claims as to the secuirty "goodness" of Dropbear SSH; I only
know that it exists.

Be aware that getting enough entropy in the entropy pool to generate
good host keys on an embedded platform with no mouse or keyboard can be
a problem.  But you only have to do that once really, if you never
rotate keys.

And watch out for those Australian drop-bears, I hear they are deadly.

Regards,
Andy

> Feedback much appreciated.
>
> Thanks,
> Manu


