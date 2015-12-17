Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:2546 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbbLQOat (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 09:30:49 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
 <5672BE15.9070006@free.fr> <20151217120830.0fc27f01@recife.lan>
From: Mason <slash.tmp@free.fr>
Message-ID: <5672C713.6090101@free.fr>
Date: Thu, 17 Dec 2015 15:30:43 +0100
MIME-Version: 1.0
In-Reply-To: <20151217120830.0fc27f01@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/12/2015 15:08, Mauro Carvalho Chehab wrote:

> Then I guess you're not using vanilla 3.4 Kernel, but some heavily
> modified version. You're on your own here.

#ifdef NEED_KVFREE
#include <linux/mm.h>
static inline void kvfree(const void *addr)
{
	if (is_vmalloc_addr(addr))
		vfree(addr);
	else
		kfree(addr);
}
#endif

/tmp/sandbox/media_build/v4l/compat.h: In function 'kvfree':
/tmp/sandbox/media_build/v4l/compat.h:1631:3: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
   vfree(addr);
   ^

vfree is declared in linux/vmalloc.h

The fix is trivial:

diff --git a/v4l/compat.h b/v4l/compat.h
index c225c07d6caa..7f3f1d5f9d11 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -1625,6 +1625,7 @@ static inline void eth_zero_addr(u8 *addr)
 
 #ifdef NEED_KVFREE
 #include <linux/mm.h>
+#include <linux/vmalloc.h>
 static inline void kvfree(const void *addr)
 {
        if (is_vmalloc_addr(addr))


