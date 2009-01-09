Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.citynetwork.se ([62.95.110.81] helo=smtp05.citynetwork.se)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <reklam@holisticode.se>) id 1LL4yi-0003E6-Ru
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 01:12:00 +0100
Received: from localhost (localhost [127.0.0.1])
	by smtp05.citynetwork.se (Postfix) with ESMTP id 80ACD28C1BA
	for <linux-dvb@linuxtv.org>; Fri,  9 Jan 2009 01:11:41 +0100 (CET)
Received: from smtp05.citynetwork.se ([127.0.0.1])
	by localhost (smtp05.citynetwork.se [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id PAjsEWIc2C4f for <linux-dvb@linuxtv.org>;
	Fri,  9 Jan 2009 01:11:39 +0100 (CET)
Received: from xplap (c83-250-175-60.bredband.comhem.se [83.250.175.60])
	(Authenticated sender: reklam@holisticode.se)
	by smtp05.citynetwork.se (Postfix) with ESMTPA id 3FFF228C1CB
	for <linux-dvb@linuxtv.org>; Fri,  9 Jan 2009 01:11:39 +0100 (CET)
From: =?iso-8859-1?Q?M=E5rten_Gustafsson?= <reklam@holisticode.se>
To: <linux-dvb@linuxtv.org>
References: <mailman.1.1231412401.14666.linux-dvb@linuxtv.org>
Date: Fri, 9 Jan 2009 01:11:20 +0100
Message-ID: <26D75E582F22456998AE6365440ACEC6@xplap>
MIME-Version: 1.0
In-Reply-To: <mailman.1.1231412401.14666.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Compiling mantis driver on 2.6.28
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

I tried downloading and compiling from s2-liplianin repository.
Unfortunately the driver doesn't work at all with AzureWave AD-CP300,
frontend tda10021 is identified instead of tda10023.

On Sun, 19 Oct 2008 11:19:40 +0200 (MEST) Niklas Edmundsson posted a patch
that makes the mantis driver correctly identify the frontend tda10023. It is
in linux-dvb Digest, Vol 45, Issue 24. I tried that patch on the just.de
repository and it kind of "improved" things, but since CI support was
lacking it was unusable for me.

I would really appreciate CI support since all my ComHem channels are
scrambled. =


M=E5rten

-----Ursprungligt meddelande-----
Date: Wed, 07 Jan 2009 13:28:20 +0100
From: "Hans Werner" <HWerner4@gmx.de>
Subject: Re: [linux-dvb] Compiling mantis driver on 2.6.28
To: Christian Lammers <christian.lammers@gmail.com>,
	linux-dvb@linuxtv.org
Message-ID: <20090107122820.151430@gmx.net>
Content-Type: text/plain; charset=3D"iso-8859-1"

> Hi,
> =

> i'm new to this mailinglist, so 'Hello' to all :)
> =

> My first problem, cause of bleeding edge hardware, intels gem, hdmi,
> experimental xorg and so on, i've problems to compile the mantis driver
> from http://jusst.de/hg/mantis on 2.6.28.
> =

> I'm getting the following:
> =

> .... ....
> =

> Is there a patch or something else to get this driver working on 2.6.28

Use the s2-liplianin repository.  It contains an up-to-date mantis driver.

hg clone http://mercurial.intuxication.org/hg/s2-liplianin
cd s2-liplianin
make
sudo make install
sudo reboot

Hans
-- =



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
