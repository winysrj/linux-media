Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaymode@gmail.com>) id 1KVZb0-0003Wd-Ph
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 00:22:35 +0200
Received: by fg-out-1718.google.com with SMTP id e21so119181fga.25
	for <linux-dvb@linuxtv.org>; Tue, 19 Aug 2008 15:22:31 -0700 (PDT)
Message-ID: <6664ae760808191522m1997bb12r7e2be880b92f83e6@mail.gmail.com>
Date: Tue, 19 Aug 2008 18:22:31 -0400
From: "Jay Modi" <jaymode@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48AB3DE3.7030406@linuxtv.org>
MIME-Version: 1.0
References: <6664ae760808181614g47d65c7atf71d564d815934a8@mail.gmail.com>
	<48AAF9FB.6010108@ecst.csuchico.edu>
	<6664ae760808191345y3a0c5bd8odd4f5f7ca969b3b@mail.gmail.com>
	<48AB3507.8030302@linuxtv.org>
	<6664ae760808191423u1147789eve2cae5ea6dbdad80@mail.gmail.com>
	<48AB3DE3.7030406@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2137780256=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2137780256==
Content-Type: multipart/alternative;
	boundary="----=_Part_114299_6314258.1219184551505"

------=_Part_114299_6314258.1219184551505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Steven Toth wrote:

> Remove all other video drivers (with make unload) and try again.
>
> If the HVR1800 is the only capture in the system then it will be registered
> as /dev/video0 and /dev/video1.
>
> If you have to, try physically removing the other card and re-run the test.
>


I take it that means I will need to download the latest linux dvb drivers to
do the make unload?

I also have an IVTV card, an Adaptec AVC-2410, installed in my system. I
will have to do this a little later this week when I have time to remove it
and play around more.

------=_Part_114299_6314258.1219184551505
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Steven Toth<span dir="ltr"></span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Remove all other video drivers (with make unload) and try again.<br>

<br>
If the HVR1800 is the only capture in the system then it will be registered as /dev/video0 and /dev/video1.<br>
<br>
If you have to, try physically removing the other card and re-run the test.<br>
</blockquote><div><br><br>I take it that means I will need to download the latest linux dvb drivers to do the make unload?<br><br>I also have an IVTV card, an Adaptec AVC-2410, installed in my system. I will have to do this a little later this week when I have time to remove it and play around more. <br>
</div></div><br></div>

------=_Part_114299_6314258.1219184551505--


--===============2137780256==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2137780256==--
