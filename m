Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mika.batsman@gmail.com>) id 1KNoM3-0000IW-En
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 14:31:05 +0200
Received: by nf-out-0910.google.com with SMTP id g13so3237746nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 29 Jul 2008 05:30:59 -0700 (PDT)
Message-ID: <488F0D80.7010607@gmail.com>
Date: Tue, 29 Jul 2008 15:30:56 +0300
From: =?ISO-8859-1?Q?Mika_B=E5tsman?= <mika.batsman@gmail.com>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
References: <3b52bc790807101342o12f6f879n9c68704cd6b96e22@mail.gmail.com>	<4879FA31.2080803@kolumbus.fi>	<4A2CCDB3-57B0-4121-A94D-59F985FCDE2B@oberste-berghaus.de>	<487BB17D.8080707@kolumbus.fi>	<D5C41D41-A72D-4603-9AD1-67A8C5E73289@oberste-berghaus.de>
	<488CAE63.9070204@kolumbus.fi>
In-Reply-To: <488CAE63.9070204@kolumbus.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy C DVB-C / Twinhan AD-CP400
 (VP-2040) &	mantis driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0247329045=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0247329045==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Hi,
<br>
I also tried your patch because I've had freezes since I got these
cards. Unfortunately it didn't help me. Got a whooping 5min uptime
before it all went wrong again. I have 2x Cinergy C + 2.6.24-19 + vdr
1.6.
<br>
<br>
I did:
<br>
hg clone <a class="moz-txt-link-freetext"
 href="http://jusst.de/hg/mantis">http://jusst.de/hg/mantis</a>
<br>
replaced mantis_dma.c with the one you attached, renamed
MANTIS_GPIF_RDWRN -&gt; MANTIS_GPIF_HIFRDWRN
<br>
make &amp;&amp; make install &amp;&amp; reboot
<br>
<br>
Am I missing something? It seemed to compile and install fine.
<br>
<br>
You said that the mantis_dma.c in jusst.de mantis head is not the
latest version. Where can it be found then?
<br>
<br>
Regards,
<br>
Mika B&aring;tsman
<br>
<br>
Marko Ristola wrote:
<blockquote cite="mid:488CAE63.9070204@kolumbus.fi" type="cite"><br>
Hi,
  <br>
  <br>
Unfortunately I have been busy.
  <br>
  <br>
The patch you tried was against jusst.de Mantis Mercurial branch head.
  <br>
Your version of mantis_dma.c is not the latest version and thus the
patch didn't
  <br>
apply cleanly.
  <br>
  <br>
Here is the version that I use currently. It doesn't compile straight
against jusst.de/mantis head.
  <br>
It might work for you because MANTIS_GPIF_RDWRN is not renamed as
MANTIS_GPIF_HIFRDWRN.
  <br>
  <br>
If it doesn't compile please rename MANTIS_GPIF_RDWRN occurrences into
MANTIS_GPIF_HIFRDWRN on that file.
  <br>
Otherwise the file should work as it is.
  <br>
  <br>
Best regards,
  <br>
Marko Ristola
  <br>
  <br>
Leif Oberste-Berghaus kirjoitti:
  <br>
  <blockquote type="cite">Hi Marko,
    <br>
    <br>
I tried to patch the driver but I'm getting an error message:
    <br>
    <br>
root@mediapc:/usr/local/src/test/mantis-0b04be0c088a# patch -p1 &lt;
mantis_dma.c.aligned_dma_trs.patch
    <br>
patching file linux/drivers/media/dvb/mantis/mantis_dma.c
    <br>
patch: **** malformed patch at line 22: int mantis_dma_exit(struct
mantis_pci *mantis)
    <br>
    <br>
Any ideas?
    <br>
    <br>
Regards
    <br>
Leif
    <br>
    <br>
    <br>
Am 14.07.2008 um 22:05 schrieb Marko Ristola:
    <br>
    <br>
    <blockquote type="cite">Hi Leif,
      <br>
      <br>
Here is a patch that implements the mentioned DMA transfer
improvements.
      <br>
I hope that these contain also the needed fix for you.
      <br>
You can apply it into jusst.de/mantis Mercurial branch.
      <br>
It modifies linux/drivers/media/dvb/mantis/mantis_dma.c only.
      <br>
I have compiled the patch against 2.6.25.9-76.fc9.x86_64.
      <br>
      <br>
cd mantis
      <br>
patch -p1 &lt; mantis_dma.c.aligned_dma_trs.patch
      <br>
      <br>
Please tell us whether my patch helps you or not: if it helps, some of
my patch might get into jusst.de as
      <br>
a fix for your problem.
      <br>
      <br>
Best Regards,
      <br>
Marko
      <br>
    </blockquote>
    <br>
    <br>
  </blockquote>
  <br>
  <pre wrap=""><pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre></pre>
</blockquote>
<br>
</body>
</html>


--===============0247329045==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0247329045==--
