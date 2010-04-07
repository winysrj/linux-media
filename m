Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.t5.fi ([82.203.195.5]:34193 "HELO mail.t5.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932430Ab0DGQJG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 12:09:06 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.t5.fi (Postfix) with ESMTP id 8B3661CC04A
	for <linux-media@vger.kernel.org>; Wed,  7 Apr 2010 18:59:00 +0300 (EEST)
Received: from mail.t5.fi ([127.0.0.1])
	by localhost (mail.t5.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ErOsr9769swh for <linux-media@vger.kernel.org>;
	Wed,  7 Apr 2010 18:58:49 +0300 (EEST)
Received: from [192.168.1.110] (dsl-tkubrasgw3-ffa5c300-17.dhcp.inet.fi [88.195.165.17])
	by mail.t5.fi (Postfix) with ESMTPSA id E27D71CC049
	for <linux-media@vger.kernel.org>; Wed,  7 Apr 2010 18:58:49 +0300 (EEST)
Message-ID: <4BBCABB9.6080401@vesti.fi>
Date: Wed, 07 Apr 2010 18:58:49 +0300
From: Miika Vesti <miika@vesti.fi>
MIME-Version: 1.0
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH] Updated scan file for dvb-c/fi-Turku (dvb-apps)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

Here is an updated scan file for dvb-c/fi-Turku.

Source information for scan file:
http://www.turunkaapelitv.fi/p9-taajuudet.html [html]
http://www.turunkaapelitv.fi/files/Kanavalista-(3).pdf [pdf]

Both documents are in Finnish but it should be easy to pick the relevant 
information and compare those values to the patch below.

Signed-off-by: Miika Vesti <miika@vesti.fi>

diff -r 7de0663facd9 util/scan/dvb-c/fi-Turku
--- a/util/scan/dvb-c/fi-Turku	Sun Feb 14 16:21:19 2010 +0400
+++ b/util/scan/dvb-c/fi-Turku	Wed Apr 07 18:30:30 2010 +0300
@@ -3,6 +3,13 @@
  C 146000000 6900000 NONE QAM128
  C 154000000 6900000 NONE QAM128
  C 162000000 6900000 NONE QAM128
+C 234000000 6900000 NONE QAM256
+C 242000000 6900000 NONE QAM256
+C 250000000 6900000 NONE QAM256
+C 258000000 6900000 NONE QAM256
+C 266000000 6900000 NONE QAM256
+C 290000000 6900000 NONE QAM128
+C 298000000 6900000 NONE QAM128
  C 322000000 6900000 NONE QAM128
  C 330000000 6900000 NONE QAM128
  C 338000000 6900000 NONE QAM128
@@ -14,4 +21,3 @@
  C 418000000 6900000 NONE QAM128
  C 426000000 6900000 NONE QAM128
  C 442000000 6900000 NONE QAM128
-C 354000000 6900000 NONE QAM256
