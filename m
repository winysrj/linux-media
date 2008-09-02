Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway03.websitewelcome.com ([69.93.31.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1Kaad2-0002PA-FQ
	for linux-dvb@linuxtv.org; Tue, 02 Sep 2008 20:29:26 +0200
Message-ID: <48BD85FC.6030800@kipdola.com>
Date: Tue, 02 Sep 2008 20:29:16 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: Roger James <roger@beardandsandals.co.uk>,
	linux-dvb <linux-dvb@linuxtv.org>
References: <48BD78B0.6070508@beardandsandals.co.uk>
In-Reply-To: <48BD78B0.6070508@beardandsandals.co.uk>
Subject: Re: [linux-dvb] Help - trying to get multiproto TT03200 driver
 working via old API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1599186967=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1599186967==
Content-Type: multipart/alternative;
 boundary="------------040906090608040302020106"

This is a multi-part message in MIME format.
--------------040906090608040302020106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I feel your pain, patch-hell isn't a fun place to be :)

Lots of people make guides on how to fix something, unfortunately they 
forget that trees grow, and a patch that works today probably won't work 
tomorrow.
Thankfully you can check out different revisions!

I'd sugest you try this patch out on manu's original multiproto tree, 
revision number 7213 (that was the last update, in april, before she 
made her patch)

hg clone -r 7213 http://jusst.de/hg/multiproto

/Met vriendelijke groeten,/

*Jelle De Loecker*
Kipdola Studios - Tomberg


Roger James schreef:
> I am have been trying to get gnutv to drive the TT-3200 driver using 
> the old api (gnutv uses dvb-apps/lib which is not patched for multi 
> proto). After much head scratching I realised that the fialure of the 
> driver to get lock when exercised in this way seemed to be related to 
> DVBFE_ALGO_SEARCH_AGAIN not being set when the FE_SET_FRONTEND ioctl 
> path was followed rather than than the DVBFE_SET_PARAMS path. A search 
> of the list revealed that Anssi Hannula had already worked this out 
> and made a patch 
> (http://www.spinics.net/lists/linux-dvb/msg26174.html). However it 
> does not look like this patch has made it into the code that Manu has 
> asked to be merged into the kernel. Does this mean that the merged 
> code will not be compatible with applications such as gnutv which use 
> dvb-apps/lib or other apps which use the old api?
>
> To help me carry on with my testing. Is there as version of Anssi's 
> patch that can be applied against a recent clone of Manu's code.
>
> I apologise if this has been visited before; but I am finding it 
> virtually impossible to unravel the complexities of what patch matches 
> what tree.
>
> Help
>
> Roger
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

--------------040906090608040302020106
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
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
hg clone -r 7213 <a class="moz-txt-link-freetext" href="http://jusst.de/hg/multiproto">http://jusst.de/hg/multiproto</a><br>
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
  <pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
</blockquote>
</body>
</html>

--------------040906090608040302020106--


--===============1599186967==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1599186967==--
