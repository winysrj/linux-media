Return-path: <linux-media-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47476 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754655AbcKQRYP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 12:24:15 -0500
Message-ID: <1479396539.1463.12.camel@sipsolutions.net>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
From: Johannes Berg <johannes@sipsolutions.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-media@vger.kernel.org
Date: Thu, 17 Nov 2016 16:28:59 +0100
In-Reply-To: <20161117131651.467943e0@vento.lan>
References: <20161107075524.49d83697@vento.lan>
         <11020459.EheIgy38UF@wuerfel> <20161116182633.74559ffd@vento.lan>
         <2923918.nyphv1Ma7d@wuerfel> <20161117145244.sksssz6jvnntsw5u@thunk.org>
         <20161117131651.467943e0@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> So, the problem that remains is for those images whose source
> is a bitmap. If we want to stick with the Sphinx supported formats,
> we have only two options for bitmaps: jpg or png. We could eventually
> use uuencode or base64 to make sure that the patches won't use
> git binary diff extension, or, as Arnd proposed, use a portable
> bitmap format, in ascii, converting via Makefile, but losing
> the alpha channel with makes the background transparent.
> 

Or just "rewrite" them in svg? None of the gif files I can see actually
look like they'd have been drawn in gif format anyway. The original
source may be lost, but it doesn't seem all that hard to recreate them
in svg.

johannes
