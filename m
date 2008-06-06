Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1019.yellis.net ([213.246.41.159] helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1K4awE-0002NR-5o
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 14:20:58 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id D7E822FA89C
	for <linux-dvb@linuxtv.org>; Fri,  6 Jun 2008 14:21:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 9390A130008A
	for <linux-dvb@linuxtv.org>; Fri,  6 Jun 2008 14:20:54 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PpxZ5TY+rPp7 for <linux-dvb@linuxtv.org>;
	Fri,  6 Jun 2008 14:20:51 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id F1B6B1300089
	for <linux-dvb@linuxtv.org>; Fri,  6 Jun 2008 14:20:50 +0200 (CEST)
Message-ID: <48492B9C.1060109@anevia.com>
Date: Fri, 06 Jun 2008 14:20:44 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <484929F0.3060701@anevia.com>
In-Reply-To: <484929F0.3060701@anevia.com>
Subject: Re: [linux-dvb] [CAM] SCM Irdeto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Frederic CAND a =E9crit :
> Anyone having a SCM Irdeto managed to make it work ?
> ioctls do work, but reads/writes gives an "input/output error" ... with =

> any software i used
> =

> I tried with an old technotrend dvbs budget card, a knc tv star dvbs, =

> dvbs2, with no sucess
> =

> btw the cam is working under windows and in a set top box
> =

> nothing written in dmesg, just the -1 error when I try to write to the =

> CAM to send a TPDU (perror saying "input/output error")
> =

> =

I forgot to mention it, but I tried many different kernels, for old to =

new, many different v4l-dvb drivers, from old to recent ...

-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
