Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.borenet.se ([213.134.106.117]:42113 "EHLO
	mail-storage.borenet.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2DXT0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 15:26:30 -0400
Received: from [192.168.168.200] (static-81.216.61.114.addr.tdcsong.se [81.216.61.114])
	by mail-storage.borenet.se (Postfix) with ESMTPA id 657915FDBA9
	for <linux-media@vger.kernel.org>; Tue, 24 Apr 2012 21:19:37 +0200 (CEST)
Message-ID: <4F96FCCA.30106@lysator.liu.se>
Date: Tue, 24 Apr 2012 21:19:38 +0200
From: Magnus Ekhall <koma@lysator.liu.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: New version of Anysee E7 T2C?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I just got a new Anysee E7 T2C DVB-USB device.

When I load the module dvb-usb-anysee.ko "Driver Anysee E30 DVB-C &
DVB-T USB2.0" version 3.2.0-23-generic I get:

[    8.353474] DVB: registering new adapter (Anysee DVB USB2.0)
[    8.356162] anysee: firmware version:1.0 hardware id:20
[    8.356164] anysee: Unsupported Anysee version. Please report the
<linux-media@vger.kernel.org>.
[    8.356167] dvb-usb: no frontend was attached by 'Anysee DVB USB2.0'

Strange thing is that hardware id:20 should be supported by the driver
from what I can see in the source?

Any ideas?

/Magnus
