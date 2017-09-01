Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48335
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752213AbdIATh6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:37:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 05/14] media: ca-fopen.rst: Fixes the device node name for CA
Date: Fri,  1 Sep 2017 16:37:41 -0300
Message-Id: <74308980422ba1ae05a8f6279e5dce6095a3e797.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device node name for CA is wrong since ever. I suspect
that the name there was before DVBv3 (with was the first API
introduced at the Kernel).

Anyway, use the right name there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-fopen.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
index c974a212b618..51ac27dfec75 100644
--- a/Documentation/media/uapi/dvb/ca-fopen.rst
+++ b/Documentation/media/uapi/dvb/ca-fopen.rst
@@ -49,8 +49,8 @@ Arguments
 Description
 -----------
 
-This system call opens a named ca device (e.g. /dev/ost/ca) for
-subsequent use.
+This system call opens a named ca device (e.g. ``/dev/dvb/adapter?/ca?``)
+for subsequent use.
 
 When an open() call has succeeded, the device will be ready for use. The
 significance of blocking or non-blocking mode is described in the
-- 
2.13.5
