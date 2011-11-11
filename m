Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50164 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1KKRng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 12:43:36 -0500
Received: by eye27 with SMTP id 27so3587661eye.19
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 09:43:34 -0800 (PST)
Date: Fri, 11 Nov 2011 18:43:04 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: PATCH: Query DVB frontend capabilities
In-Reply-To: <4EBC402E.20208@redhat.com>
Message-ID: <alpine.DEB.2.01.1111111759060.6676@localhost.localdomain>
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


On Do (Donnerstag) 10.Nov (November) 2011, 22:20,  Mauro Carvalho Chehab wrote:

> We should also think on a way to enumerate the supported values for each DVB $
> the enum fe_caps is not enough anymore to store everything. It currently has $
> filled (of a total of 32 bits), and we currently have:
> 	12 code rates (including AUTO/NONE);

I'm probably not looking at the correct source, but the numbers
seem to match, so I'll just note that in what I'm looking at,
there are missing the values  1/3  and  2/5 .

But I have to apologise in that I've also not been paying
attention to this conversation, and haven't even been trying
to follow recent developments.


> 	13 modulation types;

Here I see missing  QAM1024  and  QAM4096 .


> 	7 transmission modes;
> 	7 bandwidths;

Apparently DVB-C2 allows us any bandwidth from 8MHz to 450MHz,
rather than the discrete values used by the other systems.
If this is also applicable to other countries with 6MHz rasters,
would it be necessary in addition to specify carrier spacing,
either 2,232kHz or 1,674kHz as opposed to getting this from the
channel bandwidth?


> 	8 guard intervals (including AUTO);

Here I observe the absence of  1/64 .


> 	5 hierarchy names;
> 	4 rolloff's (probably, we'll need to add 2 more, to distinguish between$


Of course, I'm just pointing out what I find, as I really don't
know anything about the transport systems, and someone who 
actually does might be able to say more, and correct my errors.

So just ignore me -- I'd rather see these values added sooner
than later if needed.  Apparently the broadcasts from Borups
Allé scheduled to start sometime around now will be switching
over to use those mentioned to test their increased robustness.


thanks,
barry bouwsma



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Key found at http://vax.chrillesen.dk/~barry/gpg.key
Comment: Anständige Signaturen und Verschlüsselung gibt es nur mit GNUpg
Comment: und nicht mit De-Mail.

iEYEARECAAYFAk69XqgACgkQPTWIZbDoOFfp0gCcDOxKlVrjbfGtEMLqNZ/Jkqkk
ngsAn3hoMOF5rPkqzZKD2QnDTifA2+of
=vN6k
-----END PGP SIGNATURE-----
