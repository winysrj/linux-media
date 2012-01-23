Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2AWS12 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 13:27:28 -0500
Message-ID: <4F1DA689.9090502@redhat.com>
Date: Mon, 23 Jan 2012 16:27:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Pockele <chris.pockele.f1@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l-utils: ir-keytable file parsing errors
References: <CADotOjP-3+CCN+mOaEHFiUUfsyr33zNW0Av8uXSzz0CF0BX1SA@mail.gmail.com>
In-Reply-To: <CADotOjP-3+CCN+mOaEHFiUUfsyr33zNW0Av8uXSzz0CF0BX1SA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-01-2012 21:31, Chris Pockele escreveu:
> Hello,
> 
> While configuring a remote control I noticed that the ir-keytable
> utility would throw the message "Invalid parameter on line 1" if the
> first line following the "table ... type: ..." line is a comment.
> Also, if a configuration line is invalid, the line number indication
> of the error message is sometimes incorrect, because the comments
> before it are not counted.
> This happens because of the "continue" statement when processing
> comments (or the table/type line), thus skipping the line counter
> increase at the end of the loop.  The included patch fixes both
> problems by making sure the counter is always increased.
> The parse_cfgfile() function had a similar problem.

Applied, thanks.

> For the "table ... type: ..." configuration line at the beginning of a
> keyfile, I suggest replacing the marker character by something
> different from '#'.  That way, it can be commented out by the user,
> and it doesn't have to be on the first line.  However, that's
> something for another patch and probably up to someone else to decide
> :-).  If desirable, I can generate such a patch.

Such patch is welcome, provided that it will keep working with the
old format, in order to not mangle configs with the old format.

Regards,
Mauro
