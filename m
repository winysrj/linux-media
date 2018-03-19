Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:43119 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755821AbeCSPn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 11:43:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/8] media-ioc-g-topology.rst: fix 'reserved' sizes
Date: Mon, 19 Mar 2018 16:43:17 +0100
Message-Id: <20180319154324.37799-2-hverkuil@xs4all.nl>
In-Reply-To: <20180319154324.37799-1-hverkuil@xs4all.nl>
References: <20180319154324.37799-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The size of the reserved arrays in the documentation is wrong. Sync
this with the actual header.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index c8f9ea37db2d..fca4a22f6a45 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -211,7 +211,7 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [12]
+       -  ``reserved``\ [6]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
@@ -334,7 +334,7 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [9]
+       -  ``reserved``\ [5]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
@@ -390,7 +390,7 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [5]
+       -  ``reserved``\ [6]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
-- 
2.15.1
