Return-path: <mchehab@pedra>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:42489 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab0HUFUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Aug 2010 01:20:32 -0400
Received: from mail-in-02-z2.arcor-online.net (mail-in-02-z2.arcor-online.net [151.189.8.14])
	by mx.arcor.de (Postfix) with ESMTP id 6C49C26743
	for <linux-media@vger.kernel.org>; Sat, 21 Aug 2010 07:20:25 +0200 (CEST)
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net [151.189.21.53])
	by mail-in-02-z2.arcor-online.net (Postfix) with ESMTP id 4DE2C1754A5
	for <linux-media@vger.kernel.org>; Sat, 21 Aug 2010 07:20:25 +0200 (CEST)
Received: from server.kruemel.org (dslb-084-056-189-091.pools.arcor-ip.net [84.56.189.91])
	by mail-in-13.arcor-online.net (Postfix) with ESMTP id 30DF3212762
	for <linux-media@vger.kernel.org>; Sat, 21 Aug 2010 07:20:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by server.kruemel.org (Postfix) with ESMTP id 8B5D81284A8
	for <linux-media@vger.kernel.org>; Sat, 21 Aug 2010 07:20:23 +0200 (CEST)
Received: from server.kruemel.org ([127.0.0.1])
	by localhost (server.kruemel.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZmFkiyCY6GdK for <linux-media@vger.kernel.org>;
	Sat, 21 Aug 2010 07:20:13 +0200 (CEST)
Received: from www.kruemel.org (server.kruemel.org [192.168.1.55])
	by server.kruemel.org (Postfix) with ESMTPA id CFA1312849E
	for <linux-media@vger.kernel.org>; Sat, 21 Aug 2010 07:20:13 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Aug 2010 07:20:13 +0200
From: <cvb@kruemel.org>
To: <linux-media@vger.kernel.org>
Subject: TT S2 3650, s2-liplianin - errors
Message-ID: <693e630369862d963d02506feafcce0f@mail.kruemel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

I'm using a TT S2-3650 with s2-liaplianin (HG clone, Aug 17, 2010). While
basically the device works fine with HD and SD, also the CAM, after some
time I get error messages like, e.g.:

Aug 20 09:51:42 gaia kernel: [92157.290442] dvb-usb: bulk message failed:
-110 (4/0)
Aug 20 09:51:42 gaia kernel: [92157.290452] pctv452e: CI error -110; AA 06
40 -> AA 06 40.
Aug 20 09:51:44 gaia kernel: [92159.290511] dvb-usb: bulk message failed:
-110 (4/0)
Aug 20 09:51:44 gaia kernel: [92159.290520] dvb-usb: error while querying
for an remote control event.
Aug 20 09:51:46 gaia kernel: [92161.288077] dvb-usb: bulk message failed:
-110 (5/0)
Aug 20 09:51:46 gaia kernel: [92161.288087] pctv452e: CI error -110; AA 08
46 -> AA 08 46.
Aug 20 09:51:48 gaia kernel: [92163.296741] dvb-usb: bulk message failed:
-110 (4/0)
Aug 20 09:51:48 gaia kernel: [92163.296751] pctv452e: CI error -110; AA 0A
40 -> AA 0A 40.
Aug 20 09:51:50 gaia kernel: [92165.296648] dvb-usb: bulk message failed:
-110 (4/0)
Aug 20 09:51:50 gaia kernel: [92165.296658] dvb-usb: error while querying
for an remote control event.

I also get sometimes LOTS of:

Aug 20 10:06:00 gaia kernel: [93014.706578] pctv452e: CI error -2; AA CE
40 -> AA CE 40.
Aug 20 10:06:00 gaia kernel: [93014.706587] dvb-usb: bulk message failed:
-2 (4/0)
Aug 20 10:06:00 gaia kernel: [93014.706593] pctv452e: CI error -2; AA D2
40 -> AA D2 40.
Aug 20 10:06:00 gaia kernel: [93014.706600] dvb-usb: bulk message failed:
-2 (4/0)
Aug 20 10:06:00 gaia kernel: [93014.706606] pctv452e: CI error -2; AA D3
40 -> AA D3 40.
Aug 20 10:06:00 gaia kernel: [93014.706613] dvb-usb: bulk message failed:
-2 (4/0)
Aug 20 10:06:00 gaia kernel: [93014.706619] pctv452e: CI error -2; AA D4
40 -> AA D4 40.
Aug 20 10:06:00 gaia kernel: [93014.706627] dvb-usb: bulk message failed:
-2 (4/0)
Aug 20 10:06:00 gaia kernel: [93014.706633] pctv452e: CI error -2; AA D5
40 -> AA D5 40.
Aug 20 10:06:00 gaia kernel: [93014.706640] dvb-usb: bulk message failed:
-2 (4/0)
Aug 20 10:06:00 gaia kernel: [93014.706646] pctv452e: CI error -2; AA D6
40 -> AA D6 40.
Aug 20 10:06:00 gaia kernel: [93014.706653] dvb-usb: bulk message failed:
-2 (4/0)
Aug 20 10:06:00 gaia kernel: [93014.706659] pctv452e: CI error -2; AA D7
40 -> AA D7 40.
Aug 20 10:06:00 gaia kernel: [93014.706666] dvb-usb: bulk message failed:
-2 (4/0)
Aug 20 10:06:00 gaia kernel: [93014.706672] pctv452e: CI error -2; AA D8
40 -> AA D8 40.
Aug 20 10:06:00 gaia kernel: [93014.706680] dvb-usb: bulk message failed:
-2 (4/0)
Aug 20 10:06:00 gaia kernel: [93014.706686] pctv452e: CI error -2; AA D9
40 -> AA D9 40.

(hundreds in a second)

Any of these pretty much renders the system unusable and requires a
reboot. I googled a bit, and found a similar report here from about a year
ago, but I don't think I found a solution to this. 

Any hint would be most appreciated.

Thanks, Christian
