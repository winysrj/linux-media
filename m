Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway06.websitewelcome.com ([67.18.21.22])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1KLcQf-0006Fs-7Q
	for linux-dvb@linuxtv.org; Wed, 23 Jul 2008 13:22:48 +0200
Received: from [77.109.104.69] (port=55570 helo=[127.0.0.1])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1KLcQY-0008KW-Bg
	for linux-dvb@linuxtv.org; Wed, 23 Jul 2008 06:22:38 -0500
Message-ID: <4887147E.1060203@kipdola.com>
Date: Wed, 23 Jul 2008 13:22:38 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Checkinstall multiproto?
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

Hello again,

I'm trying to install the multiproto drivers using checkinstall. I'm =

currently trying lots of different drivers through each other, and make =

rminstall or make distclean never get ALL of the files out, so I want to =

make a debian out of them to keep my system clean.

Making the deb is no problem.
Unfortunately, these drivers need to overwrite a certain file =

(ir-common.ko) which is already in another, important, package =

(linux-image-2.6.24-20-generic)

Could someone give any pointers how I could fix this?

root@HTPC-MYTH:/opt/dvb/multiproto# dpkg -i *.deb
(Database inlezen ... 137231 bestanden en mappen ge=EFnstalleerd.)
Uitpakken van multiproto (uit multiproto_7207-1_i386.deb) ...
dpkg: fout bij afhandelen van multiproto_7207-1_i386.deb (--install):
poging tot overschrijven van =

`/lib/modules/2.6.24-20-generic/kernel/drivers/media/common/ir-common.ko', =

wat ook in pakket linux-image-2.6.24-20-generic zit
dpkg-deb: subproces paste werd gedood door signaal (Gebroken pijp)
Fouten gevonden tijdens behandelen van:
multiproto_7207-1_i386.deb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
