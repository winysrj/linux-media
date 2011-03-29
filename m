Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <marcc@dommel.be>) id 1Q4erg-0000TP-9I
	for linux-dvb@linuxtv.org; Tue, 29 Mar 2011 21:46:08 +0200
Received: from tuur.schedom-europe.net ([193.109.184.94])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-1) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1Q4erg-00026c-JS; Tue, 29 Mar 2011 21:46:08 +0200
Message-ID: <4D9236F6.5090809@dommel.be>
Date: Tue, 29 Mar 2011 21:45:58 +0200
From: Marc Coevoet <marcc@dommel.be>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
References: <BANLkTimw3uptgMusYRhZyFCb3ZVD8jj20g@mail.gmail.com>
In-Reply-To: <BANLkTimw3uptgMusYRhZyFCb3ZVD8jj20g@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Questions about some TV viewers
Reply-To: linux-media@vger.kernel.org, marcc@dommel.be
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0973895066=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0973895066==
Content-Type: multipart/alternative;
 boundary="------------070901090801080306050100"

This is a multi-part message in MIME format.
--------------070901090801080306050100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Op 29-03-11 21:04, a dehqan schreef:
> In The Name Of Allah The compassionate merciful
>
> Good day all
> Hello;
>
> 1- I(humble) want  alsa "forward" the sound from tvtime to hw:1,0 .How 
> to map the analog output to the digital output using alsa ?
>
> 2 - I(humble) use this command to see a TV channel with VLC :|
>
> vlc v4l2:///dev/video0  :input-slave=alsa://hw:1,0 :v4l2-standard=1 
> :v4l2-tuner-frequency=583250|
>



There is something like wirbelscan, under ubuntu  :

for hotbird it is for me
w_scan -c be -q -q -q -f s -s S13E0 -F -t 3 > 2S13E0

for astra:
w_scan -c be -q -q -q -f s -s S19E2 -F -t 3 -D 1c > 2S19E2


(in fact this is a channels.conf )

then

vlc 2S13E0

does the rest, gives you a list of TX (ctrl L), select one, and go..

There is an app called klear, uses the channels.conf in some place .klear..

There is kaffeine, scans for itself, first configure TV, then scan freqs ..


Marc--

What's on Shortwave guide: choose an hour, go!
http://shortwave.tk
700+ Radio Stations on SWhttp://swstations.tk
300+ languages on SWhttp://radiolanguages.tk


--------------070901090801080306050100
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#ffffff" text="#000000">
    <div class="moz-text-html" lang="x-western"> Op 29-03-11 21:04, a
      dehqan schreef:
      <blockquote
        cite="mid:BANLkTimw3uptgMusYRhZyFCb3ZVD8jj20g@mail.gmail.com"
        type="cite">
        <div dir="ltr">In The Name Of Allah The compassionate merciful<br>
          <br>
          Good day all <br>
          Hello;<br>
          <br>
          1- I(humble) want&nbsp; alsa "forward" the sound from tvtime to
          hw:1,0 .How to map the analog output to the digital output
          using alsa ?<br>
          <br>
          2 - I(humble) use this command to see a TV channel with VLC :<code><br>
            <br>
            vlc v4l2:///dev/video0&nbsp; :input-slave=alsa://hw:1,0
            :v4l2-standard=1 :v4l2-tuner-frequency=583250</code><br>
          <br>
        </div>
      </blockquote>
      <br>
      <br>
      <br>
      There is something like wirbelscan, under ubuntu&nbsp; :<br>
      <br>
      for hotbird it is for me<br>
      w_scan -c be -q -q -q -f s -s S13E0 -F -t 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &gt; 2S13E0<br>
      <br>
      for astra:<br>
      w_scan -c be -q -q -q -f s -s S19E2 -F -t 3 -D 1c &gt; 2S19E2<br>
      <br>
      <br>
      (in fact this is a channels.conf )<br>
      <br>
      then <br>
      <br>
      vlc 2S13E0<br>
      <br>
      does the rest, gives you a list of TX (ctrl L), select one, and
      go..<br>
      <br>
      There is an app called klear, uses the channels.conf in some place
      .klear..<br>
      <br>
      There is kaffeine, scans for itself, first configure TV, then scan
      freqs ..<br>
      <br>
      <br>
      Marc-- <br>
      <pre class="moz-signature" cols="72">What's on Shortwave guide: choose an hour, go!
<a class="moz-txt-link-freetext" href="http://shortwave.tk">http://shortwave.tk</a>
700+ Radio Stations on SW <a class="moz-txt-link-freetext" href="http://swstations.tk">http://swstations.tk</a>
300+ languages on SW <a class="moz-txt-link-freetext" href="http://radiolanguages.tk">http://radiolanguages.tk</a>

</pre>
    </div>
  </body>
</html>

--------------070901090801080306050100--


--===============0973895066==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0973895066==--
