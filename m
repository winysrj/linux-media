Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <meysam.hariri@gmail.com>) id 1K8iBK-00054Q-5c
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 22:53:37 +0200
Received: by yw-out-2324.google.com with SMTP id 3so3138738ywj.41
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 13:53:23 -0700 (PDT)
Message-ID: <1a18e9e80806171353x49b36059h17dcfb40f6bfe7b0@mail.gmail.com>
Date: Wed, 18 Jun 2008 01:23:21 +0430
From: "Meysam Hariri" <meysam.hariri@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] TT 3200 locking on 8PSK channels fail
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0540693837=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0540693837==
Content-Type: multipart/alternative;
	boundary="----=_Part_4684_21830629.1213736002533"

------=_Part_4684_21830629.1213736002533
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

After successfull compilation of multiproto drivers and dvb-utils with
patched szap on linux kernel 2.6.25.7, locking works great on dvb-s2
channels with QPSK modulation but no chance on 8PSK. the patched szap and
the unpached version also lock on dvb-s channels but i need to run szap
multiple times until i get lock.on an 8PSK channel with FEC 9/10 locking
fails totally and i could never get lock. any suggestions?

Regards,

------=_Part_4684_21830629.1213736002533
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

After successfull compilation of multiproto drivers and dvb-utils with patched szap on linux kernel <a href="http://2.6.25.7">2.6.25.7</a>, locking works great on dvb-s2 channels with QPSK modulation but no chance on 8PSK. the patched szap and the unpached version also lock on dvb-s channels but i need to run szap multiple times until i get lock.on an 8PSK channel with FEC 9/10 locking fails totally and i could never get lock. any suggestions?<br>
<br>Regards,<br><br>

------=_Part_4684_21830629.1213736002533--


--===============0540693837==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0540693837==--
