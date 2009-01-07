Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LKXWo-0007I2-5A
	for linux-dvb@linuxtv.org; Wed, 07 Jan 2009 13:28:55 +0100
Date: Wed, 07 Jan 2009 13:28:20 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <4964989C.6000506@gmail.com>
Message-ID: <20090107122820.151430@gmx.net>
MIME-Version: 1.0
References: <4964989C.6000506@gmail.com>
To: Christian Lammers <christian.lammers@gmail.com>, linux-dvb@linuxtv.org
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

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
