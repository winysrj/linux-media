Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:55169 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaLTNg5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 08:36:57 -0500
Received: by mail-la0-f51.google.com with SMTP id ms9so2151270lab.10
        for <linux-media@vger.kernel.org>; Sat, 20 Dec 2014 05:36:56 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?David_Cimb=C5=AFrek?= <david.cimburek@gmail.com>
Date: Sat, 20 Dec 2014 14:36:25 +0100
Message-ID: <CAEmZozMwaymYObj0MQtnJrnyo0rm4DienfKec+E7N4MAsT2Lhg@mail.gmail.com>
Subject: [PATCH] media: Pinnacle 73e infrared control stopped working since
 kernel 3.17
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

with kernel 3.17 remote control for Pinnacle 73e (ID 2304:0237
Pinnacle Systems, Inc. PCTV 73e [DiBcom DiB7000PC]) does not work
anymore.

I checked the changes and found out the problem in commit
af3a4a9bbeb00df3e42e77240b4cdac5479812f9.

In dib0700_core.c in struct dib0700_rc_response the following union:

union {
    u16 system16;
    struct {
        u8 not_system;
        u8 system;
    };
};

has been replaced by simple variables:

u8 system;
u8 not_system;

But these variables are in reverse order! When I switch the order
back, the remote works fine again! Here is the patch:


--- a/drivers/media/usb/dvb-usr/dib0700_core.c    2014-12-20
14:27:15.000000000 +0100
+++ b/drivers/media/usb/dvb-usr/dib0700_core.c    2014-12-20
14:27:36.000000000 +0100
@@ -658,8 +658,8 @@
 struct dib0700_rc_response {
     u8 report_id;
     u8 data_state;
-    u8 system;
     u8 not_system;
+    u8 system;
     u8 data;
     u8 not_data;
 };


Regards,
David
