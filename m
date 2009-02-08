Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:40921 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbZBHTuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Feb 2009 14:50:16 -0500
Received: from mail-in-06-z2.arcor-online.net (mail-in-06-z2.arcor-online.net [151.189.8.18])
	by mx.arcor.de (Postfix) with ESMTP id C31B339A9FB
	for <linux-media@vger.kernel.org>; Sun,  8 Feb 2009 20:49:53 +0100 (CET)
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net [151.189.21.52])
	by mail-in-06-z2.arcor-online.net (Postfix) with ESMTP id B7BE55BFF2
	for <linux-media@vger.kernel.org>; Sun,  8 Feb 2009 20:49:52 +0100 (CET)
Received: from [192.168.0.2] (dslb-084-063-155-245.pools.arcor-ip.net [84.63.155.245])
	by mail-in-12.arcor-online.net (Postfix) with ESMTPS id 75DFE1B407D
	for <linux-media@vger.kernel.org>; Sun,  8 Feb 2009 20:49:27 +0100 (CET)
Subject: Driver for this DVB-T tuner?
From: Stefan Czinczoll <schollsky@arcor.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 08 Feb 2009 20:51:50 +0100
Message-Id: <1234122710.31277.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm trying to get my Terratec DVB-T USB (Cinergy T USB XE MKII) working
with linux. Any chance in the near future? It works with Windumb & BDA
drivers, but this is not what i want... ;-)

Below is from dmesg output.

Kind regards,

Stefan

[..]
dvb-usb: found a 'TerraTec Cinergy T USB XE' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (TerraTec Cinergy T USB XE)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
forcedeth 0000:00:05.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
af9013: firmware version:4.65.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
af9015: Freescale MC44S803 tuner found but no driver for thattuner. Look
at the Linuxtv.org for tuner driver
status.
dvb-usb: TerraTec Cinergy T USB XE successfully initialized and
connected.
usbcore: registered new interface driver dvb_usb_af9015
[..]

-- 
Stefan Czinczoll <schollsky@arcor.de>

