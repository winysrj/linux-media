Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <dehqan65@gmail.com>) id 1Q4eyK-0000zQ-9n
	for linux-dvb@linuxtv.org; Tue, 29 Mar 2011 21:53:00 +0200
Received: from mail-qy0-f175.google.com ([209.85.216.175])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1Q4eyJ-0002pc-CL; Tue, 29 Mar 2011 21:53:00 +0200
Received: by qyk35 with SMTP id 35so2507321qyk.20
	for <linux-dvb@linuxtv.org>; Tue, 29 Mar 2011 12:52:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D9236F6.5090809@dommel.be>
References: <BANLkTimw3uptgMusYRhZyFCb3ZVD8jj20g@mail.gmail.com>
	<4D9236F6.5090809@dommel.be>
Date: Wed, 30 Mar 2011 00:22:57 +0430
Message-ID: <BANLkTi=s55=mtNzYFyxnxzSmDdarVKx_MA@mail.gmail.com>
From: a dehqan <dehqan65@gmail.com>
To: marcc@dommel.be, linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Questions about some TV viewers
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0150321123=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0150321123==
Content-Type: multipart/alternative; boundary=001636832278248e67049fa46808

--001636832278248e67049fa46808
Content-Type: text/plain; charset=ISO-8859-1

In The Name Of Allah The compassionate merciful

Good day all
Hello;

On Wed, Mar 30, 2011 at 12:15 AM, Marc Coevoet <marcc@dommel.be> wrote:

>  Op 29-03-11 21:04, a dehqan schreef:
>
>
>
> 1- I(humble) want  alsa "forward" the sound from tvtime to hw:1,0 .How to
> map the analog output to the digital output using alsa ?
>
> 2 - I(humble) use this command to see a TV channel with VLC :
>
> vlc v4l2:///dev/video0  :input-slave=alsa://hw:1,0 :v4l2-standard=1
> :v4l2-tuner-frequency=583250
>
>
>
>
> There is something like wirbelscan, under ubuntu  :
>
> for hotbird it is for me
> w_scan -c be -q -q -q -f s -s S13E0 -F -t 3       > 2S13E0
>
> for astra:
> w_scan -c be -q -q -q -f s -s S19E2 -F -t 3 -D 1c > 2S19E2
>
>
> (in fact this is a channels.conf )
>
> then
>
> vlc 2S13E0
>
> does the rest, gives you a list of TX (ctrl L), select one, and go..
>
> There is an app called klear, uses the channels.conf in some place .klear..
>
> There is kaffeine, scans for itself, first configure TV, then scan freqs ..
>
>
> Marc--
>
> What's on Shortwave guide: choose an hour, go!http://shortwave.tk
> 700+ Radio Stations on SW http://swstations.tk
> 300+ languages on SW http://radiolanguages.tk
>
>
Thanks , but this issue is about analog TV , and each channel has different
frequency .
Do you have any idea about question 1 ?

Regards dehqan

--001636832278248e67049fa46808
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">In The Name Of Allah The compassionate merciful<br>
          <br>
          Good day all <br>
          Hello;<br><br><div class=3D"gmail_quote">On Wed, Mar 30, 2011 at =
12:15 AM, Marc Coevoet <span dir=3D"ltr">&lt;<a href=3D"mailto:marcc@dommel=
.be">marcc@dommel.be</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 20=
4, 204); padding-left: 1ex;">


 =20
   =20
 =20
  <div bgcolor=3D"#ffffff" text=3D"#000000">
    <div lang=3D"x-western"> Op 29-03-11 21:04, a
      dehqan schreef:
      <blockquote type=3D"cite">
        <div dir=3D"ltr"><br>
          <br>
          1- I(humble) want=A0 alsa &quot;forward&quot; the sound from tvti=
me to
          hw:1,0 .How to map the analog output to the digital output
          using alsa ?<br>
          <br>
          2 - I(humble) use this command to see a TV channel with VLC :<cod=
e><br>
            <br>
            vlc v4l2:///dev/video0=A0 :input-slave=3Dalsa://hw:1,0
            :v4l2-standard=3D1 :v4l2-tuner-frequency=3D583250</code><br>
          <br>
        </div>
      </blockquote>
      <br>
      <br>
      <br>
      There is something like wirbelscan, under ubuntu=A0 :<br>
      <br>
      for hotbird it is for me<br>
      w_scan -c be -q -q -q -f s -s S13E0 -F -t 3=A0=A0=A0=A0=A0=A0 &gt; 2S=
13E0<br>
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
      <pre cols=3D"72">What&#39;s on Shortwave guide: choose an hour, go!
<a href=3D"http://shortwave.tk" target=3D"_blank">http://shortwave.tk</a>
700+ Radio Stations on SW <a href=3D"http://swstations.tk" target=3D"_blank=
">http://swstations.tk</a>
300+ languages on SW <a href=3D"http://radiolanguages.tk" target=3D"_blank"=
>http://radiolanguages.tk</a>

</pre></div></div></blockquote><div><br>Thanks , but this issue is about an=
alog TV , and each channel has different frequency .<br>Do you have any ide=
a about question 1 ?<br><br>Regards dehqan<br>=A0<br></div></div><br></div>

--001636832278248e67049fa46808--


--===============0150321123==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0150321123==--
