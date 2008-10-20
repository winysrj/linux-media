Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oscarmax3@gmail.com>) id 1Ks1vy-0000nY-R2
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 23:05:03 +0200
Received: by nf-out-0910.google.com with SMTP id g13so857161nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 14:04:58 -0700 (PDT)
Message-ID: <48FCF277.2000600@gmail.com>
Date: Mon, 20 Oct 2008 23:04:55 +0200
From: Carl Oscar Ejwertz <oscarmax3@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <BAY109-W307DF75E4A987746AD9EE585300@phx.gbl>
	<Pine.GSO.4.64.0810191117040.16269@hatchepsut.acc.umu.se>
In-Reply-To: <Pine.GSO.4.64.0810191117040.16269@hatchepsut.acc.umu.se>
Subject: Re: [linux-dvb] Mantis 2033 dvb-tuning problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1384901903=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1384901903==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Does this apply to the problems with the twinhan 3030 cards not able to
init?<br>
<br>
<br>
Niklas Edmundsson skrev:
<blockquote
 cite="mid:Pine.GSO.4.64.0810191117040.16269@hatchepsut.acc.umu.se"
 type="cite">On Wed, 15 Oct 2008, Hans Bergersen wrote:
  <br>
  <br>
  <blockquote type="cite">Hi,
    <br>
    <br>
  </blockquote>
  <br>
  <blockquote type="cite">I have got a Twinhan vp-2033 based card. I
run Ubuntu 8.04. I have downloaded the driver from
<a class="moz-txt-link-freetext" href="http://jusst.de/hg/mantis">http://jusst.de/hg/mantis</a> and it compiled just fine. But when i try to
tune a channel the tuning fails. It is a newer card with the tda10023
tuner but when the driver loads it uses the tda10021. What do I have to
do to make it use the right tuner? Can i give some options when
compiling or when loading the module?
    <br>
  </blockquote>
&lt;snip&gt;
  <br>
  <blockquote type="cite">Any ideas?
    <br>
  </blockquote>
  <br>
Try the attached patch which fixes this for my Azurewave AD-CP300 (at
least last time I compiled it).
  <br>
  <br>
I've sent it to Manu and he was going to apply it, but it hasn't shown
up on <a class="moz-txt-link-freetext" href="http://jusst.de/hg/mantis/">http://jusst.de/hg/mantis/</a> yet...
  <br>
  <br>
  <br>
/Nikke
  <br>
  <pre wrap=""><pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre></pre>
</blockquote>
</body>
</html>


--===============1384901903==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1384901903==--
