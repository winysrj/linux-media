Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cinke.fazekas.hu ([195.199.244.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cus@fazekas.hu>) id 1JcoMI-000196-TG
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 22:01:03 +0100
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id E74F133CC4
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 22:00:57 +0100 (CET)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5gID-+JDPCe for <linux-dvb@linuxtv.org>;
	Fri, 21 Mar 2008 22:00:52 +0100 (CET)
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by cinke.fazekas.hu (Postfix) with ESMTP id 765D433CC3
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 22:00:52 +0100 (CET)
Date: Fri, 21 Mar 2008 22:00:51 +0100 (CET)
From: Marton Balint <cus@fazekas.hu>
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.64.0803212029070.9788@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-943463948-1617262934-1206133251=:24121"
Subject: [linux-dvb] [PATCH] cx88: fix stereo dematrix for A2 sound system
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

---943463948-1617262934-1206133251=:24121
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi, 

Using A2 sound system, in stereo mode, the first sound channel is L+R, the 
second channel is 2*R. So the dematrix control should be SUMR instead of 
SUMDIFF. Let's use SUMR for stereo mode, and use SUMDIFF for everything 
else. (SUMDIFF is required for mono mode, because without it the right 
channel would be silent).


Signed-off-by: Marton Balint <cus@fazekas.hu>
---943463948-1617262934-1206133251=:24121
Content-Type: TEXT/x-patch; charset=US-ASCII; name=cx88-fix-stereo-dematrix.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0803212200510.24121@cinke.fazekas.hu>
Content-Description: 
Content-Disposition: attachment; filename=cx88-fix-stereo-dematrix.patch

LS0tIGRyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LXR2YXVkaW8uYy5z
dGVyZW8JMjAwOC0wMy0xNyAyMTozMToxMS4wMDAwMDAwMDAgKzAxMDANCisr
KyBkcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC10dmF1ZGlvLmMJMjAw
OC0wMy0yMSAyMTozMTo1NS4wMDAwMDAwMDAgKzAxMDANCkBAIC02MjYsNyAr
NjI2LDEyIEBAIHN0YXRpYyB2b2lkIHNldF9hdWRpb19zdGFuZGFyZF9BMihz
dHJ1Y3QNCiAJCWJyZWFrOw0KIAl9Ow0KIA0KLQltb2RlIHw9IEVOX0ZNUkFE
SU9fRU5fUkRTIHwgRU5fRE1UUlhfU1VNRElGRjsNCisJbW9kZSB8PSBFTl9G
TVJBRElPX0VOX1JEUzsNCisJaWYgKChtb2RlICYgMHgzZikgPT0gRU5fQTJf
Rk9SQ0VfU1RFUkVPKQ0KKwkJbW9kZSB8PSBFTl9ETVRSWF9TVU1SOw0KKwll
bHNlDQorCQltb2RlIHw9IEVOX0RNVFJYX1NVTURJRkY7DQorDQogCXNldF9h
dWRpb19maW5pc2goY29yZSwgbW9kZSk7DQogfQ0KIA0K

---943463948-1617262934-1206133251=:24121
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---943463948-1617262934-1206133251=:24121--
