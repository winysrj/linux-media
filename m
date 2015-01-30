Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr1.cc.vt.edu ([198.82.141.52]:38972 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760838AbbA3NKY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2015 08:10:24 -0500
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	devel@driverdev.osuosl.org, Gulsah Kose <gulsah.1004@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org,
	Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
	Martin Kaiser <martin@kaiser.cx>, linux-media@vger.kernel.org,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog: Fix for possible null pointer dereference
In-Reply-To: Your message of "Fri, 30 Jan 2015 16:00:02 +0300."
             <20150130130001.GZ6456@mwanda>
From: Valdis.Kletnieks@vt.edu
References: <1422557288-3617-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <21497.1422569560@turing-police.cc.vt.edu>
            <20150130130001.GZ6456@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1422623364_1906P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Jan 2015 08:09:24 -0500
Message-ID: <32395.1422623364@turing-police.cc.vt.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--==_Exmh_1422623364_1906P
Content-Type: text/plain; charset=us-ascii

On Fri, 30 Jan 2015 16:00:02 +0300, Dan Carpenter said:

> > > -	if (ir == NULL) {
> > > -		dev_err(ir->l.dev, "close: no private_data attached to the file
!\n");
> >
> > Yes, the dev_err() call is an obvious thinko.
> >
> > However, I'm not sure whether removing it entirely is right either.  If
> > there *should* be a struct IR * passed there, maybe some other printk()
> > should be issued, or even a WARN_ON(!ir), or something?
>
> We set filep->private_data to non-NULL in open() so I don't think it can
> be NULL here.

Then probably the *right* fix is to remove the *entire* if statement, as
we can't end up doing the 'return -ENODEV'....

--==_Exmh_1422623364_1906P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVMuChAdmEQWDXROgAQLlFA/9EjTHM5w7jzsl683BZuipm+9dzLp4uqHG
Gsgu1qgvEcl4Gwqw2lCP6hA42+MUucBWoUjSosoKKav7UzUn+MQcoLKRouaf7ClZ
ntsldkADMuXQvIdPion2ZTbDKUgtYkvrY1QidcBGtdd0DKy4B5J8Sgkr7UJ4n+jC
T37KG/u1ZEoS+AvcJ0F1sDSB/ApwLI7jIjBL5CA4b6e03q3wASTPJad29pc6Z37f
Ttal/OO+WpHLckdXIIf64443WAeWVEJCkDGUZgYzWwCbqUrVhvrbXRwUtEOARhRw
WowZ2YmYRBRaptExgYMJ6IbsGUsiUoYNS/Kj/TVzKDgHv68mYYOtGLb1smmSkRak
ZvbYEu98XwgsNAHVR+WDXEEpopGvQjkZDKjlENckIWDL/GvovNlj5Qj1knC0tEU6
cg0HL+n4BuDC6j+vNOnXXFdWZzhah/JCy9MbGWOliBobvfAVGgsaP5vOCllObu48
qe4cx+I4M9g11oPg7sRBq//R5IwUZMTvsVxbxk3GbLcRYH8Drv3FOWK5KHzOO3Z8
T91aT2WFE3uq48zog7R17yMZ5cKAIezROZ6dk9foJJ4VHsjL82I6Ujoj3890SYpJ
SWbyOqSMVEaQDbK2Wb6C6Ep4FeZdacPH31vlGpsSvSiTh56o6HWeu8No7YZe5DQf
U4sg8GZ6kWA=
=BgYl
-----END PGP SIGNATURE-----

--==_Exmh_1422623364_1906P--
