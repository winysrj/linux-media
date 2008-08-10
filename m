Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Mon, 11 Aug 2008 09:31:58 +1000
From: Luke Yelavich <themuso@themuso.com>
To: Steven Toth <stoth@linuxtv.org>
Message-ID: <20080810233158.GA10642@brainz.yelavich.home>
References: <20080801034025.C0EC947808F@ws1-5.us4.outblaze.com>
	<4897AC24.3040006@linuxtv.org> <20080805214339.GA7314@kryten>
	<20080805234129.GD11008@brainz.yelavich.home>
	<4899020C.50000@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4899020C.50000@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
	FusionHDTV	DVB-T Dual Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sorry for the late reply.

On Wed, Aug 06, 2008 at 11:44:44AM EST, Steven Toth wrote:
> .. And they're both the same model?

Yes they are.

> If so, insert one at a time and run the 'lspci -vn' command, save the  
> output for each card.

I can't insert them one at a time, unless I remove one card at a time from the box physically. Since my last mail, the box has been rebooted a few times, and the module finds all tuners without being set up without manually telling the module which card is being used. It probably didn't work before due to older modules still being loaded in the kernel.

> Post the output here.

As stated above, all is well now without any manual intervention on my part.

Luke
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIn3pujVefwtBjIM4RAmKIAJ9tx4XqrT0i4gTrUPcx1Je6Ar5KVACgulmb
EXmkWYpyB2s/3ewmDbd571Q=
=hGiL
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
