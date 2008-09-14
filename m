Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org, Steven Toth <stoth@linuxtv.org>,
	Darron Broad <darron@kewl.org>, Gregoire Favre <gregoire.favre@gmail.com>
Date: Sun, 14 Sep 2008 13:54:52 +0300
References: <48C70F88.4050701@linuxtv.org> <48CC3D67.8060204@linuxtv.org>
	<20071.1221355165@kewl.org>
In-Reply-To: <20071.1221355165@kewl.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_81OzI4h/95RCY6x"
Message-Id: <200809141354.52902.liplianin@tut.by>
Subject: [linux-dvb] [PATCH] S2API History update: MPEG initialization in
	cx24116.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_81OzI4h/95RCY6x
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

History update: MPEG initialization in cx24116.

Adjust MPEG initialization in cx24116 in order to accomodate different
MPEG CLK position and polarity in different cards. For example, HVR4000
uses 0x02 value, but DvbWorld & TeVii USB cards uses 0x01. Without it MPEG
stream was broken on that cards for symbol rates > 30000 kSyms/s.


Igor

--Boundary-00=_81OzI4h/95RCY6x
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8882.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8882.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1221389033 -10800
# Node ID 8d2354ca47b88394f089214ea33553cd66141a2f
# Parent  6f6a5f09096c6ca3c75bb1d3ec67283fceccbc47
History update: MPEG initialization in cx24116.

From: Igor M. Liplianin <liplianin@me.by>

Adjust MPEG initialization in cx24116 in order to accomodate different
MPEG CLK position and polarity in different cards. For example, HVR4000
uses 0x02 value, but DvbWorld & TeVii USB cards uses 0x01. Without it MPEG
stream was broken on that cards for symbol rates > 30000 kSyms/s.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 6f6a5f09096c -r 8d2354ca47b8 linux/drivers/media/dvb/frontends/cx24116.c
--- a/linux/drivers/media/dvb/frontends/cx24116.c	Sat Sep 13 18:42:16 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/cx24116.c	Sun Sep 14 13:43:53 2008 +0300
@@ -13,7 +13,8 @@
 	    Some clean ups.
     Copyright (C) 2008 Igor Liplianin
 	September, 9th 2008
-	Fixed locking on high symbol rates (>30000).
+	    Fixed locking on high symbol rates (>30000).
+	    Implement MPEG initialization parameter.
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by

--Boundary-00=_81OzI4h/95RCY6x
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_81OzI4h/95RCY6x--
