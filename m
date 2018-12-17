Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8320CC43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 16:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 122982146E
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 16:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545062452;
	bh=SbCCixYWd6hbbYZCGXxdnSBbXabfom5y/lIKwstqzNc=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=UXH913i4dRtzrcpMUR3t9OvtC27qKOTe+t3ElNgXC9FqAdsvnDBya6FsuPA5byDKH
	 ZoiAtbOiUcEvfrwfRxGXtujw6rs+0EqiPAI89RVZxhGELozZISF0P0q4b5AuWXWfKG
	 CFQzUbRK/cJe0VFGOk3h/LPCDXH6zfrxnO9VM5vE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbeLQQAv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 11:00:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44708 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbeLQQAv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 11:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=y5EStQ4T10O9XOnMgW3rxEoJjjKtPht5nxchqp7aLBs=; b=ClDur9Nb+VOCBKtyAOq4NROE7
        Amst5nC2BpcA3GRu8iANxureg3Qd9RQRlebuK4nqwVFhxow2mr10E4X/JkejbKlQF5EzNGfiVvnDF
        81yNE8LJsWRqFTj9q1CQxamUtX1nlYaqNCUvtKZXs4tpQOPQZG8sw3kI7UAQ3adeAS7NBZDUgAMY5
        2Vny0FWbrPqtAj1jkfve/7Sat/f9Ms6sK52SAbA6v9SILcFvFg3OIgR5d+nHDjcup/8zGPbCYOkzz
        kkuhYEGJ8k0+fmrNRHnkXBELqQ3DhL0lyOcur/5SIvo6kaaio/FEs5Q3oCeSHbOZf+HIJ7v79j0YZ
        n1XLjnWyQ==;
Received: from 177.205.112.95.dynamic.adsl.gvt.net.br ([177.205.112.95] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gYvK4-0002TE-KV; Mon, 17 Dec 2018 16:00:50 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gYvJy-0003HH-Tj; Mon, 17 Dec 2018 11:00:42 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: docs: fix some GPL licensing ambiguity at the text
Date:   Mon, 17 Dec 2018 11:00:39 -0500
Message-Id: <e7121ab4056ff3419f981bbf03c1e7db39223149.1545062435.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Those files are meant to be dual GPL 2.0 and GFDL without
implicit sections. However, by a wrong cut-and-paste, I ended
by applying a GPL 2+ license text to it, while still using the
GPL 2.0 SPDX tag, with would cause an ambiguity about the
licensing model.

Solve this by explicitly mentioning that the dual licensing
is between GPL 2.0 and GFDL and correcting the text.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/uapi/dvb/dvbstb.svg                     | 6 +++---
 .../media/uapi/mediactl/media-ioc-request-alloc.rst         | 6 +++---
 .../media/uapi/mediactl/media-request-ioc-queue.rst         | 6 +++---
 .../media/uapi/mediactl/media-request-ioc-reinit.rst        | 6 +++---
 Documentation/media/uapi/mediactl/request-api.rst           | 6 +++---
 Documentation/media/uapi/mediactl/request-func-close.rst    | 6 +++---
 Documentation/media/uapi/mediactl/request-func-ioctl.rst    | 6 +++---
 Documentation/media/uapi/mediactl/request-func-poll.rst     | 6 +++---
 Documentation/media/uapi/v4l/bayer.svg                      | 6 +++---
 Documentation/media/uapi/v4l/constraints.svg                | 6 +++---
 Documentation/media/uapi/v4l/nv12mt.svg                     | 6 +++---
 Documentation/media/uapi/v4l/nv12mt_example.svg             | 6 +++---
 Documentation/media/uapi/v4l/selection.svg                  | 6 +++---
 13 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/Documentation/media/uapi/dvb/dvbstb.svg b/Documentation/media/uapi/dvb/dvbstb.svg
index 9700c864d3c3..c7672148d6ff 100644
--- a/Documentation/media/uapi/dvb/dvbstb.svg
+++ b/Documentation/media/uapi/dvb/dvbstb.svg
@@ -1,14 +1,14 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <!--
     This file is dual-licensed: you can use it either under the terms
-    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
     dual licensing only applies to this file, and not this project as a
     whole.
 
     a) This file is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License as
