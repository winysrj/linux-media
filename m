Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8T7r1pm009194
	for <video4linux-list@redhat.com>; Tue, 29 Sep 2009 03:53:01 -0400
Received: from web95202.mail.in2.yahoo.com (web95202.mail.in2.yahoo.com
	[203.104.18.178])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n8T7qnte004390
	for <video4linux-list@redhat.com>; Tue, 29 Sep 2009 03:52:50 -0400
Message-ID: <375375.79494.qm@web95202.mail.in2.yahoo.com>
Date: Tue, 29 Sep 2009 00:52:47 -0700 (PDT)
From: Rahul Pandey <rrp702@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Unable to capture sound for Hauppauge wintv pci fm card
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

hi, i recently installed hauppauge wintv pci fm card and i am able to captu=
re video using it. Howver i am not unable to capture audio.=0AI am bit new =
to linux.=0Ai have pasted the output for dmesg and lspci=0A=0A=0Admesg:=0A[=
   13.253951] cx88[0]: subsystem: 0070:3401, board: Hauppauge WinTV 34xxx m=
odels [card=3D1,autodetected], frontend(s): 0=0A[   13.595036] tveeprom 1-0=
050: Hauppauge model 34519, rev J189, serial# 10687500=0A[   13.622219] inp=
ut: cx88 IR (Hauppauge WinTV 34xxx  as /devices/pci0000:00/0000:00:09.0/inp=
ut/input5=0A=0A=0A=0Alspci -n :=0A00:00.0 0600: 1106:3205=0A00:01.0 0604: 1=
106:b198=0A00:08.0 0200: 8086:1229 (rev 05)=0A00:09.0 0400: 14f1:8800 (rev =
05)=0A00:09.1 0480: 14f1:8811 (rev 05)=0A00:10.0 0c03: 1106:3038 (rev 80)=
=0A00:10.1 0c03: 1106:3038 (rev 80)=0A00:10.2 0c03: 1106:3038 (rev 80)=0A00=
:10.3 0c03: 1106:3104 (rev 82)=0A00:11.0 0601: 1106:3177=0A00:11.1 0101: 11=
06:0571 (rev 06)=0A00:11.5 0401: 1106:3059 (rev 50)=0A00:12.0 0200: 1106:30=
65 (rev 74)=0A01:00.0 0300: 1106:7205 (rev 01)=0A=0A=0A=0Amy card model num=
ber is 34519.=0A=0AAny help will be appreciated=0A=0A=0A=0A      Try the ne=
w Yahoo! India Homepage. Click here. http://in.yahoo.com/trynew
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
