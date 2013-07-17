Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56008 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab3GQUmV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 16:42:21 -0400
Date: Wed, 17 Jul 2013 14:42:20 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Libin Yang <lbyang@marvell.com>
Cc: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>,
	<albert.v.wang@gmail.com>, Albert Wang <twang13@marvell.com>
Subject: Re: [PATCH v3 1/7] marvell-ccic: add MIPI support for marvell-ccic
 driver
Message-ID: <20130717144220.42fa32b9@lwn.net>
In-Reply-To: <1372830964-22323-2-git-send-email-lbyang@marvell.com>
References: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
	<1372830964-22323-2-git-send-email-lbyang@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 3 Jul 2013 13:55:58 +0800
Libin Yang <lbyang@marvell.com> wrote:

> This patch adds the MIPI support for marvell-ccic.
> Board driver should determine whether using MIPI or not.

Sorry for taking so long...I wanted to be able to carve out some time and
look at things closely.  At this point, there's nothing that, I think,
needs to further hold up the merging of this code.  So you can add:

	Acked-by: Jonathan Corbet <corbet@lwn.net>

to the entire series.  Thanks again for doing this work, and for your
patience with my many comments!

jon
