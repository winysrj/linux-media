Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63336 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3AAP20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 10:28:26 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so13581389vby.33
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 07:28:26 -0800 (PST)
MIME-Version: 1.0
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 1 Jan 2013 16:28:04 +0100
Message-ID: <CAFBinCA-gYcokd1jWheKhgJopD1-=+oO8_5CMrz_NqmfP+nvPg@mail.gmail.com>
Subject: get_dvb_firmware fails for a lot of firmwares
To: linux-media <linux-media@vger.kernel.org>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

while testing the firmware download for the drxk_terratec_htc_stick I
found that many other firmware downloads are broken.
Here is a list of failing downloads:

cx231xx: Hash of extracted file does not match!
drxk_hauppauge_hvr930c: Hash of extracted file does not match!
sp8870: File does not exist anymore (returns HTML error page)
http://www.softwarepatch.pl/9999ccd06a4813cb827dbb0005071c71/tt_Premium_217g.zip
ngene: HTTP 404 http://www.digitaldevices.de/download/ngene_15.fw
nxt2002: HTTP 404
http://www.bbti.us/download/windows/Technisat_DVB-PC_4_4_COMPACT.zip
nxt2004: HTTP 404
http://www.avermedia-usa.com/support/Drivers/AVerTVHD_MCE_A180_Drv_v1.2.2.16.zip
opera1: reports "Ran out of data"
lme2510_lg: file LMEBDA_DVBS.sys is not being downloaded
lme2510c_s7395: file US2A0D.sys is not being downloaded
lme2510c_s7395_old: file LMEBDA_DVBS7395C.sys is not being downloaded
tda10045: HTTP 404 http://www.technotrend.de/new/217g/tt_budget_217g.zip
tda10046: server refuses connection (temporary error?)
http://technotrend.com.ua/download/software/219/TT_PCI_2.19h_28_11_2006.zip
tda10046lifeview: domain name does not resolve
http://www.lifeview.hk/dbimages/document/7%5Cdrv_2.11.02.zip
vp7041: connection reset (temporary error?)
http://www.twinhan.com/files/driver/USB-Ter/2.422.zip

Just in case the formatting is messed up: here is a copy of the list: [0].

It seems that the gentoo guys mirrored some of the files which are
getting a 404: [1].

Regards,
Martin


[0]: http://paste.kde.org/634850/raw/
[1]: http://rsync16.de.gentoo.org/files/linuxtv-dvb-firmware/
