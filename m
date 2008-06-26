Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout1.freenet.de ([195.4.92.91])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1KBxr5-0006Xt-AC
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2008 22:14:08 +0200
Message-ID: <4863F88A.1010708@freenet.de>
Date: Thu, 26 Jun 2008 22:14:02 +0200
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Mikko_M=E4kinen?= <mikko.reijo.makinen@gmail.com>
References: <9c84b2480806251121r69c577cdmaac2a5d0b9d7737b@mail.gmail.com>
In-Reply-To: <9c84b2480806251121r69c577cdmaac2a5d0b9d7737b@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy C HD (1822:4e35)
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

Mikko M=E4kinen schrieb:
>
> Does anyone have a clue what I should try next? Or has anyone had =

> success with this card. I couldn't find earlier models, like cinergy =

> 1200-c, or even newer, anywhere. I'm supposed to build a DVB to IP =

> streaming machine for a school, so I would also be happy if someone =

> knew any other available DVB-C cards working under linux.
As said several times on this list, the Twinhan AD-CP300 (Mantis2033) =

works perfect
with the drivers from http://www.jusst.de/hg/mantis =

<http://www.jusst.de/hg/mantis>
except the CAM, which is still not working for me.
The latest change set (7348) works here with a 2.6.24.7 kernel.
The last working changeset for kernel 2.6.22.19 was changeset 7328 =

(21.Mai.08).
Hence I recommend changeset 7328.

Apparently this card is shipped with two different tuners.
My card has the TDA10021, whereas other mention trouble (it does not =

tune) with the TDA10023.

The other day, there was this post

http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026873.html

providing a patch, which looks like making the TDA10023 working fine.

Ciao Ruediger D.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
