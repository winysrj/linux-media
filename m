Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39791 "EHLO
	alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487AbaATSQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 13:16:23 -0500
Received: from alan.etchedpixels.co.uk (localhost [127.0.0.1])
	by alan.etchedpixels.co.uk (8.14.4/8.14.4/Debian-2.1ubuntu4) with ESMTP id s0KI34Y5007276
	for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 18:03:04 GMT
Subject: [PATCH] dvb-frontends: Add static
To: linux-media@vger.kernel.org
From: Alan <gnomes@lxorguk.ukuu.org.uk>
Date: Mon, 20 Jan 2014 18:03:04 +0000
Message-ID: <20140120180239.7250.13091.stgit@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add static to tda m_* variables in the header. They don't need to be global.
With some cleanup they could probably even be marked const.

Reported-by: Christian Schneider <christian@ch-sc.de>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=68191
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/media/dvb-frontends/tda18271c2dd_maps.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda18271c2dd_maps.h b/drivers/media/dvb-frontends/tda18271c2dd_maps.h
index b87661b..f3bca5c 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd_maps.h
+++ b/drivers/media/dvb-frontends/tda18271c2dd_maps.h
@@ -5,7 +5,7 @@ enum HF_S {
 	HF_DVBC_8MHZ, HF_DVBC
 };
 
-struct SStandardParam m_StandardTable[] = {
+static struct SStandardParam m_StandardTable[] = {
 	{       0,        0, 0x00, 0x00 },    /* HF_None */
 	{ 6000000,  7000000, 0x1D, 0x2C },    /* HF_B, */
 	{ 6900000,  8000000, 0x1E, 0x2C },    /* HF_DK, */
@@ -27,7 +27,7 @@ struct SStandardParam m_StandardTable[] = {
 	{       0,        0, 0x00, 0x00 },    /* HF_DVBC (Unused) */
 };
 
-struct SMap  m_BP_Filter_Map[] = {
+static struct SMap  m_BP_Filter_Map[] = {
 	{   62000000,  0x00 },
 	{   84000000,  0x01 },
 	{  100000000,  0x02 },
@@ -799,14 +799,14 @@ static struct SRFBandMap  m_RF_Band_Map[7] = {
 	{  865000000,  489500000,   697500000,  842000000},
 };
 
-u8 m_Thermometer_Map_1[16] = {
+static u8 m_Thermometer_Map_1[16] = {
 	60, 62, 66, 64,
 	74, 72, 68, 70,
 	90, 88, 84, 86,
 	76, 78, 82, 80,
 };
 
-u8 m_Thermometer_Map_2[16] = {
+static u8 m_Thermometer_Map_2[16] = {
 	92, 94, 98, 96,
 	106, 104, 100, 102,
 	122, 120, 116, 118,

