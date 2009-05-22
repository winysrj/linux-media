Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:48715 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZEVKTS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 06:19:18 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@desy.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] flexcop-pci: dmesg visible names broken
Date: Fri, 22 May 2009 12:19:14 +0200
Cc: Uwe Bugla <uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iwnFKzcbE176Xt2"
Message-Id: <200905221219.14832.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_iwnFKzcbE176Xt2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there!

The patch hg 11287: 39b90315474c broke user visible names of flexcop-pci 
devices, as it did reorder the enum of card types, but did not adjust the 
array containing the card names.
This patch reorders the names, and also uses
[FC_AIR_DVBT]   = "Air2PC/AirStar 2 DVB-T"
assignment style for more clarity.

It also adds the revision Number to the name for SkyStar rev. 2.3 and rev 2.6 
as I think it is useful to see in log output.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Regards
Matthias

--Boundary-00=_iwnFKzcbE176Xt2
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="flexcop-card-names.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="flexcop-card-names.diff"

Index: v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop-misc.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/b2c2/flexcop-misc.c
+++ v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop-misc.c
@@ -46,16 +46,16 @@ static const char *flexcop_revision_name
 };
 
 static const char *flexcop_device_names[] = {
-	"Unknown device",
-	"Air2PC/AirStar 2 DVB-T",
-	"Air2PC/AirStar 2 ATSC 1st generation",
-	"Air2PC/AirStar 2 ATSC 2nd generation",
-	"Sky2PC/SkyStar 2 DVB-S",
-	"Sky2PC/SkyStar 2 DVB-S (old version)",
-	"Cable2PC/CableStar 2 DVB-C",
-	"Air2PC/AirStar 2 ATSC 3rd generation (HD5000)",
-	"Sky2PC/SkyStar 2 DVB-S rev 2.7a/u",
-	"Sky2PC/SkyStar 2 DVB-S rev 2.8",
+	[FC_UNK]	= "Unknown device",
+	[FC_CABLE]	= "Cable2PC/CableStar 2 DVB-C",
+	[FC_AIR_DVBT]	= "Air2PC/AirStar 2 DVB-T",
+	[FC_AIR_ATSC1]	= "Air2PC/AirStar 2 ATSC 1st generation",
+	[FC_AIR_ATSC2]	= "Air2PC/AirStar 2 ATSC 2nd generation",
+	[FC_AIR_ATSC3]	= "Air2PC/AirStar 2 ATSC 3rd generation (HD5000)",
+	[FC_SKY_REV23]	= "Sky2PC/SkyStar 2 DVB-S rev 2.3 (old version)",
+	[FC_SKY_REV26]	= "Sky2PC/SkyStar 2 DVB-S rev 2.6",
+	[FC_SKY_REV27]	= "Sky2PC/SkyStar 2 DVB-S rev 2.7a/u",
+	[FC_SKY_REV28]	= "Sky2PC/SkyStar 2 DVB-S rev 2.8",
 };
 
 static const char *flexcop_bus_names[] = {

--Boundary-00=_iwnFKzcbE176Xt2--
