Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <laasa@gmx.de>) id 1KHJXh-0002Aj-SN
	for linux-dvb@linuxtv.org; Fri, 11 Jul 2008 16:24:14 +0200
Received: from mail-in-11-z2.arcor-online.net (mail-in-11-z2.arcor-online.net
	[151.189.8.28])
	by mail-in-05.arcor-online.net (Postfix) with ESMTP id 27AEE1834F4
	for <linux-dvb@linuxtv.org>; Fri, 11 Jul 2008 16:24:10 +0200 (CEST)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mail-in-11-z2.arcor-online.net (Postfix) with ESMTP id 14DF53465A8
	for <linux-dvb@linuxtv.org>; Fri, 11 Jul 2008 16:24:10 +0200 (CEST)
Received: from server2.zuhause.xx (dslb-088-072-250-232.pools.arcor-ip.net
	[88.72.250.232])
	by mail-in-02.arcor-online.net (Postfix) with ESMTP id DB8DB27ECB
	for <linux-dvb@linuxtv.org>; Fri, 11 Jul 2008 16:24:09 +0200 (CEST)
Received: from [192.168.1.32] (az.zuhause.xx [192.168.1.32])
	by server2.zuhause.xx (Postfix) with ESMTP id 06B2AD6B25
	for <linux-dvb@linuxtv.org>; Fri, 11 Jul 2008 16:24:19 +0200 (CEST)
Message-ID: <48776CD9.1040502@server>
Date: Fri, 11 Jul 2008 16:23:21 +0200
From: laasa <laasa@server>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  Re : Re : How to get 2 TT3650-CI working
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

> Talking about the patch from dominik: is it normal that the registers =

> settings are different than those from TT-3200 (in budget-ci.c)? I mean =

> it is the same chips (stb0899/stb6100), so is it possible to use those =

> settings directly with a TT 3200; I have reception problems for some =

> transponders, and a lot of other users also, so if those settings are =

> OK to try I guess that's something I am ready to do to improve things.
> Also I saw that the patch touches stb0899/6100 files in the frontends =

> dir, so my question: are these changes there to improve tuning also or =

> just related to the support of the other cards?
> Thx
> Bye
> Manu =


I have test this week the locking of my tt3650ci with the hg from the end o=
f last wheek (7215) plus pctv452e-patch.
I cant see any locking problems but I have a very simple configuration (onl=
y one satelite: ASTRA 19,2=B0E, most channels on horizontal high-band).

Why the pctv452e-module use different settings for STB0899 and STB6100 I do=
nt know, sorry.

When I compare the actual driver with the driver I have used the last month=
s (version from february) I think the locking is much faster.

*But back to the problem in the headline:*
When anyone have the same problem with 2 or more TT3600 or TT3650CI hopeful=
ly the solution is to decrease the count of urb's (USB request block).
When I change in line 1058 of file pctv452e.c from ".count =3D 7;" to ".cou=
nt =3D 4" it works for me.

Hopefully it helps other.

Best regards,
laasa.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
