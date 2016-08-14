Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:42637 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbcHNSYC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 14:24:02 -0400
Date: Sun, 14 Aug 2016 12:24:00 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] doc-rst: customize RTD theme, drop padding of inline
 literal
Message-ID: <20160814122400.04dfbd81@lwn.net>
In-Reply-To: <54a6dd78-b424-6bdc-2c46-25e44b3c41f7@xs4all.nl>
References: <1470388783-5200-1-git-send-email-markus.heiser@darmarit.de>
	<54a6dd78-b424-6bdc-2c46-25e44b3c41f7@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Aug 2016 11:27:07 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 08/05/2016 11:19 AM, Markus Heiser wrote:
> > From: Markus Heiser <markus.heiser@darmarIT.de>
> > 
> > Remove the distracting (left/right) padding of inline literals. (HTML
> > <code>). Requested and discussed in [1].
> > 
> > [1] http://www.spinics.net/lists/linux-media/msg103991.html
> > 
> > Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>  
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Thank you! Thank you! Thank you!
> 
> So much better!

Agreed, this one was really needed.  Applied to the 4.8-fixes branch,
thanks.

jon
