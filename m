Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:37534 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755310Ab2B1Skp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 13:40:45 -0500
Message-ID: <4F4D1FA8.1090100@gmx.de>
Date: Tue, 28 Feb 2012 19:40:40 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] stb0899: set FE_HAS_SIGNAL flag in read_status
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In stb0899_read_status the FE_HAS_SIGNAL flag was not set in case of a
successful carrier lock. This change fixes that.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>
---
  drivers/media/dvb/frontends/stb0899_drv.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb0899_drv.c 
b/drivers/media/dvb/frontends/stb0899_drv.c
index 38565be..4a58afc 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1071,7 +1071,7 @@ static int stb0899_read_status(struct dvb_frontend 
*fe, enum fe_status *status)
  			reg  = stb0899_read_reg(state, STB0899_VSTATUS);
  			if (STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg)) {
  				dprintk(state->verbose, FE_DEBUG, 1, "--------> FE_HAS_CARRIER | 
FE_HAS_LOCK");
-				*status |= FE_HAS_CARRIER | FE_HAS_LOCK;
+				*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
   				reg = stb0899_read_reg(state, STB0899_PLPARM);
  				if (STB0899_GETFIELD(VITCURPUN, reg)) {
@@ -1088,7 +1088,7 @@ static int stb0899_read_status(struct dvb_frontend 
*fe, enum fe_status *status)
  		if (internal->lock) {
  			reg = STB0899_READ_S2REG(STB0899_S2DEMOD, DMD_STAT2);
  			if (STB0899_GETFIELD(UWP_LOCK, reg) && STB0899_GETFIELD(CSM_LOCK, 
reg)) {
-				*status |= FE_HAS_CARRIER;
+				*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
  				dprintk(state->verbose, FE_DEBUG, 1,
  					"UWP & CSM Lock ! ---> DVB-S2 FE_HAS_CARRIER");
  -- 1.7.2.5

