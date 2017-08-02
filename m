Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward17o.cmail.yandex.net ([37.9.109.214]:51272 "EHLO
        forward17o.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751145AbdHBIIk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:08:40 -0400
From: "Sergei A. Trusov" <sergei.a.trusov@ya.ru>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@llwyncelyn.cymru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Joe Perches <joe@perches.com>,
        simran singhal <singhalsimran0@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "Sergei A. Trusov" <sergei.a.trusov@ya.ru>
Subject: [PATCH] media: staging: atomisp: sh_css_calloc shall return a pointer to the allocated space
Date: Wed, 02 Aug 2017 18:00:01 +1000
Message-ID: <1859135.Zd3QESt5CR@z12>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The calloc function returns either a null pointer or a pointer to the
allocated space. Add the second case that is missed.

Signed-off-by: Sergei A. Trusov <sergei.a.trusov@ya.ru>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 471f2be974e2..e882b5596813 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -1939,6 +1939,7 @@ void *sh_css_calloc(size_t N, size_t size)
 		p = sh_css_malloc(N*size);
 		if (p)
 			memset(p, 0, size);
+		return p;
 	}
 	return NULL;
 }
