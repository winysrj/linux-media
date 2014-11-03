Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:8229 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaKCOiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 09:38:01 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEG004OKWNCVG30@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Nov 2014 09:38:00 -0500 (EST)
Date: Mon, 03 Nov 2014 12:37:56 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb:tc90522: bugfix of always-false expression
Message-id: <20141103123756.10394733.m.chehab@samsung.com>
In-reply-to: <544D20F0.3070109@iki.fi>
References: <1414325129-16570-1-git-send-email-tskd08@gmail.com>
 <544CE5F1.3040601@iki.fi> <544CFDFE.9030409@gmail.com>
 <544D20F0.3070109@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Oct 2014 18:27:28 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> 
> 
> On 10/26/2014 03:58 PM, Akihiro TSUKADA wrote:
> >>> Reported by David Binderman
> >>
> >> ^^ See Documentation/SubmittingPatches
> >
> > Though I knew that Reported-by: tag should not be used,
> > I wrote it just to express my appreciation for his report,
> > and did not mean to attach the tag.
> > But I admit that it is confusing,
> > so I'd like to beg Mauro to do me the kindness
> > to delete the line when this patch is committed.
> > (or I'll re-send the patch if it is necessary.)
> 
> Main reason I picked it up, was that tag was formally bad.

Yeah, the tag should be Reported-by: and should have the email
of the person who reported the issue.

But that's not the only thing you forgot... there's no SOB on
this patch ;)

Please resend.

Regards,
Mauro
