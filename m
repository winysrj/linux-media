Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbbGTSIT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 14:08:19 -0400
Subject: Re: [RESEND PATCH v2 1/2] x86/mm/pat, drivers/infiniband/ipath: replace WARN() with pr_warn()
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_0C699670-D12C-465D-8B38-FB7FE5EA8E1E"; protocol="application/pgp-signature"; micalg=pgp-sha512
From: Doug Ledford <dledford@redhat.com>
In-Reply-To: <1437167245-28273-2-git-send-email-mcgrof@do-not-panic.com>
Date: Mon, 20 Jul 2015 14:08:21 -0400
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@suse.de>,
	andy@silverblocksystems.net,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	dan.j.williams@intel.com, benh@kernel.crashing.org,
	luto <luto@amacapital.net>, Julia Lawall <julia.lawall@lip6.fr>,
	Jiri Kosina <jkosina@suse.cz>,
	linux-media <linux-media@vger.kernel.org>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Message-Id: <9F0E52A4-A8E9-4308-B4DC-A10AA7637915@redhat.com>
References: <1437167245-28273-1-git-send-email-mcgrof@do-not-panic.com> <1437167245-28273-2-git-send-email-mcgrof@do-not-panic.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail=_0C699670-D12C-465D-8B38-FB7FE5EA8E1E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jul 17, 2015, at 5:07 PM, Luis R. Rodriguez =
<mcgrof@do-not-panic.com> wrote:
>=20
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>=20
> WARN() may confuse users, fix that. ipath_init_one() is part the
> device's probe so this would only be triggered if a corresponding
> device was found.
>=20
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Acked-by: Doug Ledford <dledford@redhat.com>

=E2=80=94
Doug Ledford <dledford@redhat.com>
	GPG Key ID: 0E572FDD






--Apple-Mail=_0C699670-D12C-465D-8B38-FB7FE5EA8E1E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVrTkWAAoJELgmozMOVy/dPMEP/jYkT46rdwL0nSuMdzf7QWoG
6gl6k0xZcT8KUoklQGh5W6CEDwzXa1zt1G2HiEr/mUM1sQhW5iGCRpekdsQ0Hr5J
z0kXbDS7JDaV8yDBheK2HiJkJbdDOeW7zjfIcbFlbNuFWdAB0eRie5WeXJyTyTn7
p7qH+yypZo8ejLMds9iokrX1JbQfFB2H/NPRrxRdntqXVLckXW6Nk715pGRVeweQ
B1J9N8Ix2sc7eGLs15SgJ1JOtPAzcgOH3Q0xFYlbw5TI+bO9XyTSEmHmyF2kzTFM
hw27q3p6jXdS2V8LSjTAE0JAETwgse02r16LtJ6OdMsErfJ1zLLJEEmCE9csejC6
zLy3QFVJ+Ihh7mz+wmZHduUeuAT5L4yf0MdMy3Pz4QhJTJWyBUT8K9csGIuu/5Hv
g9kZxVtUx7bcbKDA+mP/8zmdZQWdEsBhpBzTIaB0ljfaGv33hSb5ihrrUNBquQ4u
SKYBjcrb3XUt2iprflUf/QbXLOMTFROKCjaLIeaSdb6cpwGqilz2ENj2c+ZcCPAo
359S13Qg+GLp6647sFi//Lc5WpuEaqUikRfgQ5TWyQanC5yO9ZUrjsd3We0+PLCI
YbQ3aWE5H++0UXkeXvs5atxzCV1zE4oq8M0p+T5D/OVzSbAxlpmWTzhke78C9aYs
/6GiQ/BAB9WP4iI+0ucD
=QXLd
-----END PGP SIGNATURE-----

--Apple-Mail=_0C699670-D12C-465D-8B38-FB7FE5EA8E1E--
