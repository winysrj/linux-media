Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811Ab1CaBw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 21:52:28 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2V1qSWs030245
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Mar 2011 21:52:28 -0400
Received: from [10.3.230.187] (vpn-230-187.phx2.redhat.com [10.3.230.187])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p2V1qRVU015919
	for <linux-media@vger.kernel.org>; Wed, 30 Mar 2011 21:52:28 -0400
Message-ID: <4D93DE5A.8050300@redhat.com>
Date: Wed, 30 Mar 2011 22:52:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH dvb-apps] Add initial transponder for Net Digital
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Adds the initial transponder used on Net Digital on Sao Paulo
state (specifically at Sao Jose dos Campos).

The other transponders are automatically obtained, so, there's
no need to add them all.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/util/scan/dvb-c/br-Net-Digital b/util/scan/dvb-c/br-Net-Digital
new file mode 100644
--- /dev/null
+++ b/util/scan/dvb-c/br-Net-Digital
@@ -0,0 +1,6 @@
+# Net Digital
+# Just the initial transponder is enough
+
+# freq sr fec mod
+# Found on Sao Jose dos Campos, SP
+C 573000000 5217000 NONE QAM256