-       published by the Free Software Foundation; either version 2 of
-       the License, or (at your option) any later version.
+       published by the Free Software Foundation version 2 of
+       the License.
 
        This file is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
index de131f00c249..6d4ca4ada2e0 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
@@ -1,12 +1,12 @@
 .. This file is dual-licensed: you can use it either under the terms
-.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
+.. of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
 .. dual licensing only applies to this file, and not this project as a
 .. whole.
 ..
 .. a) This file is free software; you can redistribute it and/or
 ..    modify it under the terms of the GNU General Public License as
-..    published by the Free Software Foundation; either version 2 of
-..    the License, or (at your option) any later version.
+..    published by the Free Software Foundation version 2 of
+..    the License.
 ..
 ..    This file is distributed in the hope that it will be useful,
 ..    but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
index 5d2604345e19..fc8458746d51 100644
--- a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
@@ -1,12 +1,12 @@
 .. This file is dual-licensed: you can use it either under the terms
-.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
+.. of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
 .. dual licensing only applies to this file, and not this project as a
 .. whole.
 ..
 .. a) This file is free software; you can redistribute it and/or
 ..    modify it under the terms of the GNU General Public License as
-..    published by the Free Software Foundation; either version 2 of
-..    the License, or (at your option) any later version.
+..    published by the Free Software Foundation version 2 of
+..    the License.
 ..
 ..    This file is distributed in the hope that it will be useful,
 ..    but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
index ec61960c81ce..61381e87665a 100644
--- a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
+++ b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
@@ -1,12 +1,12 @@
 .. This file is dual-licensed: you can use it either under the terms
-.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
+.. of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
 .. dual licensing only applies to this file, and not this project as a
 .. whole.
 ..
 .. a) This file is free software; you can redistribute it and/or
 ..    modify it under the terms of the GNU General Public License as
-..    published by the Free Software Foundation; either version 2 of
-..    the License, or (at your option) any later version.
+..    published by the Free Software Foundation version 2 of
+..    the License.
 ..
 ..    This file is distributed in the hope that it will be useful,
 ..    but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
index 945113dcb218..4b25ad03f45a 100644
--- a/Documentation/media/uapi/mediactl/request-api.rst
+++ b/Documentation/media/uapi/mediactl/request-api.rst
@@ -1,12 +1,12 @@
 .. This file is dual-licensed: you can use it either under the terms
-.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
+.. of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
 .. dual licensing only applies to this file, and not this project as a
 .. whole.
 ..
 .. a) This file is free software; you can redistribute it and/or
 ..    modify it under the terms of the GNU General Public License as
-..    published by the Free Software Foundation; either version 2 of
-..    the License, or (at your option) any later version.
+..    published by the Free Software Foundation version 2 of
+..    the License.
 ..
 ..    This file is distributed in the hope that it will be useful,
 ..    but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst b/Documentation/media/uapi/mediactl/request-func-close.rst
index dcf3f35bcf17..2cff7770558e 100644
--- a/Documentation/media/uapi/mediactl/request-func-close.rst
+++ b/Documentation/media/uapi/mediactl/request-func-close.rst
@@ -1,12 +1,12 @@
 .. This file is dual-licensed: you can use it either under the terms
-.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
+.. of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
 .. dual licensing only applies to this file, and not this project as a
 .. whole.
 ..
 .. a) This file is free software; you can redistribute it and/or
 ..    modify it under the terms of the GNU General Public License as
-..    published by the Free Software Foundation; either version 2 of
-..    the License, or (at your option) any later version.
+..    published by the Free Software Foundation version 2 of
+..    the License.
 ..
 ..    This file is distributed in the hope that it will be useful,
 ..    but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/mediactl/request-func-ioctl.rst b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
index 11a22f887843..de0781c61873 100644
--- a/Documentation/media/uapi/mediactl/request-func-ioctl.rst
+++ b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
@@ -1,12 +1,12 @@
 .. This file is dual-licensed: you can use it either under the terms
-.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
+.. of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
 .. dual licensing only applies to this file, and not this project as a
 .. whole.
 ..
 .. a) This file is free software; you can redistribute it and/or
 ..    modify it under the terms of the GNU General Public License as
-..    published by the Free Software Foundation; either version 2 of
-..    the License, or (at your option) any later version.
+..    published by the Free Software Foundation version 2 of
+..    the License.
 ..
 ..    This file is distributed in the hope that it will be useful,
 ..    but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst b/Documentation/media/uapi/mediactl/request-func-poll.rst
