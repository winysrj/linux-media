Return-path: <linux-media-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:38682 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZATTFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 14:05:50 -0500
Received: from G6W0640.americas.hpqcorp.net (g6w0640.atlanta.hp.com [16.230.34.76])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by g5t0006.atlanta.hp.com (Postfix) with ESMTPS id 285ECC08F
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 19:05:47 +0000 (UTC)
From: "Luhrs, Arne F.E." <arne.luehrs@hp.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 20 Jan 2009 19:05:42 +0000
Subject: [PATCH] Hauppauge WinTV-Nova-T 500 - problem wit internal IR
 receiver
Message-ID: <1A5872E54ACA7C40BE798507A106BB203ADEC6B4D8@GVW1163EXB.americas.hpqcorp.net>
References: <f6e4f67d0901200834o1933d4d0n6687cfb9b3d87032@mail.gmail.com>
In-Reply-To: <f6e4f67d0901200834o1933d4d0n6687cfb9b3d87032@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset:   10236:f49ac8245842
tag:         tip
user:        Arne Luehrs <arne.luehrs@googlemail.com>
date:        Wed Jan 14 23:01:07 2009 +0100
files:       linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
description:
[PATCH] enable IR receiver in Nova TD usb stick (52009)

From: Arne Luehrs <arne.luehrs@googlemail.com>

Adds the IR data structur to the configuration datastructure of the
Hauppauge WinTV Nova-TD USB stick (52009)

Provided remote control is the same as theone provided with the Nova-T500
Card.

Priority: normal


Signed-off-by: Arne Luehrs <arne.luehrs@googlemail.com>
diff -r 6896782d783d -r f49ac8245842 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Wed Jan 14 10:06:12 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Wed Jan 14 23:01:07 2009 +0100
@@ -1683,7 +1683,12 @@
                                { &dib0700_usb_id_table[43], NULL },

                                { NULL },
                        }
-               }
+               },
+
+               .rc_interval      = DEFAULT_RC_INTERVAL,
+               .rc_key_map       = dib0700_rc_keys,
+               .rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+               .rc_query         = dib0700_rc_query
        }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
                .num_adapters = 1, 

