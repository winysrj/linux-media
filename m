Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lucidsolutions.co.nz ([202.154.159.217]
	helo=mta.lucidsolutions.co.nz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists-linux-dvb@lucidsolutions.co.nz>)
	id 1JpIGW-0007VL-2C
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 09:22:47 +0200
Message-ID: <481186AF.9050404@lucidsolutions.co.nz>
Date: Fri, 25 Apr 2008 19:22:23 +1200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <480F83F6.6000409@nerdshack.com>
In-Reply-To: <480F83F6.6000409@nerdshack.com>
From: Greg Brackley <lists-linux-dvb@lucidsolutions.co.nz>
Subject: Re: [linux-dvb] Avermedia M103 TV Card
Reply-To: Greg Brackley
	<greg.brackley-dated-1209712951.93be1b@lucidsolutions.co.nz>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Warning: I'm a newbie with these v4l drivers, and don't claim to be an
expert.

Rob & Kate wrote:
> The following site has managed to get this card working with the =

> experimental code
> http://plone.lucidsolutions.co.nz/dvb/t/compiling-mcentral-experimental-v=
4l-dvb-drivers =


Although I got the mcentral.de drivers loaded and running [3], I haven't
managed to get the main v4l drivers working with this card yet
(linuxtv.org)[2]. I would be interested in assisting anyone to get this
done.

I'm using four M103-C modules [1] in a routerboard card [5] to provide a
quad tuner card [4].

Looking through the code, it might not involve much more than adding the
  PCI ids and the required chipset/tuner to the right table.

> Can you please offer some advice, a couple of things that I think may be =

> the problem are
> =

> o Do I need to remove the card before I install the experimental code? =

> until now I haven=92t because its under the fan, but will if needs must.

I wouldn't have thought so. Once I put the card into the computer I
haven't had to remove it. I would unload the existing v4l modules with
your kernel. If the v4l drivers are build into your kernel (not
modules), then you will need to build a new kernel.


> o Do I need to disable the installed V4L modules in the kernel, and then =

> re-compile the kernel? This seems very scary, but someone on the gentoo =

> pages did it this way, so I=92ll give it ago if necessary

I left the stock kernel v4l modules in place, but put the new modules
earlier in the depmod path. As documented in a few places, use all 4vl
modules from the same place/version (half from your distro and half from
the experimental hg doesn't work).

> o How do I get the xc3028 to work, there seems to be 3 different =

> approaches, either download the windows firmware and convert, download =

> the picnnicale firmware =

> (http://mcentral.de/firmware/firmware_pinnacle.tgz), or download the =

> xc3028 firmware (http://mcentral.de/firmware/firmware_v5.tgz) .

As noted on the page, I found the firmware_v5.tgz firmware worked. When
I tried the v4l driver [1], I used other firmware (but I didn't get it
working).

I'm using this card for DVB-T only (I'm ignoring the analog support).
The card happily scans, and picks up current & next EIT program data. I
haven't got the rest of the system displaying the h.264 stream yet.

Greg.

--

[1]
http://plone.lucidsolutions.co.nz/dvb/t/avermedia-m-103c-0405ab34-mini-pci-=
hybrid-tuner

[2]
http://plone.lucidsolutions.co.nz/dvb/t/compiling-v4l-dvb-drivers-for-saa71=
34-and-xc2028

[3]
http://plone.lucidsolutions.co.nz/dvb/t/compiling-mcentral-experimental-v4l=
-dvb-drivers

[4] http://plone.lucidsolutions.co.nz/dvb/t/dvb-t-pci-quad-tuner

[5]
http://plone.lucidsolutions.co.nz/wireless/routerboard-14-pci-to-quad-mini-=
pci-adapter


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
