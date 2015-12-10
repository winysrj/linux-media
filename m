Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34728 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbLJNCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 08:02:41 -0500
Received: by ioir85 with SMTP id r85so91188696ioi.1
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2015 05:02:40 -0800 (PST)
Received: from [10.0.1.175] (dhcp-108-168-93-48.cable.user.start.ca. [108.168.93.48])
        by smtp.gmail.com with ESMTPSA id w8sm4975276igl.0.2015.12.10.05.02.39
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 10 Dec 2015 05:02:39 -0800 (PST)
From: Maury Markowitz <maury.markowitz@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] renaming NTSC file because it doesnt actually use 8VSV, updating channel listings, add channel numbers
Message-Id: <73D4FA62-27A0-4730-AC17-FD46B7DDFDF2@gmail.com>
Date: Thu, 10 Dec 2015 08:02:39 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is renamed to more accurately reflect its contents, as well as including all channels every used in NTSC. This is primarily of historical interest, the ATSC file has a more up-to-date (and much shorter) list to scan against. I notice that my local repo has the rm, but this isn’t reflected in the patch (of course), is there something else I should have done as well?

---
 atsc/us-NTSC-center-frequencies | 520 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 520 insertions(+)
 create mode 100644 atsc/us-NTSC-center-frequencies

diff --git a/atsc/us-NTSC-center-frequencies b/atsc/us-NTSC-center-frequencies
new file mode 100644
index 0000000..7d92c05
--- /dev/null
+++ b/atsc/us-NTSC-center-frequencies
@@ -0,0 +1,520 @@
+# US NTSC center frequencies
+# primarily of historical interest, many of these channels are no longer used
+#
+# see also: us-ATSC-center-frequencies-8VSB
+
+#
+# VHF low-band, channels 2 to 6, not used for digital
+#
+
+[CHANNEL 2]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 57028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 3]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 63028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 4]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 69028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 5]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 79028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 6]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 85028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+#
+# VHF high-band, channels 7 to 13. not common but a few digital stations use it
+# potentially hard to receive because modern antennas are tuned for UHF
+#
+
+[CHANNEL 7]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 177028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 8]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 183028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 9]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 189028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 10]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 195028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 11]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 201028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 12]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 207028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 13]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 213028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+#
+# UHF, channels 14 to 51, most existing stations, almost all digital
+#
+
+[CHANNEL 14]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 473028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 15]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 479028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 16]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 485028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 17]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 491028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 18]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 497028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 19]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 503028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 20]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 509028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 21]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 515028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 22]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 521028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 23]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 527028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 24]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 533028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 25]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 539028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 26]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 545028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 27]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 551028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 28]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 557028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 29]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 563028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 30]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 569028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 31]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 575028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 32]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 581028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 33]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 587028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 34]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 593028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 35]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 599028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 36]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 605028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+#channel 37, not used in North America due to interference with radio astronomy bands
+[CHANNEL 37]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 611028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 38]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 617028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 39]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 623028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 40]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 629028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 41]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 635028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 42]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 641028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 43]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 647028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 44]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 653028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 45]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 659028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 46]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 665028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 47]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 671028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 48]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 677028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 49]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 683028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 50]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 689028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+#
+# the following frequencies were formerly part of the UHF band before the digital transition
+# but were sold off to cell carriers in 2010 as the 700 MHz band and are no longer used for television
+#
+
+#channel 51 was originally included in the digital transition but
+# no longer used to clear interference with 700 MHz cell bands
+[CHANNEL 51]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 695028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 52]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 701028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 53]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 707028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 54]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 713028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 55]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 719028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 56]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 725028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 57]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 731028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 58]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 737028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 59]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 743028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 60]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 749028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 61]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 755028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 62]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 761028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 63]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 767028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 64]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 773028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 65]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 779028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 66]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 785028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 67]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 791028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 68]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 797028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 69]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 803028615
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+# UHF formerly had channels 70 through 83 as well
+
+[CHANNEL 70]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 809000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 71]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 815000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 72]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 821000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 73]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 827000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 74]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 833000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 75]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 839000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 76]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 845000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 77]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 851000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 78]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 857000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 79]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 863000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 80]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 869000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 81]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 875000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 82]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 881000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL 83]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 887000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
-- 
2.5.4 (Apple Git-61)


