Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:43017 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388249AbeGXMPW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 08:15:22 -0400
Subject: [PATCHv6.1 11/12] media-ioc-enum-links.rst: improve pad index
 description
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
 <20180710084512.99238-12-hverkuil@xs4all.nl>
Message-ID: <857cefe5-df1d-a419-e3a8-89845a9916cb@xs4all.nl>
Date: Tue, 24 Jul 2018 13:09:24 +0200
MIME-Version: 1.0
In-Reply-To: <20180710084512.99238-12-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make it clearer that the index starts at 0.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
Dropped the text about stable index values.
---
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index 17abdeed1a9c..f158c134e9b0 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -92,7 +92,7 @@ returned during the enumeration process.

     *  -  __u16
        -  ``index``
-       -  0-based pad index.
+       -  Pad index, starts at 0.

     *  -  __u32
        -  ``flags``
-- 
2.18.0
