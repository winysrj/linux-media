Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n37.bullet.mail.ukl.yahoo.com ([87.248.110.170])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KFXBl-0003sY-Pc
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 18:34:16 +0200
Date: Sun, 06 Jul 2008 12:30:42 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <4870C35D.8060405@server>
In-Reply-To: <4870C35D.8060405@server> (from laasa@server on Sun Jul  6
	09:06:37 2008)
Message-Id: <1215361842l.16980l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  How to get 2 TT3650-CI working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 06.07.2008 09:06:37, laasa a =E9crit=A0:
> First of all thanks to Dominik and Manu for the great work.
> =

> I want to get working two connected TT3650-CI. Under WinXP it will be =

> running without problems on the same hardware, so the USB-ports =

> should
> =

> not be the problem.
> =

> Unter Linux with one connected TT3650 all is working succesfully. But =

> with 2 connected TT3650 there are artefakts and dropouts on both =

> cards
> =

> after some seconds.
>  I have try it under following conditions:
> =

>     * Ubuntu 7.10 and Ubuntu 8.04
>     * actual multiproto-repository: http://jusst.de/hg/multiproto
>     * patch from dominik:
>       http://www.linuxtv.org/pipermail/linux-dvb/
> attachments/20080606/cc54743f/attachment-0001.obj
>     * special in line 1075 of modul pctv452e.c to get TT3650-CI work
>       (set num_device_descs *=3D 2*, otherwise only TT3600 works).
>     * a special patched MythTV 0.21 (wich works with 2 TT3200
> succesfully)

Talking about the patch from dominik: is it normal that the registers =

settings are different than those from TT-3200 (in budget-ci.c)? I mean =

it is the same chips (stb0899/stb6100), so is it possible to use those =

settings directly with a TT 3200; I have reception problems for some =

transponders, and a lot of other users also, so if those settings are =

OK to try I guess that's something I am ready to do to improve things.
Also I saw that the patch touches stb0899/6100 files in the frontends =

dir, so my question: are these changes there to improve tuning also or =

just related to the support of the other cards?
Thx
Bye
Manu =



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
