Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr1.cc.vt.edu ([198.82.141.52]:37661 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbbA2WNk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 17:13:40 -0500
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Gulsah Kose <gulsah.1004@gmail.com>,
	Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
	Martin Kaiser <martin@kaiser.cx>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog: Fix for possible null pointer dereference
In-Reply-To: Your message of "Thu, 29 Jan 2015 19:48:08 +0100."
             <1422557288-3617-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
From: Valdis.Kletnieks@vt.edu
References: <1422557288-3617-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1422569560_1905P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Jan 2015 17:12:40 -0500
Message-ID: <21497.1422569560@turing-police.cc.vt.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--==_Exmh_1422569560_1905P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Jan 2015 19:48:08 +0100, Rickard Strandqvist said:
> Fix a possible null pointer dereference, there is
> otherwise a risk of a possible null pointer dereference.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/media/lirc/lirc_zilog.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

>  	/* find our IR struct */
>  	struct IR *ir = filep->private_data;
>
> -	if (ir == NULL) {
> -		dev_err(ir->l.dev, "close: no private_data attached to the file!\n");

Yes, the dev_err() call is an obvious thinko.

However, I'm not sure whether removing it entirely is right either.  If
there *should* be a struct IR * passed there, maybe some other printk()
should be issued, or even a WARN_ON(!ir), or something?

--==_Exmh_1422569560_1905P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVMqwVwdmEQWDXROgAQJF6xAAk4DDwh0o3LvfmaI+rLDYmhq4WgJDxH34
92A/502Xwy3JI5hUc95JqKN/TEUompBMdqTd59RSwef7u1pzcJop9dcucBOjmsFs
HifPjUyi/ailTUSv0Q/h38s2UUOFygGsMR0ePxQhye5klegiUlEeyjp0mYEpK9pH
phIPwbqLJaXmU7WK6Teifzl31UD8EeYcTs/IjYeIuFOenaDkp1L0GPEp0KdVvvxc
pgFnOkxvYKPKgxKhdgOclZE0p4ppjU7bQuXjvMvg8VoRqctKK5i4zZ3kXVzByaPJ
3XPwlPTadvkn8BtIS2TGy7eSecJ2we5R1FHJAtt+3JmgifSGrA/9KQbL1DrRRJdF
VBQ2PaJxVn+ghbsM9/+XUYPAQCUam1ccsmAZE6VriRkCufGe3/s7zDtavoDJUJ3n
hudimChfjQTxnAhu40dwZ2b6kesQOffWGKWTWDPBiAZb1mq1/4pYRSOwc7fKPJ6Y
cVS1I//OR+dPnPaFmaNf2ikdQ9WFhPXOidcdkGZxY3yHVAIUC8xQsZnrxtHQgk1V
ZogNwZ27WlF38uJEYI/9oxSTcs49AYmvZOlr7Fe7/TiOPqbrVTa8wGbKZ+bmMNK4
MxOvNuWVoqgugNfAYbqOXbKgkLScCey0oo0zfPEhlukfoH4qqu7Ftwqa3DPTrgJq
SmX9TpHVmIU=
=DXw2
-----END PGP SIGNATURE-----

--==_Exmh_1422569560_1905P--
