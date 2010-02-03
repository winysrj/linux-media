Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab0BCIWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 03:22:43 -0500
Message-ID: <4B69324F.4040903@infradead.org>
Date: Wed, 03 Feb 2010 06:22:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [patch 2/7] drivers/media/video/pms.c needs version.h
References: <201002022240.o12Melb9018905@imap1.linux-foundation.org>
In-Reply-To: <201002022240.o12Melb9018905@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> i386 allmodconfig:
> 
> drivers/media/video/pms.c: In function 'pms_querycap':
> drivers/media/video/pms.c:682: error: implicit declaration of function 'KERNEL_VERSION'

> @@ -24,6 +24,7 @@
>  #include <linux/delay.h>
>  #include <linux/errno.h>
>  #include <linux/fs.h>
> +#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/mm.h>

Hmm... changeset feba2f81 already added linux/version.h:
@@ -27,20 +29,21 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
+#include <linux/version.h>
+#include <linux/mutex.h>
+#include <asm/uaccess.h>
 #include <asm/io.h>
...

So I think this patch got obsoleted.

Cheers,
Mauro
