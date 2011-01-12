Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1ALSDw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 13:03:52 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0CI3q6I005612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 13:03:52 -0500
Received: from pedra (vpn-234-205.phx2.redhat.com [10.3.234.205])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0CI3oVP005945
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 13:03:51 -0500
Date: Wed, 12 Jan 2011 18:03:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] em28xx: Fix IR support for WinTV USB2
Message-ID: <20110112180344.49a2e92d@pedra>
In-Reply-To: <60241ee6346a9431dbfd751272285b15e87fe4e2.1294862613.git.mchehab@redhat.com>
References: <60241ee6346a9431dbfd751272285b15e87fe4e2.1294862613.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Due to a lack of a break inside the switch, it were getting the
wrong keytable and get_key function.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 099d5df..ba03a44 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2437,6 +2437,7 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 		dev->init_data.ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
 		dev->init_data.get_key = em28xx_get_key_em_haup;
 		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
+		break;
 	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
 		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;
 		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
-- 
1.7.1

