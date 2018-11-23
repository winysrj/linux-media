Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730291AbeKXFYQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 00:24:16 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Johannes Stezenbach <js@linuxtv.org>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Marcus Metzler <mocm@metzlerbros.de>,
        Sean Young <sean@mess.org>,
        Michael Ira Krufky <mkrufky@gmail.com>
Subject: [PATCH 1/6] Documentation/media: uapi: Explicitly say there are no Invariant Sections
Date: Fri, 23 Nov 2018 16:38:34 -0200
Message-Id: <40fbc109b12284194711c2892a2b9644fbd83ddf.1542997584.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1542997584.git.mchehab+samsung@kernel.org>
References: <cover.1542997584.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ben Hutchings <ben@decadent.org.uk>

The GNU Free Documentation License allows for a work to specify
Invariant Sections that are not allowed to be modified.  (Debian
considers that this makes such works non-free.)

The Linux Media Infrastructure userspace API documentation does not
specify any such sections, but it also doesn't say there are none (as
is recommended by the license text).  Make it explicit that there are
none.

References: https://bugs.debian.org/698668
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sylwester Nawrocki <snawrocki@kernel.org>
Signed-off-by: Johannes Stezenbach <js@linuxtv.org>
Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Marcus Metzler <mocm@metzlerbros.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Michael Ira Krufky <mkrufky@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/media_uapi.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index 28eb35a1f965..5198ff24a094 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -10,9 +10,9 @@ Linux Media Infrastructure userspace API
 
 Permission is granted to copy, distribute and/or modify this document
 under the terms of the GNU Free Documentation License, Version 1.1 or
-any later version published by the Free Software Foundation. A copy of
-the license is included in the chapter entitled "GNU Free Documentation
-License".
+any later version published by the Free Software Foundation, with no
+Invariant Sections. A copy of the license is included in the chapter
+entitled "GNU Free Documentation License".
 
 .. only:: html
 
-- 
2.19.1
