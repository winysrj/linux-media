Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mailfe04.tele2.fr ([212.247.154.108] helo=swip.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alain2.roos@tele2.fr>) id 1JPi0B-0006Hj-DX
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 18:36:03 +0100
Received: from aroos.homelinux.org (account eu1252360@tele2.fr [90.144.37.79]
	verified) by mailfe04.swip.net (CommuniGate Pro SMTP 5.1.13)
	with ESMTPA id 804436312 for linux-dvb@linuxtv.org;
	Thu, 14 Feb 2008 18:35:32 +0100
Received: from alain by aroos.homelinux.org with local (Exim 3.36 #1 (Debian))
	id 1JPhze-0001Li-00
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 18:35:30 +0100
From: Alain Roos <alain2.roos@tele2.fr>
To: linux-dvb@linuxtv.org
Date: Thu, 14 Feb 2008 18:35:30 +0100
References: <200802011811.57252.alain2.roos@tele2.fr>
	<200802042233.06289.alain2.roos@tele2.fr>
In-Reply-To: <200802042233.06289.alain2.roos@tele2.fr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802141835.30684.alain2.roos@tele2.fr>
Subject: Re: [linux-dvb] [PATCH] Emtec 810S DVB-T Stick (164:2efc)
Reply-To: alain2.roos@tele2.fr
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I've something interesting in the unstability issue for my Emtec 810S DVB-T=
 Stick

When the kaffeine TV screen freezes, the =

dmesg indicates that the USB device is disconnected
and syslog continus to report that i2c-adapter is used :
master_xfer[0] W or [1] R, addr=3D 0x40, len=3D2

Best regards,

Alain

Le lundi 4 f=E9vrier 2008 22:33, Alain Roos a =E9crit :
> Hi,
> =

> Are you interested to update the dib0700 driver to record that above ment=
ionned YUAN device is working ?
> =

> Do you have any advice how to improve stability ?
> =

> Thanks,
> =

> Alain
> =

> Le vendredi 1 f=E9vrier 2008 18:11, Alain Roos a =E9crit :
> > Hi,
> > =

> > - At the time of doing "hg clone", the head was :
> > changeset:   7115:3f704aa9d92e
> > tag:         tip
> > date:        Tue Jan 29 16:32:35 2008 -0200
> > =

> > - The patch is attached (if you don't like attachments in this mailing =
list, all my apologies)
> > =

> > I'm running linux kernel 2.6.23.14, using distro Debian Etch, kaffeine =
as a TV viewer.
> > =

> > The only issue is that after some channel zapping or even immediately, =
the tuner does no longer respond, =

> > kaffeine hangs, modules cannot be unloaded even with rmmod -f (the dong=
le being disconnected). =

> > The lsusb command hangs also.
> > =

> > Only rebooting helps (and sucks).
> > =

> > The chips on the board are :
> > DIBcom 7070PB1-AXGXba-G-a
> > and
> > DIBcom 0700C-XCXXa-G
> > =

> > I would be most grateful if someone has an idea about improving the sta=
bility of the driver.
> > =

> > Also I've found in the archives a thread : http://www.linuxtv.org/piper=
mail/linux-dvb/2007-January/015525.html
> > involving Patrick Boettcher and Michael W=FCnscher about a similar devi=
ce
> That ID was 1164:1efc
> =

> > (I had the same driver information under Windows).
> > =

> > Alain Roos (Alsace / France)
> > =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> =

> =


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
