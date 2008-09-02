Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpauth02.csee.siteprotect.eu ([83.246.86.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1KaZkZ-00076S-2k
	for linux-dvb@linuxtv.org; Tue, 02 Sep 2008 19:33:08 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	(Authenticated sender: roger@beardandsandals.co.uk)
	by smtpauth02.csee.siteprotect.eu (Postfix) with ESMTP id 12B80C68005
	for <linux-dvb@linuxtv.org>; Tue,  2 Sep 2008 19:32:31 +0200 (CEST)
Message-ID: <48BD78B0.6070508@beardandsandals.co.uk>
Date: Tue, 02 Sep 2008 18:32:32 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Help - trying to get multiproto TT03200 driver working
	via old API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1327956799=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1327956799==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
I am have been trying to get gnutv to drive the TT-3200 driver using
the old api (gnutv uses dvb-apps/lib which is not patched for multi
proto). After much head scratching I realised that the fialure of the
driver to get lock when exercised in this way seemed to be related to
DVBFE_ALGO_SEARCH_AGAIN not being set when the FE_SET_FRONTEND ioctl
path was followed rather than than the DVBFE_SET_PARAMS path. A search
of the list revealed that Anssi Hannula had already worked this out and
made a patch (<a class="moz-txt-link-freetext" href="http://www.spinics.net/lists/linux-dvb/msg26174.html">http://www.spinics.net/lists/linux-dvb/msg26174.html</a>).
However it does not look like this patch has made it into the code that
Manu has asked to be merged into the kernel. Does this mean that the
merged code will not be compatible with applications such as gnutv
which use dvb-apps/lib or other apps which use the old api?<br>
<br>
To help me carry on with my testing. Is there as version of Anssi's
patch that can be applied against a recent clone of Manu's code.<br>
<br>
I apologise if this has been visited before; but I am finding it
virtually impossible to unravel the complexities of what patch matches
what tree.<br>
<br>
Help<br>
<br>
Roger<br>
</body>
</html>


--===============1327956799==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1327956799==--
