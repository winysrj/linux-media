Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:15865 "EHLO
        imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932706AbcLMLbN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 06:31:13 -0500
Date: Tue, 13 Dec 2016 11:31:10 +0000
From: James Hogan <james.hogan@imgtec.com>
To: Sean Young <sean@mess.org>
CC: <linux-media@vger.kernel.org>, Sifan Naeem <sifan.naeem@imgtec.com>
Subject: Re: [PATCH v5 02/18] [media] img-ir: use new wakeup_protocols sysfs
 mechanism
Message-ID: <20161213113110.GF30099@jhogan-linux.le.imgtec.org>
References: <cover.1481575826.git.sean@mess.org>
 <074994409ca834b6fcd950e7da60456247f12ce5.1481575826.git.sean@mess.org>
 <20161212223115.GB30099@jhogan-linux.le.imgtec.org>
 <20161213075416.GA27738@gofer.mess.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i3lJ51RuaGWuFYNw"
Content-Disposition: inline
In-Reply-To: <20161213075416.GA27738@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--i3lJ51RuaGWuFYNw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sean,

On Tue, Dec 13, 2016 at 07:54:16AM +0000, Sean Young wrote:
> So that leaves the question open of whether we want to guess the protocol
> variant from the scancode for img-ir or if we can live with having to
> select this using wakeup_protocols. Having to do this does solve the issue
> of the driver guessing the wrong protocol if the higher bits happen to be
> 0 in the scancode.

I've received confirmation that pistachio doesn't yet support suspend in
mainline, in which case there can never be any real users of the old
semantics on current/old mainline kernel versions. So I'm fine with it
changing.

Cheers
James

--i3lJ51RuaGWuFYNw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYT9v+AAoJEGwLaZPeOHZ6ZcEQAJltwJPm1A48pDZGyOljGLUc
Q4FjwWgjC4C/oogE/xLdZADGrDO5QUXGGJp+B54HsJkKHei6q5KK4oHyziJsewHj
RQZOSbhZ4wyG/5lKMuJjhbUea1nbzCAWMzwf2jiTbHdA6JAYHUF9nc5ej9kkeHc4
EXfMid+g0nKUGLluX6a3a3dFr3aM5PxHoYhSkAzLHxAUY6qmDK3w6jggyIzV0Mb3
i1plvsUqWOxxUPIpuhHCznF7PEtbRYUhxhjV3KC6OsDxYsWS0C/31x2bnLsjyRit
OxXcc8C1gI4XMczUtthrDivMUYnn/pt6RzAqd1Pc9WpLeuZDhxf4T0MyoY+HjmH9
C7aJH6/IHivfqOyxLtkswIbbSF/RRYiko268L48sphwYKr14Ph0T704vCBJiAsEx
YWaiEjqwk+wkFzm8FSBSqGEo1g71B5mruvb852iwwmmrNg2Qhx+0wEUwf+SNEm3B
WurPMOrIgeFKzjZAkklx0FXRslzeprijH1KMS1cZ/QCauloaF7hKoMeshJsiTAfN
6pT8BiLuKIJtqlfVgV53D+saIX2Y77JpTwCPF9P71LJ9yFvJbIacPKFWT+lNFuZd
IKKcewG13pVPdvPbJkwjLW+qK1r1eKjdlD7Qvr2Ky5709zS4CnVHXPlg7zR3S9/a
+eoQUxM6TdAXUXLZuNlW
=hpdO
-----END PGP SIGNATURE-----

--i3lJ51RuaGWuFYNw--
