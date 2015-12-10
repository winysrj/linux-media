Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33891 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbbLJMoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 07:44:16 -0500
Received: by mail-ig0-f181.google.com with SMTP id g19so16670136igv.1
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2015 04:44:16 -0800 (PST)
Received: from [10.0.1.175] (dhcp-108-168-93-48.cable.user.start.ca. [108.168.93.48])
        by smtp.gmail.com with ESMTPSA id k66sm4998029ioi.43.2015.12.10.04.44.14
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 10 Dec 2015 04:44:14 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: [PATCH 2] ca-ON-Toronto: adding scan file for Toronto, Canada, added channel numbers
From: Maury Markowitz <maury.markowitz@gmail.com>
In-Reply-To: <3DC79E44-2C1C-40C8-B9AA-D77614D50C3E@gmail.com>
Date: Thu, 10 Dec 2015 07:44:14 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <0F6FB50D-C525-4B01-AD84-D70B3F56F2BE@gmail.com>
References: <201512081149525312370@gmail.com> <56687B09.4050004@kapsi.fi> <3DC79E44-2C1C-40C8-B9AA-D77614D50C3E@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have moved the channel numbers into the CHANNEL lines. I used the “physical channel number” which seems appropriate in this case. I would like to add a working entry for 22, but not sure what the DELIVERY_SYSTEM is?

---
 atsc/ca-ON-Toronto | 200 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 200 insertions(+)
 create mode 100644 atsc/ca-ON-Toronto

diff --git a/atsc/ca-ON-Toronto b/atsc/ca-ON-Toronto
new file mode 100644
index 0000000..3923f64
--- /dev/null
+++ b/atsc/ca-ON-Toronto
@@ -0,0 +1,200 @@
+#------------------------------------------------------------------------------
+# location			   : Toronto, ON, Canada
+# provider			   : OTA
+# date (yyyy-mm-dd)    : 2015-12-09
+# provided by (opt)    : maury.markowitz@gmail.com
+#------------------------------------------------------------------------------
+#
+# The following list are the main channels available in Toronto, including
+# both local channels as well as those from the US in the Buffalo area.
+# More distant stations like Rochester and Syracuse are listed below
+#
+#------------------------------------------------------------------------------
+# CFTO, Toronto CTV, physical channel 9, virtual channel 9, 17.4 kW, 1611' CN tower, 43.642500 -79.387222
+[CHANNEL 9]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 189028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WUTV, Buffalo FOX, physical channel 14, virtual channel 29, 1000 kW, 981' tower, 43.025612 -78.928373
+[CHANNEL 14]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 473028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CHCH, Hamilton independent, physical channel 15, virtual channel 11, 132 kW, unknown tower, 43.207500 -79.774167
+[CHANNEL 15]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 479028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CICA, Toronto TVO, physical channel 19, virtual channel 19, 106.5 kW, 1611' CN tower, 43.642500 -79.387222
+[CHANNEL 19]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 503028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CBLT, Toronto CBC, physical channel 20, virtual channel 5, 38 kW, 1611' CN tower, 43.642500 -79.387222
+[CHANNEL 20]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 509028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CBLFT, Toronto CBC French, physical channel 25, virtual channel 25, 2.5 kW, 1611' CN tower, 43.642500 -79.387222
+[CHANNEL 25]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 539028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WNLO, Buffalo CW, physical channel 32, virtual channel 23, 1000 kW, 994' tower, 43.030057 -78.920594
+[CHANNEL 32]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 581028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WGRZ, Buffalo NBC, physical channel 33, virtual channel 2, 480 kW, 968' tower, 42.718671 -78.562801
+[CHANNEL 33]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 587028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CHCJ, Hamilton CTV Two, physical channel 35, virtual channel 35, 390 kW, unknown tower, 43.231667 -79.859167
+[CHANNEL 35]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 599028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CITS, Hamilton CTS, physical channel 36, virtual channel 36, 5 kW, unknown tower, 43.207500 -79.774167
+[CHANNEL 36]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 605028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WKBW, Buffalo ABC, physical channel 38, virtual channel 7, 358 kW, 1420' tower, 42.637505 -78.619719
+[CHANNEL 38]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 611028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WIVB, Buffalo CBS, physical channel 39, virtual channel 4, 790 kW, 1368' tower, 42.659227 -78.625581
+[CHANNEL 39]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 623028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CJMT, Toronto Omni, physical channel 40, virtual channel 40, 19.5 kW, 1611' CN tower, 43.642500 -79.387222
+[CHANNEL 40]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 629028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CIII, Toronto Global, physical channel 41, virtual channel 41, 38 kW, 1611' CN tower, 43.642500 -79.387222
+[CHANNEL 41]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 635028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WNED, Buffalo PBS, physical channel 43, virtual channel 17, 473 kW, 1110' tower, 43.207500 -79.774167
+[CHANNEL 43]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 647028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CITY, Toronto independent, physical channel 44, virtual channel 57, 21 kW, 1611' CN tower, 43.642500 -79.387222
+[CHANNEL 44]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 653028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CFMT, Toronto Omni 2, physical channel 47, virtual channel 47, 22.2 kW, 1611' CN tower, 43.642500 -79.387222
+[CHANNEL 47]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 671028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WNYO, Buffalo MyN, physical channel 49, virtual channel 49, 198 kW, 946' tower, 42.782838 -78.457521
+[CHANNEL 49]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 683028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+#------------------------------------------------------------------------------
+#
+# The following stations are much more difficult to receive from the Toronto
+# area, either weaker transmitters, being at odd angles, or are further from
+# the Toronto area
+#
+#------------------------------------------------------------------------------
+
+# WBBZ, Buffalo MeTV, physical channel 7, virtual channel 67, 26.9 kW, unknown tower, 42.567839 -78.723083
+[CHANNEL 7]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 177028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CKVR, Barrie A, physical channel 10, virtual channel 10, 11 kW, 1611' CN tower, 44.351389 -79.698333
+[CHANNEL 10]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 195028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CHEX, Peterborough CBC, physical channel 12, virtual channel 12, 20 kW, unknown tower, 44.328056 -78.299444
+[CHANNEL 12]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 207028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WPXJ, Batavia ION, physical channel 23, virtual channel 51, 455 kW, unknown tower, 42.895061 -78.015288
+[CHANNEL 23]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 527028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# WYNB, Buffalo independent, physical channel 26, virtual channel 26, 243 kW, unknown tower, 42.393392 -79.228653
+[CHANNEL 26]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 545028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# CKVP, St. Catherine's TVO, physical channel 42, virtual channel 42, 11 kW, 496' tower, 43.051667 -79.300833
+[CHANNEL 42]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 641028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+#------------------------------------------------------------------------------
+#
+# The following stations are NTSC analog
+#
+#------------------------------------------------------------------------------
+
+# CHEX, Courtice CBC, physical channel 22, virtual channel 22, 6 kW, unknown tower, 43.954167 -78.806389
+#[CHANNEL 22]
+#	DELIVERY_SYSTEM = ATSC
+#	FREQUENCY = 521028615
+#	MODULATION = VSB/8
+#	INVERSION = AUTO
-- 
2.5.4 (Apple Git-61)


