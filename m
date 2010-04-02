Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <debotux@gmail.com>) id 1Nxjf2-0005qy-3l
	for linux-dvb@linuxtv.org; Fri, 02 Apr 2010 18:24:00 +0200
Received: from mail-bw0-f220.google.com ([209.85.218.220])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Nxjf1-0002K6-7a; Fri, 02 Apr 2010 18:23:55 +0200
Received: by bwz20 with SMTP id 20so1596298bwz.12
	for <linux-dvb@linuxtv.org>; Fri, 02 Apr 2010 09:23:54 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 2 Apr 2010 18:23:53 +0200
Message-ID: <j2if20a597a1004020923oadaaac4co9ec6b4094490e88a@mail.gmail.com>
From: Jeremy Guitton <debotux@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Debian Bug#564204: dvb-apps: fr-Nantes should have an
	added offset of 167000 for each value
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0358208769=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0358208769==
Content-Type: multipart/alternative; boundary=0015173ff4ecc08d470483436798

--0015173ff4ecc08d470483436798
Content-Type: text/plain; charset=ISO-8859-1

Package: dvb-apps
Version: 1.1.1+rev1207-4
Severity: important


Like #478020 for fr-Paris, fr-Nantes should have an added offset of
167000 for each value. The file should look like that to be able to use
"scan" on it:

# Nantes - France
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 498167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 506167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 522167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 530167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 658167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 802167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

-- System Information:
Debian Release: 5.0.3
 APT prefers stable
 APT policy: (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 2.6.26-2-amd64 (SMP w/8 CPU cores)
Locale: LANG=fr_FR.UTF-8, LC_CTYPE=fr_FR.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages dvb-apps depends on:
ii  libc6                     2.7-18         GNU C Library: Shared libraries
ii  makedev                   2.3.1-88       creates device files in /dev
ii  udev                      0.125-7+lenny3 /dev/ and hotplug management
daemo

dvb-apps recommends no packages.

dvb-apps suggests no packages.

-- no debconf information

--0015173ff4ecc08d470483436798
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><span dir=3D"ltr"></span>Package: dvb-apps<br>
Version: 1.1.1+rev1207-4<br>
Severity: important<br>
<br>
<br>
Like #478020 for fr-Paris, fr-Nantes should have an added offset of<br>
167000 for each value. The file should look like that to be able to use<br>
&quot;scan&quot; on it:<br>
<br>
# Nantes - France<br>
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy<br=
>
T 498167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE<br>
T 506167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE<br>
T 522167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE<br>
T 530167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE<br>
T 658167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE<br>
T 802167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE<br>
<br>
-- System Information:<br>
Debian Release: 5.0.3<br>
 =A0APT prefers stable<br>
 =A0APT policy: (500, &#39;stable&#39;)<br>
Architecture: amd64 (x86_64)<br>
<br>
Kernel: Linux 2.6.26-2-amd64 (SMP w/8 CPU cores)<br>
Locale: LANG=3Dfr_FR.UTF-8, LC_CTYPE=3Dfr_FR.UTF-8 (charmap=3DUTF-8)<br>
Shell: /bin/sh linked to /bin/bash<br>
<br>
Versions of packages dvb-apps depends on:<br>
ii =A0libc6 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2.7-18 =A0 =A0 =A0 =A0 =
GNU C Library: Shared libraries<br>
ii =A0makedev =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2.3.1-88 =A0 =A0 =A0 crea=
tes device files in /dev<br>
ii =A0udev =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00.125-7+lenny3 /dev/ =
and hotplug management daemo<br>
<br>
dvb-apps recommends no packages.<br>
<br>
dvb-apps suggests no packages.<br>
<br>
-- no debconf information<br>
<br>
<br>
</div><br>

--0015173ff4ecc08d470483436798--


--===============0358208769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0358208769==--
