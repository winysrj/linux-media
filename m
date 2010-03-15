Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936138Ab0COLw1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 07:52:27 -0400
Message-ID: <4B9E1F76.8090900@infradead.org>
Date: Mon, 15 Mar 2010 08:52:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-media@vger.kernel.org, stefani@seibold.net
Subject: Re: [patch 1/5] drivers/media/video/cx23885 needs kfifo conversion
References: <201003112202.o2BM2FgS013122@imap1.linux-foundation.org>
In-Reply-To: <201003112202.o2BM2FgS013122@imap1.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

You can drop this patch. The conversion to the new kfifo API happened on this
patch:

commit 7801edb0b8b66e83c13623b483bc2e846c007c9d
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon Dec 21 14:37:33 2009 -0800
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Tue Dec 22 14:17:57 2009 -0800

    media video cx23888 driver: ported to new kfifo API

The patch is already upstream.

Cheers,
Mauro