index 2609fd54d519..ebaf33e21873 100644
--- a/Documentation/media/uapi/mediactl/request-func-poll.rst
+++ b/Documentation/media/uapi/mediactl/request-func-poll.rst
@@ -1,12 +1,12 @@
 .. This file is dual-licensed: you can use it either under the terms
-.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
+.. of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
 .. dual licensing only applies to this file, and not this project as a
 .. whole.
 ..
 .. a) This file is free software; you can redistribute it and/or
 ..    modify it under the terms of the GNU General Public License as
-..    published by the Free Software Foundation; either version 2 of
-..    the License, or (at your option) any later version.
+..    published by the Free Software Foundation version 2 of
+..    the License.
 ..
 ..    This file is distributed in the hope that it will be useful,
 ..    but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/v4l/bayer.svg b/Documentation/media/uapi/v4l/bayer.svg
index abec45b7873b..c5bf85103901 100644
--- a/Documentation/media/uapi/v4l/bayer.svg
+++ b/Documentation/media/uapi/v4l/bayer.svg
@@ -1,14 +1,14 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <!--
     This file is dual-licensed: you can use it either under the terms
-    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
     dual licensing only applies to this file, and not this project as a
     whole.
 
     a) This file is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License as
-       published by the Free Software Foundation; either version 2 of
-       the License, or (at your option) any later version.
+       published by the Free Software Foundation version 2 of
+       the License.
 
        This file is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/v4l/constraints.svg b/Documentation/media/uapi/v4l/constraints.svg
index 18e314c60757..08f9f8b0985e 100644
--- a/Documentation/media/uapi/v4l/constraints.svg
+++ b/Documentation/media/uapi/v4l/constraints.svg
@@ -1,14 +1,14 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <!--
     This file is dual-licensed: you can use it either under the terms
-    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
     dual licensing only applies to this file, and not this project as a
     whole.
 
     a) This file is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License as
-       published by the Free Software Foundation; either version 2 of
-       the License, or (at your option) any later version.
+       published by the Free Software Foundation version 2 of
+       the License.
 
        This file is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/v4l/nv12mt.svg b/Documentation/media/uapi/v4l/nv12mt.svg
index 54ae99d64342..067d8fb34ba2 100644
--- a/Documentation/media/uapi/v4l/nv12mt.svg
+++ b/Documentation/media/uapi/v4l/nv12mt.svg
@@ -1,14 +1,14 @@
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
 <!--
     This file is dual-licensed: you can use it either under the terms
-    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
     dual licensing only applies to this file, and not this project as a
     whole.
 
     a) This file is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License as
-       published by the Free Software Foundation; either version 2 of
-       the License, or (at your option) any later version.
+       published by the Free Software Foundation version 2 of
+       the License.
 
        This file is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/v4l/nv12mt_example.svg b/Documentation/media/uapi/v4l/nv12mt_example.svg
index 5eb8bcacc56c..70c3200fdb32 100644
--- a/Documentation/media/uapi/v4l/nv12mt_example.svg
+++ b/Documentation/media/uapi/v4l/nv12mt_example.svg
@@ -1,14 +1,14 @@
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
 <!--
     This file is dual-licensed: you can use it either under the terms
-    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
     dual licensing only applies to this file, and not this project as a
     whole.
 
     a) This file is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License as
-       published by the Free Software Foundation; either version 2 of
-       the License, or (at your option) any later version.
+       published by the Free Software Foundation version 2 of
+       the License.
 
        This file is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/Documentation/media/uapi/v4l/selection.svg b/Documentation/media/uapi/v4l/selection.svg
index eeb195744e60..59d2bec9b278 100644
--- a/Documentation/media/uapi/v4l/selection.svg
+++ b/Documentation/media/uapi/v4l/selection.svg
@@ -1,14 +1,14 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <!--
     This file is dual-licensed: you can use it either under the terms
-    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
     dual licensing only applies to this file, and not this project as a
     whole.
 
     a) This file is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License as
-       published by the Free Software Foundation; either version 2 of
-       the License, or (at your option) any later version.
+       published by the Free Software Foundation version 2 of
+       the License.
 
        This file is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
-- 
2.19.2

