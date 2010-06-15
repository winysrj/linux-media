Return-path: <linux-media-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:34368 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0FOAN6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 20:13:58 -0400
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but not used
In-Reply-To: Your message of "Mon, 14 Jun 2010 13:26:44 PDT."
             <1276547208-26569-5-git-send-email-justinmattock@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
            <1276547208-26569-5-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1276560832_4535P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jun 2010 20:13:52 -0400
Message-ID: <21331.1276560832@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--==_Exmh_1276560832_4535P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Jun 2010 13:26:44 PDT, "Justin P. Mattock" said:
> Im getting this warning when compiling:
>  CC      drivers/char/tpm/tpm.o
> drivers/char/tpm/tpm.c: In function 'tpm_gen_interrupt':
> drivers/char/tpm/tpm.c:508:10: warning: variable 'rc' set but not used
> 
> The below patch gets rid of the warning,
> but I'm not sure if it's the best solution.

>  	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>  			"attempting to determine the timeouts");
> +	if (!rc)
> +		rc = 0;
>  }

Good thing that's a void function. ;)

Unless transmit_cmd() is marked 'must_check', maybe losing the 'rc =' would
be a better solution?

--==_Exmh_1276560832_4535P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMFsW/cC3lWbTT17ARAozXAKDUzsPJ5qGjLthg1WUw+ja58I+MOwCfeVvx
zBQCgslSY2ar/mPFtJHVUAA=
=j1Q9
-----END PGP SIGNATURE-----

--==_Exmh_1276560832_4535P--

