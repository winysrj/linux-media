Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gujs.lists@gmail.com>) id 1KQeis-00029T-Nv
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 10:50:23 +0200
Received: by yw-out-2324.google.com with SMTP id 3so1397977ywj.41
	for <linux-dvb@linuxtv.org>; Wed, 06 Aug 2008 01:50:17 -0700 (PDT)
Message-ID: <23be820f0808060150l6d5c21e5ped3c07dcf59bdc60@mail.gmail.com>
Date: Wed, 6 Aug 2008 10:50:17 +0200
From: "Gregor Fuis" <gujs.lists@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] KNC One DVB-S2 symbol rate problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0666087866=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0666087866==
Content-Type: multipart/alternative;
	boundary="----=_Part_12380_28150607.1218012617451"

------=_Part_12380_28150607.1218012617451
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I have Rohde & Schwarz SFU signal generator until 11.8.2008 at work so I run
some tests on my KNC DVB-S2 card to se if it also has problems with symbol
rates everybody complains.

I have got these results with frequency set to 12303000MHz and changing
symbol rate and FEC CODE RATE. I just measured upper setting of symbol rate
when problems started. When I tried lower sybmol rates from 1000000 and up I
did not get any problems. All this is measured in DVB-S2 standard.

Constellation QPSK - FEC 2/3
Symbol rate    Result
29600000    LOCK
29700000    NO LOCK

Constellation 8PSK - FEC 2/3
Symbol rate    Result
30000000    LOCK
30100000    NO LOCK


Constellation QPSK - FEC 3/4
Symbol rate    Result
22200000    LOCK
22300000    LOCK for 1 second - Then loses LOCK

Constellation 8PSK - FEC 3/4
Symbol rate    Result
30000000    LOCK
30100000    LOCK for 1 second - Then loses LOCK


Constellation QPSK - FEC 4/5
Symbol rate    Result
22200000    LOCK
22300000    LOCK for 1 second - Then loses LOCK


Constellation QPSK - FEC 5/6
Symbol rate    Result
22200000    LOCK
22300000    LOCK for 1 second - Then loses LOCK

Constellation 8PSK - FEC 5/6
Symbol rate    Result
30000000    LOCK
30100000    LOCK for 1 second - Then loses LOCK


Constellation QPSK - FEC 8/9
Symbol rate    Result
22200000    LOCK
22300000    LOCK for 1 second - Then loses LOCK

Constellation 8PSK - FEC 8/9
Symbol rate    Result
24000000    LOCK
24100000    Unstable LOCK, this means that it gets LOCK, then loses LOCK,
then this is repeating
--------all between Unstable LOCK
26500000    Unstable LOCK
26600000    NO LOCK


Constellation QPSK - FEC 9/10
Symbol rate    Result
22200000    LOCK
22300000    LOCK for 1 second - Then loses LOCK

Constellation 8PSK - FEC 9/10
Symbol rate    Result
20000000    LOCK
20100000    Unstable LOCK, this means that it gets LOCK, then loses LOCK,
then this is repeating
--------all between Unstable LOCK
24900000    Unstable LOCK
25000000    NO LOCK


If someone have some patches which could solve the problems I will gladly
test it for him, but as I said before I have this SFU generator just to
11.8.2008.

Best Regards,
Gregor Fuis

------=_Part_12380_28150607.1218012617451
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div>Hello,<br><br>I have Rohde &amp; Schwarz SFU signal generator until 11.8.2008 at work so I run some tests on my KNC DVB-S2 card to se if it also has problems with symbol rates everybody complains.<br><br>

I have got these results with frequency set to 12303000MHz and changing symbol rate and FEC CODE RATE. I just measured upper setting of symbol rate when problems started. When I tried lower sybmol rates from 1000000 and up I did not get any problems. All this is measured in DVB-S2 standard. <br>
<br></div>Constellation QPSK - FEC 2/3<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>29600000&nbsp;&nbsp;&nbsp; LOCK<br>29700000&nbsp;&nbsp;&nbsp; NO LOCK<br><br>Constellation 8PSK - FEC 2/3<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>30000000&nbsp;&nbsp;&nbsp; LOCK<br>30100000&nbsp;&nbsp;&nbsp; NO LOCK<br><br><br>
Constellation QPSK - FEC 3/4<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>22200000&nbsp;&nbsp;&nbsp; LOCK<br>22300000&nbsp;&nbsp;&nbsp; LOCK for 1 second - Then loses LOCK<br><br>Constellation 8PSK - FEC 3/4<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>30000000&nbsp;&nbsp;&nbsp; LOCK<br>30100000&nbsp;&nbsp;&nbsp; LOCK for 1 second - Then loses LOCK<br>
<br><br>Constellation QPSK - FEC 4/5<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>22200000&nbsp;&nbsp;&nbsp; LOCK<br>22300000&nbsp;&nbsp;&nbsp; LOCK for 1 second - Then loses LOCK<br><br><br>Constellation QPSK - FEC 5/6<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>22200000&nbsp;&nbsp;&nbsp; LOCK<br>
22300000&nbsp;&nbsp;&nbsp; LOCK for 1 second - Then loses LOCK<br><br>Constellation 8PSK - FEC 5/6<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>30000000&nbsp;&nbsp;&nbsp; LOCK<br>30100000&nbsp;&nbsp;&nbsp; LOCK for 1 second - Then loses LOCK<br><br><br>Constellation QPSK - FEC 8/9<br>
Symbol rate&nbsp;&nbsp;&nbsp; Result<br>22200000&nbsp;&nbsp;&nbsp; LOCK<br>22300000&nbsp;&nbsp;&nbsp; LOCK for 1 second - Then loses LOCK<br><br>Constellation 8PSK - FEC 8/9<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>24000000&nbsp;&nbsp;&nbsp; LOCK<br>24100000&nbsp;&nbsp;&nbsp; Unstable LOCK, this means that it gets LOCK, then loses LOCK, then this is repeating<br>
--------all between Unstable LOCK<br>26500000&nbsp;&nbsp;&nbsp; Unstable LOCK<br>26600000&nbsp;&nbsp;&nbsp; NO LOCK<br><br><br>Constellation QPSK - FEC 9/10<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>22200000&nbsp;&nbsp;&nbsp; LOCK<br>22300000&nbsp;&nbsp;&nbsp; LOCK for 1 second - Then loses LOCK<br>
<br>Constellation 8PSK - FEC 9/10<br>Symbol rate&nbsp;&nbsp;&nbsp; Result<br>20000000&nbsp;&nbsp;&nbsp; LOCK<br>20100000&nbsp;&nbsp;&nbsp; Unstable LOCK, this means that it gets LOCK, then loses LOCK, then this is repeating<br>--------all between Unstable LOCK<br>24900000&nbsp;&nbsp;&nbsp; Unstable LOCK<br>
25000000&nbsp;&nbsp;&nbsp; NO LOCK<br><br><br>If someone have some patches which could solve the problems I will gladly test it for him, but as I said before I have this SFU generator just to 11.8.2008.<br><br>Best Regards,<br>Gregor Fuis<br>
</div>

------=_Part_12380_28150607.1218012617451--


--===============0666087866==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0666087866==--
