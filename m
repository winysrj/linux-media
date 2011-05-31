Return-path: <mchehab@pedra>
Received: from cinke.fazekas.hu ([195.199.244.225]:33492 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab1EaMZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 08:25:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 63356DC003
	for <linux-media@vger.kernel.org>; Tue, 31 May 2011 14:25:32 +0200 (CEST)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LSTWj2ooekK9 for <linux-media@vger.kernel.org>;
	Tue, 31 May 2011 14:25:32 +0200 (CEST)
Received: from [192.168.1.100] (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 4C2FEDC001
	for <linux-media@vger.kernel.org>; Tue, 31 May 2011 14:25:32 +0200 (CEST)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] update dvb-c scanfile hu-Digikabel
Message-Id: <15083eb9eb32e906d296.1306844713@roadrunner>
Date: Tue, 31 May 2011 14:25:13 +0200
From: Marton Balint <cus@fazekas.hu>
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1306844422 -7200
# Node ID 15083eb9eb32e906d2961597965320d328b3782e
# Parent  7ebf32ed9124c7e58049dc9f59b514a222757b7d
update dvb-c scanfile hu-Digikabel

diff -r 7ebf32ed9124 -r 15083eb9eb32 util/scan/dvb-c/hu-Digikabel
--- a/util/scan/dvb-c/hu-Digikabel	Tue May 17 08:50:08 2011 +0200
+++ b/util/scan/dvb-c/hu-Digikabel	Tue May 31 14:20:22 2011 +0200
@@ -6,6 +6,7 @@
 #  Szazhalombatta, Bekescsaba, Bekes, Eger, Komlo, Oroszlany
 # In some of the cities not all the frequencies are available.
 # freq sr fec mod
+C 121000000 6900000 NONE QAM256
 C 354000000 6900000 NONE QAM256
 C 362000000 6900000 NONE QAM256
 C 370000000 6900000 NONE QAM256
@@ -14,8 +15,11 @@
 C 394000000 6900000 NONE QAM256
 C 402000000 6900000 NONE QAM256
 C 410000000 6900000 NONE QAM256
+C 746000000 6900000 NONE QAM256
+C 754000000 6900000 NONE QAM256
 C 762000000 6900000 NONE QAM256
 C 770000000 6900000 NONE QAM256
 C 778000000 6900000 NONE QAM256
 C 786000000 6900000 NONE QAM256
 C 794000000 6900000 NONE QAM256
+C 850000000 6900000 NONE QAM256
