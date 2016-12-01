Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932557AbcLAMbV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Dec 2016 07:31:21 -0500
Subject: [PATCH 13/39] Annotate hardware config module parameters in
 drivers/media/
From: David Howells <dhowells@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, minyard@acm.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, keyrings@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Date: Thu, 01 Dec 2016 12:31:18 +0000
Message-ID: <148059547849.31612.1015310018080822302.stgit@warthog.procyon.org.uk>
In-Reply-To: <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk>
References: <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the kernel is running in secure boot mode, we lock down the kernel to
prevent userspace from modifying the running kernel image.  Whilst this
includes prohibiting access to things like /dev/mem, it must also prevent
access by means of configuring driver modules in such a way as to cause a
device to access or modify the kernel image.

To this end, annotate module_param* statements that refer to hardware
configuration and indicate for future reference what type of parameter they
specify.  The parameter parser in the core sees this information and can
skip such parameters with an error message if the kernel is locked down.
The module initialisation then runs as normal, but just sees whatever the
default values for those parameters is.

Note that we do still need to do the module initialisation because some
drivers have viable defaults set in case parameters aren't specified and
some drivers support automatic configuration (e.g. PNP or PCI) in addition
to manually coded parameters.

This patch annotates drivers in drivers/media/.

Suggested-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Mauro Carvalho Chehab <mchehab@kernel.org>
cc: mjpeg-users@lists.sourceforge.net
cc: linux-media@vger.kernel.org
---

 drivers/media/pci/zoran/zoran_card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index 9d2697f5b455..3a03a0df7999 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -73,7 +73,7 @@ MODULE_PARM_DESC(card, "Card type");
  */
 
 static unsigned long vidmem;	/* default = 0 - Video memory base address */
-module_param(vidmem, ulong, 0444);
+module_param_hw(vidmem, ulong, iomem, 0444);
 MODULE_PARM_DESC(vidmem, "Default video memory base address");
 
 /*

