Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f171.google.com ([209.85.219.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jesper@taxboel.dk>) id 1Lgymk-0006hu-BA
	for linux-dvb@linuxtv.org; Tue, 10 Mar 2009 11:02:06 +0100
Received: by ewy19 with SMTP id 19so1078012ewy.17
	for <linux-dvb@linuxtv.org>; Tue, 10 Mar 2009 03:01:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e78558910903100243m787b1ff6rd4c4785c71898c3f@mail.gmail.com>
References: <e78558910903100243m787b1ff6rd4c4785c71898c3f@mail.gmail.com>
Date: Tue, 10 Mar 2009 11:01:32 +0100
Message-ID: <e78558910903100301w4b5b9fd1g28f242bed3df9667@mail.gmail.com>
From: =?ISO-8859-1?Q?Jesper_Taxb=F8l?= <jesper@taxboel.dk>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] clock() returns 0 after poll() - anyone?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1810420784=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1810420784==
Content-Type: multipart/alternative; boundary=000e0cd1ea2ae6e46b0464c0d51f

--000e0cd1ea2ae6e46b0464c0d51f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Guys,

This might be a noob question, but here it goes.

I am playing with a small app, inspired from scan in linuxtv-dvb-apps. So I
basically use poll() to collect data from dvb filters.
My problem is that I am using the clock() function to measure progressing
time, alongside using the poll function to poll a list of filters. The funn=
y
thing is that clock returns 0 when I have called the poll function even
though the poll function have been idle for a while. This screws up my
timing.

I am using Eclipse CDT on a Ubuntu 8.10.

Is there an alternative to clock, when I need fine grained timing. Or shoul=
d
I poll the filters in an other way than using poll.

Kind regards and sorry or the inconvenience

Jesper Taxb=F8l

--000e0cd1ea2ae6e46b0464c0d51f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">Hi Guys,<br><br>This might be a noob question, b=
ut here it goes.<br><br>I am playing with a small app, inspired from scan i=
n linuxtv-dvb-apps. So I basically use poll() to collect data from dvb filt=
ers.<br>
My problem is that I am using the clock() function to measure progressing t=
ime, alongside using the poll function to poll a list of filters. The funny=
 thing is that clock returns 0 when I have called the poll function even th=
ough the poll function have been idle for a while. This screws up my timing=
.<br>

<br>I am using Eclipse CDT on a Ubuntu 8.10.<br><br>Is there an alternative=
 to clock, when I need fine grained timing. Or should I poll the filters in=
 an other way than using poll.<br><br>Kind regards and sorry or the inconve=
nience<br>
<font color=3D"#888888">
<br>Jesper Taxb=F8l<br><br>
</font></div><br>

--000e0cd1ea2ae6e46b0464c0d51f--


--===============1810420784==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1810420784==--
