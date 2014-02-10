Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38122 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaBJQVf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 11:21:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 6/6] DocBook: media: document PLL lock control
Date: Mon, 10 Feb 2014 18:21:19 +0200
Message-Id: <1392049279-13495-7-git-send-email-crope@iki.fi>
In-Reply-To: <1392049279-13495-1-git-send-email-crope@iki.fi>
References: <1392049279-13495-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document PLL lock V4L2 control. It is read only RF tuner control
which is used to inform if tuner is receiving frequency or not.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/controls.xml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 345b6e5..e6d4b50 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5077,6 +5077,15 @@ intermediate frequency output or baseband output. Used when
 <constant>V4L2_CID_IF_GAIN_AUTO</constant> is not set. The range and step are
 driver-specific.</entry>
             </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_PLL_LOCK</constant>&nbsp;</entry>
+              <entry>boolean</entry>
+            </row>
+            <row>
+              <entry spanname="descr">Is synthesizer PLL locked? RF tuner is
+receiving given frequency when that control is set. This is a read-only control.
+</entry>
+            </row>
           </tbody>
         </tgroup>
       </table>
-- 
1.8.5.3

