Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35853 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab1IRUlK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 16:41:10 -0400
Received: by pzk1 with SMTP id 1so8826923pzk.1
        for <linux-media@vger.kernel.org>; Sun, 18 Sep 2011 13:41:09 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 18 Sep 2011 22:41:09 +0200
Message-ID: <CACiveRuv4iT1ck-so_+_=MXHXgtZpy0hNkgk_uXxo46GtSWaGw@mail.gmail.com>
Subject: em28xx: new board id [eb1a:2870]
From: Karim <gouchi@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I've made some tests with my Pinnacle PCTV Stick[1]

Model: Pinnacle PCTV Stick
Vendor/Product id: [eb1a:2870].

lsusb :
Bus 001 Device 009: ID eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV Stick

Dmesg with kernel 3.0 :
http://pastebin.com/VDpczS7V

Tests made with Kaffeine :

     - Analog [Worked]
     - DVB    [Worked]

I have tested this driver[2] with this patch[3]
(em28xx-new-2.6.35-patch) and it works on 2.6.XX

Is it possible to port it to 3.0 ?

Thank you, best regards.

[1] http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_unidentified_DVB-T_USB_device
[2] http://bitbucket.org/mdonoughe/em28xx-new
[3] http://archlinux.pastebin.com/nfwA8sU9
