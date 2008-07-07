Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bolanster@gmail.com>) id 1KFvB9-0007ER-Mr
	for linux-dvb@linuxtv.org; Mon, 07 Jul 2008 20:11:12 +0200
Received: by qw-out-2122.google.com with SMTP id 9so13158qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 07 Jul 2008 11:11:06 -0700 (PDT)
Message-ID: <acd5e46b0807071111j7a16965em9c42c35b9c9a92e5@mail.gmail.com>
Date: Mon, 7 Jul 2008 14:11:06 -0400
From: "john bolan" <bolanster@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] cx24113 - SkyStar2 Rev2.8 - problems compiling on
	Ubuntu Hardy
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0770835785=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0770835785==
Content-Type: multipart/alternative;
	boundary="----=_Part_24786_22526268.1215454266593"

------=_Part_24786_22526268.1215454266593
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm getting the same error mentioned by Robert when trying to compile the
cx24113.0_shipped driver for my SkyStar Rev2.8. This is on Ubuntu 8.04
Hardy.

John bolan


Hi,

I tried to compile the cx24113.o_shipped driver for SkyStar2 Rev2.8 on
Debian but when I try to load module with modprobe cx24113 i get an
Undefinded Symbol in module error saying that the functions
kmem_cache_zalloc cannot be found.
Any ideea where I did wrong ?

Best regards,

Robert

------=_Part_24786_22526268.1215454266593
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>I&#39;m getting the same error mentioned by Robert&nbsp;when trying to compile the cx24113.0_shipped driver for my SkyStar Rev2.8. This is on Ubuntu 8.04 Hardy.</div>
<div>&nbsp;</div>
<div>John bolan</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>Hi,<br><br>I tried to compile the cx24113.o_shipped driver for SkyStar2 Rev2.8 on<br>Debian but when I try to load module with modprobe cx24113 i get an<br>Undefinded Symbol in module error saying that the functions<br>
kmem_cache_zalloc cannot be found.<br>Any ideea where I did wrong ?<br><br>Best regards,<br><br>Robert<br><br><br>&nbsp;</div>

------=_Part_24786_22526268.1215454266593--


--===============0770835785==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0770835785==--
