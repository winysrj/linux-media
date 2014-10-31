Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:20979 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaJaUBw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 16:01:52 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEB00LIERN31620@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Oct 2014 16:01:51 -0400 (EDT)
Date: Fri, 31 Oct 2014 18:01:47 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 5/7] v4l-utils/libdvbv5: add gconv module for the text
 translation of ISDB-S/T.
Message-id: <20141031180147.051d2231.m.chehab@samsung.com>
In-reply-to: <5453A48C.5000804@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
 <1414323983-15996-6-git-send-email-tskd08@gmail.com>
 <20141027150805.4fbd495c.m.chehab@samsung.com> <5453A48C.5000804@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 01 Nov 2014 00:02:36 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> > Using my Fedora package maintainer's hat, I would only enable this
> > on a patch that would also be packaging the gconf module as a
> > separate subpackage, as this would make easier to deprecate it
> > if/when this gets merged at gconv's upstream.
> 
> I'm afraid that gconv upstream won't merge those application
> domain specific encodings,
> as I posted an inquiry about the acceptance of such gconv modules
> to the glibc ML's, but got no response until now.
> (and it seems that the current glibc does not include
>  app specific char-encodings).

At least the way I see it, this is not app-specific, but, instead, a
standard-defined charset. So, I think they should accept. Yet, it could
take some time for it to happen.

If you're expecting to have this inside the library for a long time,
IMHO, you should better integrate it there, dynamically loading the
gconv module and using it, if the library is compiled with such support.

Regards,
Mauro
