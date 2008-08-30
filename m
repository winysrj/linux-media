Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpauth02.csee.siteprotect.eu ([83.246.86.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1KZQ2J-0006MC-93
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 14:58:39 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	(Authenticated sender: roger@beardandsandals.co.uk)
	by smtpauth02.csee.siteprotect.eu (Postfix) with ESMTP id F0F01C68005
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 14:58:04 +0200 (CEST)
Message-ID: <48B943DF.1080702@beardandsandals.co.uk>
Date: Sat, 30 Aug 2008 13:58:07 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080825122741.GB17421@optima.lan>	<48B2E1DC.2080605@beardandsandals.co.uk>	<6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com>	<48B525F4.50004@beardandsandals.co.uk>	<48B5A157.1080206@beardandsandals.co.uk>	<6f94e1a00808271238q1d42e219t9d2b6c493d056b0c@mail.gmail.com>	<48B5E1C6.9040908@beardandsandals.co.uk>
	<48B69A3E.4020808@beardandsandals.co.uk>
In-Reply-To: <48B69A3E.4020808@beardandsandals.co.uk>
Subject: Re: [linux-dvb] TT S2-3200 + CI Extension
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0522575850=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0522575850==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Roger James wrote:
<blockquote cite="mid:48B69A3E.4020808@beardandsandals.co.uk"
 type="cite">
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
Roger James wrote:
  <blockquote cite="mid:48B5E1C6.9040908@beardandsandals.co.uk"
 type="cite">
    <meta content="text/html;charset=ISO-8859-1"
 http-equiv="Content-Type">
    <title></title>
Werner Hauger wrote:
    <blockquote
 cite="mid:6f94e1a00808271238q1d42e219t9d2b6c493d056b0c@mail.gmail.com"
 type="cite">
      <pre wrap="">So what revision of the CI board do you have ?

  </pre>
      <pre wrap="">I'm glad you got it working. I wonder if that means there we indeed
have different CI firmware on new CI boards that need to be catered
for in the driver.

  </pre>
      <blockquote type="cite">
        <pre wrap="">budget_ci: Slot status d587c000 set to NONE 3 ci_version a0
    </pre>
      </blockquote>
    </blockquote>
Werner,<br>
    <br>
The version number printed on the CI board is 1.0A. The firmware
version reported by the board is 0xa0 (it is at the end of the above
diagnostic.<br>
    <br>
I think it might be an idea to patch the driver to log the version by
default so we can build a picture of which firmware/board/CAM
combinations generate interrupts. I am bit suspicious of the fact that
my 1.0 rev of the CI board is not generating interrupts in this case,
whereas you said in an earlier posting that you had a 1.0 rev of the
board that was generating interrupts with a Nova S card (were you using
a TT CI board with a Hauppauge card, I am little confused). I should be
getting an AstonCrypt CAM in the next few days. I want to test that and
see if that does generate interrupts with my 1.0A CI board before I
would suggest adding firmware version 0xa0 to the list of the ones that
do not generate interrupts.<br>
    <br>
Roger<br>
  </blockquote>
Werner,<br>
  <br>
I spoke slightly too soon. I tested using gnutv -cammenu and got a
"CAWrite failed" message. I managed to fix this by increasing the
timeout in dvb_ca_en50221_io_write to 10 seconds ( from 0.5 seconds). I
am not too hopeful of success when I try some real decrypting, but that
will have to wait for a while.<br>
  <br>
Roger<br>
</blockquote>
I have now got hold of an AstonCrypt 1.05 CAM and done a quick test
against it. Once again the CI board required polling to initialise
properly, so it looks like this is related to the firmware version and
not specific to a particular CAM. However I am still not entirely
convinced. This is because of two factors; firstly CAM insertion and
removal interrupts are generated, and secondly I still have not managed
to get sensible data out of the card when the CAM and a smartcard is
inserted, even on unencrypted channels. But this may be finger trouble
and lack of understanding of the dvb-apps utils.<br>
<br>
On the second factor. I have been testing using gnutv and szap. One
thing I notice is that I can get a FE lock reported using szap, I
cannot get one using gnutv. Any ideas anyone?<br>
<br>
Roger<br>
</body>
</html>


--===============0522575850==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0522575850==--
