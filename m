Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459Ab0ECXHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 19:07:35 -0400
Message-ID: <4BDF5731.4040203@infradead.org>
Date: Mon, 03 May 2010 20:07:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-media@vger.kernel.org, error27@gmail.com, dtor@mail.ru
Subject: Re: [patch 10/11] ir-keytable: avoid double lock
References: <201004272111.o3RLBQlk020008@imap1.linux-foundation.org>
In-Reply-To: <201004272111.o3RLBQlk020008@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

akpm@linux-foundation.org wrote:
> From: Dan Carpenter <error27@gmail.com>
> 
> It's possible that we wanted to resize to a smaller size but we didn't
> have enough memory to create the new table.  We need to test for that here
> so we don't try to lock twice and dead lock.  Also we free the "oldkeymap"
> on that path and that would be bad.

This patch doesn't apply anymore on my tree.

It probably conflicted with this one:

commit 2b12a23223d05a1192e1e55775b79d6caa52b066
Author: David Härdeman <david@hardeman.nu>
Date:   Fri Apr 2 15:58:28 2010 -0300

    V4L/DVB: drivers/media/IR - improve keytable code

    The attached patch rewrites much of the keytable code in
    drivers/media/IR/ir-keytable.c.


Cheers,
Mauro
