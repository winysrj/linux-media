Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpauth01.csee.siteprotect.eu ([83.246.86.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1Kabla-0006Ri-Os
	for linux-dvb@linuxtv.org; Tue, 02 Sep 2008 21:42:19 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	(Authenticated sender: roger@beardandsandals.co.uk)
	by smtpauth01.csee.siteprotect.eu (Postfix) with ESMTP id CCDA86C007
	for <linux-dvb@linuxtv.org>; Tue,  2 Sep 2008 21:41:44 +0200 (CEST)
Message-ID: <48BD96F9.2010901@beardandsandals.co.uk>
Date: Tue, 02 Sep 2008 20:41:45 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48BD78B0.6070508@beardandsandals.co.uk>
	<48BD85FC.6030800@kipdola.com>
In-Reply-To: <48BD85FC.6030800@kipdola.com>
Subject: Re: [linux-dvb] Help - trying to get multiproto TT03200 driver
 working via old API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0218394880=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0218394880==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Thanks,<br>
<br>
Looking at the patch diff is does not appear too complex. I will try
and see if I can work out a minimal patch against the current tree. If
not I will fall back on your suggestion. I think it would be desireable
if what makes it into the kernel supports new cards been driven in the
old way. <br>
<br>
Roger<br>
<br>
Jelle De Loecker wrote:
<blockquote cite="mid:48BD85FC.6030800@kipdola.com" type="cite">
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
I feel your pain, patch-hell isn't a fun place to be :)<br>
  <br>
Lots of people make guides on how to fix something, unfortunately they
forget that trees grow, and a patch that works today probably won't
work tomorrow.<br>
Thankfully you can check out different revisions!<br>
  <br>
I'd sugest you try this patch out on manu's original multiproto tree,
revision number 7213 (that was the last update, in april, before she
made her patch)<br>
  <br>
hg clone -r 7213 <a moz-do-not-send="true"
 class="moz-txt-link-freetext" href="http://jusst.de/hg/multiproto">http://jusst.de/hg/multiproto</a><br>
  <div class="moz-signature"><br>
  <em>Met vriendelijke groeten,</em>
  <br>
  <br>
  <strong>Jelle De Loecker</strong>
  <br>
Kipdola Studios - Tomberg <br>
  </div>
  <br>
  <br>
Roger James schreef:
  <blockquote cite="mid:48BD78B0.6070508@beardandsandals.co.uk"
 type="cite">I am have been trying to get gnutv to drive the TT-3200
driver using
the old api (gnutv uses dvb-apps/lib which is not patched for multi
proto). After much head scratching I realised that the fialure of the
driver to get lock when exercised in this way seemed to be related to
DVBFE_ALGO_SEARCH_AGAIN not being set when the FE_SET_FRONTEND ioctl
path was followed rather than than the DVBFE_SET_PARAMS path. A search
of the list revealed that Anssi Hannula had already worked this out and
made a patch (<a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://www.spinics.net/lists/linux-dvb/msg26174.html">http://www.spinics.net/lists/linux-dvb/msg26174.html</a>).
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
    <pre wrap=""><hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a moz-do-not-send="true" class="moz-txt-link-abbreviated"
 href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
  </blockquote>
</blockquote>
<br>
</body>
</html>


--===============0218394880==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0218394880==--
