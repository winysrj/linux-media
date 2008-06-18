Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mikerussellnz@gmail.com>) id 1K8vKe-0005LX-Bq
	for linux-dvb@linuxtv.org; Wed, 18 Jun 2008 12:56:05 +0200
Received: by fk-out-0910.google.com with SMTP id f40so259026fka.1
	for <linux-dvb@linuxtv.org>; Wed, 18 Jun 2008 03:55:59 -0700 (PDT)
Message-ID: <c112e7e90806180355k329049deh965a9f128a46a833@mail.gmail.com>
Date: Wed, 18 Jun 2008 22:55:59 +1200
From: "Mike Russell" <mikerussellnz@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] HVR 3000 readreg / writereg problem,
	is there a patch for the issue triggered by HAL?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1030185037=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1030185037==
Content-Type: multipart/alternative;
	boundary="----=_Part_6633_7009339.1213786559440"

------=_Part_6633_7009339.1213786559440
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

I am getting the same readreg / writereg errors as described in the bug
report below on my HVR-3000 card.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/209971

There is a link to the change below that fixes the issue for the HVR-1300,
Is there an equivalent patch for the HVR-3000 which also seems to suffer the
same issue?

http://linuxtv.org/hg/~stoth/v4l-dvb/rev/e55d97ff8bba


Thanks and Regards

Mike.

------=_Part_6633_7009339.1213786559440
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi<br><br>I am getting the same readreg / writereg errors as described in the bug report below on my HVR-3000 card.<br><br><a href="https://bugs.launchpad.net/ubuntu/+source/linux/+bug/209971">https://bugs.launchpad.net/ubuntu/+source/linux/+bug/209971</a><br>
<br>There is a link to the change below that fixes the issue for the HVR-1300, Is there an equivalent patch for the HVR-3000 which also seems to suffer the same issue?<br><br><a href="http://linuxtv.org/hg/~stoth/v4l-dvb/rev/e55d97ff8bba">http://linuxtv.org/hg/~stoth/v4l-dvb/rev/e55d97ff8bba</a><br>
<br><br>Thanks and Regards<br><br>Mike.<br><br>

------=_Part_6633_7009339.1213786559440--


--===============1030185037==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1030185037==--
