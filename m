Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4149 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0IKIoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 04:44:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: [PATCH] Illuminators control
Date: Sat, 11 Sep 2010 10:43:56 +0200
Cc: linux-media@vger.kernel.org
References: <20100911102426.548450b3@tele>
In-Reply-To: <20100911102426.548450b3@tele>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009111043.56573.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Saturday, September 11, 2010 10:24:26 Jean-Francois Moine wrote:
> Hi,
> 
> This new proposal cancels the previous patch 'Illuminators and status
> LED controls'.
> 
> Cheers.
> 
> 
diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 8408caa..4226a9e 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -312,10 +312,17 @@ minimum value disables backlight compensation.</entry>
 	    information and bits 24-31 must be zero.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CID_ILLUMINATORS_0</constant>
+		<constant>V4L2_CID_ILLUMINATORS_1</constant></entry>
+	    <entry>oolean</entry>

Typo: 'oolean' -> boolean :-)

+	    <entry>Switch on or off the illuminator 0 or 1 of the device
+		(usually a microscope).</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
 	    <entry></entry>
 	    <entry>End of the predefined control IDs (currently
-<constant>V4L2_CID_BG_COLOR</constant> + 1).</entry>
+<constant>V4L2_CID_ILLUMINATORS_1</constant> + 1).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>

I would recommend naming these controls ILLUMINATOR_1 and _2 instead of _0 and
_1. The average end-user starts counting at 1, not 0.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
