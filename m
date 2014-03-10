Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:52791 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaCJXj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:39:58 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so9299537wes.25
        for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 16:39:57 -0700 (PDT)
Date: Mon, 10 Mar 2014 23:39:53 +0000
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: Oliver Schinagl <oliver@schinagl.nl>,
	Quentin Glidic <sardemff7+linuxtv@sardemff7.net>
Cc: linux-media@vger.kernel.org
Subject: Re: dvb-apps build failure
Message-ID: <20140310233953.GA3490@lambda.dereenigne.org>
References: <52F346EA.4070100@sardemff7.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <52F346EA.4070100@sardemff7.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Thu, 06 Feb 2014 09:25:14 +0100, Quentin Glidic wrote:
> Hello,
>
> When building dvb-apps from the Mercurial repository, you hit the=20
> following error:
> install: cannot stat 'atsc/*': No such file or directory
>
> In the latest changeset=20
> (http://linuxtv.org/hg/dvb-apps/rev/d40083fff895) scan files were=20
> deleted from the repository but not their install rule.
>
> Could someone please remove the bottom part of util/scan/Makefile (from=
=20
> line 31,=20
> http://linuxtv.org/hg/dvb-apps/file/d40083fff895/util/scan/Makefile#l31)=
=20
> to fix this issue?

Ping on Quentin's behalf. I'd like to upload a new version of dvb-apps
to Debian, but the build is currently broken after your recent patch.

Would you be able to take a look?

Thanks,
Jon

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Signed by Jonathan McCrohan

iQIcBAABCAAGBQJTHk1JAAoJEBVu7Ac3rTKWBkgQAIr4rak7RAQDYq/Uk5pbn7iM
lruQ1D+YAiUtw79WKQ99hMziFyysSYmgigZeAh3oE+e1q56Sxe58NfFD7TmQdeH/
PO2/Ckru45N8QnU7NzLqYoQ8b6YGGMX2T1kQ9wxLRkTBviChHQFnL9oaIa+yeLPx
36nm7Y/X9HpQ6yP8cyQIV98SvkZp3ymikEWLImy85yliBBFRlghADDvPjw2qT8Ha
lQW1iOgI5Ct3Ma+09vhK++64ZcWXmeKj4HLKGXBuZDPv3irqLeCoYXs+A101OxHt
Ju3dWQ9+pNTMDSbB5sulQmZ2ti2EW2wxbBEpQhjhG5SA2bjoAYwRVqgN68powkt4
Luy6Lf3ishVz0gg5x6122RWzcAWjOj/Fm7dXPzd9csxZZ7hY0wMRvaSoD11wcMaM
tPGjAbfiXBX5SpDuoiR4O6HHg8ZvHcmJ4J/B1ZRTm6090zIIUKFmSTArEqB2X808
91PGb1PZ2o5o17QY+QahIAyqtJsGsBXvxPxXaOFOVOZUFi73R5kA/4LLCoV93JVa
qpJjfWa9a8YITlO3/PTvpzhjeC6tlkjaJ0zNIJIwIXuBfzUStjpbPDnLIFWnTAaG
p4/cnzplrQdltCpTB7a/Usc90VQFYkuylxdPQTf3OZf2FG+Z/vKkPAAIo4qFtVhP
ShN6L6H5Q0tamLzVeiIp
=fFfT
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
