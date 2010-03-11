Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab0CKN1F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 08:27:05 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2BDR49q007902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 08:27:05 -0500
Received: from pedra (vpn-234-51.phx2.redhat.com [10.3.234.51])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2BDQqf2015794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 08:27:03 -0500
Date: Thu, 11 Mar 2010 10:26:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 7/7] V4L/DVB: tm6000: replace occurences of req05 magic by a
 naming alias
Message-ID: <20100311102645.1f8eae28@pedra>
In-Reply-To: <cover.1268311636.git.mchehab@redhat.com>
References: <cover.1268311636.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yet another naming replace magic thanks to perl scripts. This time, it
is done with:

cat tm6000-regs.h |perl -ne 'if (m/(TM6010_REQ[^\s]+)\s+0x([a-f0-9]+)\,
0x([a-f0-9]+)/) { $name="$1"; $req=$2; $val=$3; printf
"s/REQ_${req}_SET_GET_USBREG, 0x[0]*$3,/$1,/\n" }'  >a; for i in tm*.c;
do sed -f a $i >b && mv b $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index d501df2..1b588f8 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -341,7 +341,7 @@ struct reg_init tm6000_init_tab[] = {
 	{ TM6010_REQ07_RC1_TRESHOLD, 0xd0 },
 	{ TM6010_REQ07_RC3_HSTART1, 0x88 },
 	{ TM6010_REQ07_R3F_RESET, 0x00 },		/* End of the soft reset */
-	{ REQ_05_SET_GET_USBREG, 0x18, 0x00 },
+	{ TM6010_REQ05_R18_IMASK7, 0x00 },
 };
 
 struct reg_init tm6010_init_tab[] = {
@@ -414,7 +414,7 @@ struct reg_init tm6010_init_tab[] = {
 	{ TM6010_REQ07_RC3_HSTART1, 0x88 },
 	{ TM6010_REQ07_R3F_RESET, 0x00 },
 
-	{ REQ_05_SET_GET_USBREG, 0x18, 0x00 },
+	{ TM6010_REQ05_R18_IMASK7, 0x00 },
 
 	{ TM6010_REQ07_RD8_IR_LEADER1, 0xaa },
 	{ TM6010_REQ07_RD8_IR_LEADER0, 0x30 },
-- 
1.6.6.1

