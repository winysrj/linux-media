Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:42285 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZASUoz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 15:44:55 -0500
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 38A4A7873BB
	for <linux-media@vger.kernel.org>; Mon, 19 Jan 2009 21:36:40 +0100 (CET)
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by smtp6-g21.free.fr (Postfix) with ESMTP id D68C7E080D4
	for <linux-media@vger.kernel.org>; Mon, 19 Jan 2009 21:35:55 +0100 (CET)
Received: from [192.168.0.3] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp6-g21.free.fr (Postfix) with ESMTP id DE372E081F6
	for <linux-media@vger.kernel.org>; Mon, 19 Jan 2009 21:35:52 +0100 (CET)
Message-ID: <4974E428.7020702@free.fr>
Date: Mon, 19 Jan 2009 21:35:52 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: haupauge remote keycode for av7110_loadkeys
Content-Type: multipart/mixed;
 boundary="------------020502000909070404020901"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020502000909070404020901
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I attached keycodes for 
http://www.hauppauge.eu/boutique_us/images_produits/1111111.jpg remote.

Can it be added to dvb-apps/util/av7110_loadkeys/ repo.

Matthieu

PS : this is more or less a duplicate of keycode in 
ir_codes_hauppauge_new (ir-kbd-i2c.c) and it could be useful to merge 
them. But I like better the av7110_loadkeys approch, because with 
ir-kbd-i2c you can't use other remote without modifying the source code.

--------------020502000909070404020901
Content-Type: text/plain;
 name="hauppauge_grey2.rc5"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="hauppauge_grey2.rc5"

CjB4M2QgS0VZX1BPV0VSCjB4M2IgS0VZX0dPVE8KCjB4MWMgS0VZX1RWCjB4MTggS0VZX1ZJ
REVPCjB4MTkgS0VZX0FVRElPCjB4MWEgS0VZX01IUAoweDFiIEtFWV9FUEcKMHgwYyBLRVlf
UkFESU8KCjB4MTQgS0VZX1VQCjB4MTYgS0VZX0xFRlQKMHgxNyBLRVlfUklHSFQKMHgxNSBL
RVlfRE9XTgoweDI1IEtFWV9FTlRFUgoKMHgxZiBLRVlfRVhJVAoweDBkIEtFWV9NRU5VCgow
eDEwIEtFWV9WT0xVTUVVUAoweDExIEtFWV9WT0xVTUVET1dOCjB4MjAgS0VZX0NIQU5ORUxV
UAoweDIxIEtFWV9DSEFOTkVMRE9XTgoweDEyIEtFWV9QUkVWSU9VUwoKMHgwZiBLRVlfTVVU
RQoweDMyIEtFWV9SRVdJTkQKMHgzNSBLRVlfUExBWQoweDM0IEtFWV9GQVNURk9SV0FSRAow
eDM3IEtFWV9SRUNPUkQKMHgzNiBLRVlfU1RPUAoweDMwIEtFWV9QQVVTRQoweDI0IEtFWV9Q
UkVWSU9VU1NPTkcKMHgxZSBLRVlfTkVYVFNPTkcKCjB4MDAgS0VZXzAKMHgwMSBLRVlfMQow
eDAyIEtFWV8yCjB4MDMgS0VZXzMKMHgwNCBLRVlfNAoweDA1IEtFWV81CjB4MDYgS0VZXzYK
MHgwNyBLRVlfNwoweDA4IEtFWV84CjB4MDkgS0VZXzkKMHgwYSBLRVlfVEVYVAoweDBlIEtF
WV9TVUJUSVRMRQoKMHgwYiBLRVlfUkVECjB4MmUgS0VZX0dSRUVOCjB4MzggS0VZX1lFTExP
VwoweDI5IEtFWV9CTFVFCgo=
--------------020502000909070404020901--
