Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cinke.fazekas.hu ([195.199.244.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cus@fazekas.hu>) id 1JbQBO-0003ZJ-84
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 02:00:04 +0100
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 797D833CC5
	for <linux-dvb@linuxtv.org>; Tue, 18 Mar 2008 01:59:58 +0100 (CET)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dvjvpW6z1h0t for <linux-dvb@linuxtv.org>;
	Tue, 18 Mar 2008 01:59:50 +0100 (CET)
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by cinke.fazekas.hu (Postfix) with ESMTP id 572AF33CC3
	for <linux-dvb@linuxtv.org>; Tue, 18 Mar 2008 01:59:50 +0100 (CET)
Date: Tue, 18 Mar 2008 01:59:49 +0100 (CET)
From: Marton Balint <cus@fazekas.hu>
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.64.0803180139310.29447@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-943463948-535334313-1205781908=:26436"
Content-ID: <Pine.LNX.4.64.0803180139311.29447@cinke.fazekas.hu>
Subject: [linux-dvb] [PATCH] cx88: fix oops on module removal caused by IR
	worker
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-535334313-1205781908=:26436
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.64.0803180139312.29447@cinke.fazekas.hu>

Hi, 

If the IR worker is not stopped before the removal of the cx88xx module, 
an OOPS may occur, because the worker function cx88_ir_work gets called. 
So stop the ir worker.


Signed-off-by: Marton Balint <cus@fazekas.hu>
---943463948-535334313-1205781908=:26436
Content-Type: TEXT/X-PATCH; CHARSET=US-ASCII; NAME=cx88-fix-rmmod-oops.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0803180140220.29447@cinke.fazekas.hu>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=cx88-fix-rmmod-oops.patch

LS0tIGRyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LXZpZGVvLmMub2xk
CTIwMDgtMDMtMTggMDE6MjU6MDQuMDAwMDAwMDAwICswMTAwDQorKysgZHJp
dmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODgtdmlkZW8uYwkyMDA4LTAzLTE4
IDAxOjI2OjI1LjAwMDAwMDAwMCArMDEwMA0KQEAgLTE4OTEsNiArMTg5MSw5
IEBAIHN0YXRpYyB2b2lkIF9fZGV2ZXhpdCBjeDg4MDBfZmluaWRldihzdHIN
CiAJCWNvcmUtPmt0aHJlYWQgPSBOVUxMOw0KIAl9DQogDQorCWlmIChjb3Jl
LT5pcikNCisJCWN4ODhfaXJfc3RvcChjb3JlLCBjb3JlLT5pcik7DQorDQog
CWN4ODhfc2h1dGRvd24oY29yZSk7IC8qIEZJWE1FICovDQogCXBjaV9kaXNh
YmxlX2RldmljZShwY2lfZGV2KTsNCiANCg==

---943463948-535334313-1205781908=:26436
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---943463948-535334313-1205781908=:26436--
