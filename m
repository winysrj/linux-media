Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41924 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782AbaKSQGd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 11:06:33 -0500
Date: Wed, 19 Nov 2014 11:06:30 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] DocBook: media: Fix Makefile clean target
Message-ID: <20141119110630.70aa2f1d@lwn.net>
In-Reply-To: <1416410992-24950-1-git-send-email-mpa@pengutronix.de>
References: <1416410992-24950-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 19 Nov 2014 16:29:52 +0100
Markus Pargmann <mpa@pengutronix.de> wrote:

> The cleanmediadocs target will fail if the given files do not exist.
> This should not happen, instead we want the cleaning to be successful
> even if the files do not exist.

I already have a patch to this effect in my docs tree, thanks.

jon
