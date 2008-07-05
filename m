Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1KF6xB-0003PY-7R
	for linux-dvb@linuxtv.org; Sat, 05 Jul 2008 14:33:26 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2008328rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 05 Jul 2008 05:33:20 -0700 (PDT)
Message-ID: <e37d7f810807050533v48343d46p34adc61937284dbf@mail.gmail.com>
Date: Sat, 5 Jul 2008 13:33:20 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <486F3CEA.1030903@iki.fi>
MIME-Version: 1.0
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
	<9188.212.50.194.254.1213898824.squirrel@webmail.kapsi.fi>
	<e37d7f810806191119h76ef8162ia3dc14b350fcd22c@mail.gmail.com>
	<e37d7f810806230414o7b7d589q71bf6ae5d8c9bc4b@mail.gmail.com>
	<e37d7f810806231158l848f2d3hb160f16db38e71a7@mail.gmail.com>
	<9738.212.50.194.254.1214289017.squirrel@webmail.kapsi.fi>
	<e37d7f810806241209y6b1c3e0dn61048cc58922bc68@mail.gmail.com>
	<e37d7f810806251528w738f3d20sdf6f1e35d487e1e0@mail.gmail.com>
	<e37d7f810807041613haf8c091q4afa56673a07f5b7@mail.gmail.com>
	<486F3CEA.1030903@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0594621341=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0594621341==
Content-Type: multipart/alternative;
	boundary="----=_Part_13593_6716997.1215261200334"

------=_Part_13593_6716997.1215261200334
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/7/5 Antti Palosaari <crope@iki.fi>:

>
> There is two kind of LEDs in those sticks. One is power LED that lights all
> the time when device is powered and the other lock LED that lights only when
> demodulator is locked to the valid channel. I assume your device has lock
> LED that should light only when device is locked to the valid channel.
> Controlling LEDs is sometimes possible by the driver software and sometimes
> not at all. Don't care LED before device is not working.
>
> I think it is better to strong known good signal and test device against it
> to see if everything is almost right. After that you can try to find
> settings to reach better receiving sensitivity.
>


I'm going to try with a better signal this p.m. Thanks for info re:LED

Regards
Andrew

------=_Part_13593_6716997.1215261200334
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">2008/7/5 Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class="Wj3C7c"><br></div></div>
There is two kind of LEDs in those sticks. One is power LED that lights all the time when device is powered and the other lock LED that lights only when demodulator is locked to the valid channel. I assume your device has lock LED that should light only when device is locked to the valid channel. Controlling LEDs is sometimes possible by the driver software and sometimes not at all. Don&#39;t care LED before device is not working.<br>

<br>
I think it is better to strong known good signal and test device against it to see if everything is almost right. After that you can try to find settings to reach better receiving sensitivity.<div><div></div><div class="Wj3C7c">
</div></div></blockquote><div><br><br>I&#39;m going to try with a better signal this p.m. Thanks for info re:LED<br><br>Regards<br>Andrew<br>&nbsp;<br></div></div><br>

------=_Part_13593_6716997.1215261200334--


--===============0594621341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0594621341==--
