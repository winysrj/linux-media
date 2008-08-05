Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <themuso@themuso.com>) id 1KQWAV-0006L7-LO
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 01:42:21 +0200
Date: Wed, 6 Aug 2008 09:41:29 +1000
From: Luke Yelavich <themuso@themuso.com>
To: linux-dvb@linuxtv.org
Message-ID: <20080805234129.GD11008@brainz.yelavich.home>
References: <20080801034025.C0EC947808F@ws1-5.us4.outblaze.com>
	<4897AC24.3040006@linuxtv.org> <20080805214339.GA7314@kryten>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080805214339.GA7314@kryten>
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

On Wed, Aug 06, 2008 at 07:43:40AM EST, Anton Blanchard wrote:
> 
> Hi Steve,
> 
> > http://linuxtv.org/hg/~stoth/v4l-dvb
> >
> > This has Anton's patches and a subsequent cleanup patch to merge the  
> > single tune callback functions into a single entity. A much better  
> > solution all-round.
> >
> > I've tested with the HVR1500Q (xc5000 based) and I'm happy with the  
> > results. Can you both try the DViCO board?
> 
> It tests fine and I like how simpler things have got.

I pulled the above linked tree, and compiled the modules. It seems at the moment for the dual express, that I have to pass the parameter card=11 to the driver, for it to correctly find the card and make use of all adapters. Without any module parameters, dmsg complains that the card couldn't be identified, yet two adapters are shown. I have two of these cards.

Hope this helps some.

Luke
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFImOUpjVefwtBjIM4RAtYqAKCCZVC/Of7uHUoTDbUsU9n8QiTAbgCgwvH9
dE6iNAjtb3+eeZ5ZZqGLsJU=
=RFyP
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
