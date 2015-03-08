Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44452 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbbCHHyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 03:54:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] DocBook media: fix xv601/709 formulas
Date: Sun,  8 Mar 2015 08:53:30 +0100
Message-Id: <1425801213-14230-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
References: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The denominator for the scaling and offsets is 256, not 255. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 13540fa..f2175f0 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -790,9 +790,9 @@ case the BT.601 Y'CbCr encoding is used.</para>
 is similar to the Rec. 709 encoding, but it allows for R', G' and B' values that are outside the range
 [0&hellip;1]. The resulting Y', Cb and Cr values are scaled and offset:</term>
 	  <listitem>
-            <para>Y'&nbsp;=&nbsp;(219&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.2126R'&nbsp;+&nbsp;0.7152G'&nbsp;+&nbsp;0.0722B')&nbsp;+&nbsp;(16&nbsp;/&nbsp;255)</para>
-            <para>Cb&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(-0.1146R'&nbsp;-&nbsp;0.3854G'&nbsp;+&nbsp;0.5B')</para>
-            <para>Cr&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.5R'&nbsp;-&nbsp;0.4542G'&nbsp;-&nbsp;0.0458B')</para>
+            <para>Y'&nbsp;=&nbsp;(219&nbsp;/&nbsp;256)&nbsp;*&nbsp;(0.2126R'&nbsp;+&nbsp;0.7152G'&nbsp;+&nbsp;0.0722B')&nbsp;+&nbsp;(16&nbsp;/&nbsp;256)</para>
+            <para>Cb&nbsp;=&nbsp;(224&nbsp;/&nbsp;256)&nbsp;*&nbsp;(-0.1146R'&nbsp;-&nbsp;0.3854G'&nbsp;+&nbsp;0.5B')</para>
+            <para>Cr&nbsp;=&nbsp;(224&nbsp;/&nbsp;256)&nbsp;*&nbsp;(0.5R'&nbsp;-&nbsp;0.4542G'&nbsp;-&nbsp;0.0458B')</para>
 	  </listitem>
 	</varlistentry>
       </variablelist>
@@ -802,9 +802,9 @@ is similar to the Rec. 709 encoding, but it allows for R', G' and B' values that
 to the BT.601 encoding, but it allows for R', G' and B' values that are outside the range
 [0&hellip;1]. The resulting Y', Cb and Cr values are scaled and offset:</term>
 	  <listitem>
-            <para>Y'&nbsp;=&nbsp;(219&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B')&nbsp;+&nbsp;(16&nbsp;/&nbsp;255)</para>
-            <para>Cb&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B')</para>
-            <para>Cr&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B')</para>
+            <para>Y'&nbsp;=&nbsp;(219&nbsp;/&nbsp;256)&nbsp;*&nbsp;(0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B')&nbsp;+&nbsp;(16&nbsp;/&nbsp;256)</para>
+            <para>Cb&nbsp;=&nbsp;(224&nbsp;/&nbsp;256)&nbsp;*&nbsp;(-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B')</para>
+            <para>Cr&nbsp;=&nbsp;(224&nbsp;/&nbsp;256)&nbsp;*&nbsp;(0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B')</para>
 	  </listitem>
 	</varlistentry>
       </variablelist>
-- 
2.1.4

