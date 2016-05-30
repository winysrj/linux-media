Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:2953 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754822AbcE3M3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2016 08:29:33 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	<Tiffany.lin@mediatek.com>, Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v3 3/9] DocBook/v4l: Add compressed video formats used on MT8173 codec driver
Date: Mon, 30 May 2016 20:29:17 +0800
Message-ID: <1464611363-14936-4-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1464611363-14936-3-git-send-email-tiffany.lin@mediatek.com>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-2-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-3-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_PIX_FMT_MT21 documentation

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 5a08aee..d40e0ce 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1980,6 +1980,12 @@ array. Anything what's in between the UYVY lines is JPEG data and should be
 concatenated to form the JPEG stream. </para>
 </entry>
 	  </row>
+	  <row id="V4L2_PIX_FMT_MT21">
+	    <entry><constant>V4L2_PIX_FMT_MT21</constant></entry>
+	    <entry>'MT21'</entry>
+	    <entry>Compressed two-planar YVU420 format used by Mediatek MT8173
+	    codec driver.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
1.7.9.5

