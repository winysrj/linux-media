Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36753 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165Ab2EOUo5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 16:44:57 -0400
Received: by wibhn6 with SMTP id hn6so19515wib.1
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 13:44:56 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] V4L: DocBook: Corrected focus control documentation
Date: Tue, 15 May 2012 22:44:39 +0200
Message-Id: <1337114679-18798-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <201205151320.19569.hverkuil@xs4all.nl>
References: <201205151320.19569.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove documentation chunk of not existent V4L2_CID_AUTO_FOCUS_AREA
control. It fixes following build error:

Error: no ID for constraint linkend: v4l2-auto-focus-area.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/compat.xml |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index dc61b01..b98f3bf 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2570,9 +2570,5 @@ ioctls.</para>
 	  <para>Sub-device selection API: &VIDIOC-SUBDEV-G-SELECTION;
 	  and &VIDIOC-SUBDEV-S-SELECTION; ioctls.</para>
         </listitem>
-        <listitem>
-	  <para><link linkend="v4l2-auto-focus-area"><constant>
-	  V4L2_CID_AUTO_FOCUS_AREA</constant></link> control.</para>
-        </listitem>
       </itemizedlist>
     </section>

--
1.7.4.1

