Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab0IHNUm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 09:20:42 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o88DKfIf031775
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Sep 2010 09:20:41 -0400
Received: from [10.11.11.235] (vpn-11-235.rdu.redhat.com [10.11.11.235])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o88DKc2A031270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 8 Sep 2010 09:20:41 -0400
Message-ID: <4C878DAA.2030604@redhat.com>
Date: Wed, 08 Sep 2010 10:20:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L/DVB: cx88: Fix some gcc warnings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

drivers/media/video/cx88/cx88-dsp.c: In function ‘detect_a2_a2m_eiaj’:
drivers/media/video/cx88/cx88-dsp.c:158: warning: ‘carrier_freq’ may be used uninitialized in this function
drivers/media/video/cx88/cx88-dsp.c:158: warning: ‘stereo_freq’ may be used uninitialized in this function
drivers/media/video/cx88/cx88-dsp.c:158: warning: ‘dual_freq’ may be used uninitialized in this function

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-dsp.c b/drivers/media/video/cx88/cx88-dsp.c
index e1d6eef..2e6a92f 100644
--- a/drivers/media/video/cx88/cx88-dsp.c
+++ b/drivers/media/video/cx88/cx88-dsp.c
@@ -175,13 +175,7 @@ static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
 		stereo_freq = FREQ_EIAJ_STEREO;
 		dual_freq = FREQ_EIAJ_DUAL;
 		break;
-	case WW_NONE:
-	case WW_BTSC:
-	case WW_I:
-	case WW_L:
-	case WW_I2SPT:
-	case WW_FM:
-	case WW_I2SADC:
+	default:
 		printk(KERN_WARNING "%s/0: unsupported audio mode %d for %s\n",
 		       core->name, core->tvaudio, __func__);
 		return UNSET;
-- 
1.7.1


