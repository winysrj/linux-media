Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54133 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbaB0AWW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:22:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 12/13] DocBook: media: document PLL lock control
Date: Thu, 27 Feb 2014 02:22:07 +0200
Message-Id: <1393460528-11684-13-git-send-email-crope@iki.fi>
In-Reply-To: <1393460528-11684-1-git-send-email-crope@iki.fi>
References: <1393460528-11684-1-git-send-email-crope@iki.fi>
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
index 5550fea..92e3335 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5077,6 +5077,15 @@ intermediate frequency output or baseband output. Used when
 <constant>V4L2_CID_RF_TUNER_IF_GAIN_AUTO</constant> is not set. The range and step are
 driver-specific.</entry>
             </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_RF_TUNER_PLL_LOCK</constant>&nbsp;</entry>
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

