Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mailfe02.tele2.fr ([212.247.154.44] helo=swip.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alain2.roos@tele2.fr>) id 1JM8wa-00040s-J7
	for linux-dvb@linuxtv.org; Mon, 04 Feb 2008 22:33:36 +0100
From: Alain Roos <alain2.roos@tele2.fr>
To: linux-dvb@linuxtv.org, michael.wuenscher@gmx.de, patrick.boettcher@desy.de
Date: Mon, 4 Feb 2008 22:33:03 +0100
References: <200802011811.57252.alain2.roos@tele2.fr>
In-Reply-To: <200802011811.57252.alain2.roos@tele2.fr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802042233.06289.alain2.roos@tele2.fr>
Subject: Re: [linux-dvb] Driver for dvb-T via usb : 1164:2efc
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

Are you interested to update the dib0700 driver to record that above mentio=
nned YUAN device is working ?

Do you have any advice how to improve stability ?

Thanks,

Alain

Le vendredi 1 f=E9vrier 2008 18:11, Alain Roos a =E9crit :
> Hi,
> =

> - At the time of doing "hg clone", the head was :
> changeset:   7115:3f704aa9d92e
> tag:         tip
> date:        Tue Jan 29 16:32:35 2008 -0200
> =

> - The patch is attached (if you don't like attachments in this mailing li=
st, all my apologies)
> =

> I'm running linux kernel 2.6.23.14, using distro Debian Etch, kaffeine as=
 a TV viewer.
> =

> The only issue is that after some channel zapping or even immediately, th=
e tuner does no longer respond, =

> kaffeine hangs, modules cannot be unloaded even with rmmod -f (the dongle=
 being disconnected). =

> The lsusb command hangs also.
> =

> Only rebooting helps (and sucks).
> =

> The chips on the board are :
> DIBcom 7070PB1-AXGXba-G-a
> and
> DIBcom 0700C-XCXXa-G
> =

> I would be most grateful if someone has an idea about improving the stabi=
lity of the driver.
> =

> Also I've found in the archives a thread : http://www.linuxtv.org/piperma=
il/linux-dvb/2007-January/015525.html
> involving Patrick Boettcher and Michael W=FCnscher about a similar device
That ID was 1164:1efc

> (I had the same driver information under Windows).
> =

> Alain Roos (Alsace / France)
> =


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
