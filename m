Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KkJVE-0002kb-Ki
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 16:13:33 +0200
Received: by qw-out-2122.google.com with SMTP id 9so260175qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 29 Sep 2008 07:13:27 -0700 (PDT)
Message-ID: <c74595dc0809290713i7ca11bdfw3424c8347e9a6d9e@mail.gmail.com>
Date: Mon, 29 Sep 2008 17:13:27 +0300
From: "Alex Betis" <alex.betis@gmail.com>
To: "Jelle De Loecker" <skerit@kipdola.com>
In-Reply-To: <48E0D490.5030202@kipdola.com>
MIME-Version: 1.0
References: <1221327465l.12125l.2l@manu-laptop> <48CC4867.1050705@gmail.com>
	<1221354611l.12125l.3l@manu-laptop> <48E0D490.5030202@kipdola.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Re : Re : TT S2-3200 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1218711442=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1218711442==
Content-Type: multipart/alternative;
	boundary="----=_Part_16274_17392496.1222697607844"

------=_Part_16274_17392496.1222697607844
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Does that card use stb0899 drivers as Twinhan 1041?

I've done some changes to the algorithm that provide constant lock.

2008/9/29 Jelle De Loecker <skerit@kipdola.com>

>
> manu schreef:
>
> Le 13.09.2008 19:10:31, Manu Abraham a =E9crit :
>
>
>  manu wrote:
>
>
>  I forgot the logs...
>
>
>  Taking a look at it. Please do note that, i will have to go through
> it
> very patiently.
>
> Thanks for the logs.
>
>
>
>  You're more than welcome. I tried to put some printk's but the only
> thing I got is that even when the carrier is correctly detected, the
> driver does not detect the data (could that be related to the different
> FEC?).
> Anyway let me know if you need more testing.
> Bye
> Manu
>
>
> I'm unable to scan the channels on the Astra 23,5 satellite
> Frequency 11856000
> Symbol rate 27500000
> Vertical polarisation
> FEC 5/6
>
> Is this because of the same bug? I should be getting Discovery Channel HD=
,
> National Geographic Channel HD, Brava HDTV and Voom HD International, but
> I'm only getting a time out.
>
>
> *Met vriendelijke groeten,*
>
> *Jelle De Loecker*
> Kipdola Studios - Tomberg
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_16274_17392496.1222697607844
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Does that card use stb0899 drivers as Twinhan 1041?<br><br=
>I&#39;ve done some changes to the algorithm that provide constant lock.<br=
><br><div class=3D"gmail_quote">2008/9/29 Jelle De Loecker <span dir=3D"ltr=
">&lt;<a href=3D"mailto:skerit@kipdola.com">skerit@kipdola.com</a>&gt;</spa=
n><br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">


 =20

<div bgcolor=3D"#ffffff" text=3D"#000000">
<br>
manu schreef:
<blockquote type=3D"cite">
  <pre>Le 13.09.2008 19:10:31, Manu Abraham a =E9crit&nbsp;:
  </pre>
  <blockquote type=3D"cite">
    <pre>manu wrote:
    </pre>
    <blockquote type=3D"cite">
      <pre>I forgot the logs...
      </pre>
    </blockquote>
    <pre>Taking a look at it. Please do note that, i will have to go throug=
h=20
it
very patiently.

Thanks for the logs.

    </pre>
  </blockquote>
  <pre>You&#39;re more than welcome. I tried to put some printk&#39;s but t=
he only=20
thing I got is that even when the carrier is correctly detected, the=20
driver does not detect the data (could that be related to the different=20
FEC?).
Anyway let me know if you need more testing.
Bye
Manu</pre>
</blockquote>
<br>
I&#39;m unable to scan the channels on the Astra 23,5 satellite<br>
Frequency 11856000<br>
Symbol rate 27500000<br>
Vertical polarisation<br>
FEC 5/6<br>
<br>
Is this because of the same bug? I should be getting Discovery Channel
HD, National Geographic Channel HD, Brava HDTV and Voom HD
International, but I&#39;m only getting a time out.<br>
<br>
<div><br>
<i>Met vriendelijke groeten,</i>
<br>
<br>
<b>Jelle De Loecker</b>
<br>
Kipdola Studios - Tomberg <br>
<br>
</div>
<br>
</div>

<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br></blockquote></div><br></div>

------=_Part_16274_17392496.1222697607844--


--===============1218711442==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1218711442==--
