Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:37073 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754684AbdBQDlQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 22:41:16 -0500
Received: by mail-it0-f47.google.com with SMTP id x75so3878984itb.0
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 19:41:16 -0800 (PST)
Message-ID: <1487302872.30491.14.camel@ndufresne.ca>
Subject: Re: [PATCH 00/15] Exynos MFC v6+ - remove the need for the reserved
 memory
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Date: Thu, 16 Feb 2017 22:41:12 -0500
In-Reply-To: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170214075214eucas1p1574c18c0fa166cdda50838b9fb8cc23b@eucas1p1.samsung.com>
         <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-U0+Apvyp9/CufRjo3PSw"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-U0+Apvyp9/CufRjo3PSw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 14 f=C3=A9vrier 2017 =C3=A0 08:51 +0100, Marek Szyprowski a =C3=A9=
crit=C2=A0:
> Dear All,
>=20
> This patchset is a result of my work on enabling full support for MFC dev=
ice
> (multimedia codec) on Exynos 5433 on ARM64 architecture. Initially I thou=
ght
> that to let it working on ARM64 architecture with IOMMU, I would need to
> solve the issue related to the fact that s5p-mfc driver was depending on =
the
> first-fit allocation method in the DMA-mapping / IOMMU glue code (ARM64 u=
se
> different algorithm). It turned out, that there is a much simpler way.
>=20
> During my research I found that some of the requirements for the memory
> buffers for MFC v6+ devices were blindly copied from the previous
> hardware (v5) version and simply turned out to be excessive. It turned ou=
t
> that there is no strict requirement for ALL buffers to be allocated on
> the higher addresses than the firmware base. This requirement is true onl=
y
> for the device and per-context buffers. All video data buffers can be
> allocated anywhere for all MFC v6+ versions. This heavily simplifies
> memory management in the driver.
>=20
> Such relaxed requirements for the memory buffers can be easily fulfilled
> by allocating firmware, device and per-context buffers from the probe-tim=
e
> preallocated larger buffer. There is no need to create special reserved
> memory regions. The only case, when those memory regions are needed is an
> oldest Exynos series - Exynos4210 or Exyno4412, which both have MFC v5
> hardware, and only when IOMMU is disabled.
>=20
> This patchset has been tested on Odroid U3 (Exynos4412 with MFC v5), Goog=
le
> Snow (Exynos5250 with MFC v6), Odroid XU3 (Exynos5422 with MFC v8) and
> TM2 (Exynos5433 with MFC v8, ARM64) boards.
>=20
> To get it working on TM2/Exynos5433 with IOMMU enabled, the 'architectura=
l
> clock gating' in SYSMMU has to be disabled. Fixing this will be handled
> separately. As a temporary solution, one need to clear CFG_ACGEN bit in
> REG_MMU_CFG of the SYSMMU, see __sysmmu_init_config function in
> drivers/iommu/exynos-iommu.c.
>=20
> Patches are based on linux-next from 9th February 2017 with "media:
> s5p-mfc: Fix initialization of internal structures" patch applied:
> https://patchwork.linuxtv.org/patch/39198/
>=20
> I've tried to split changes into small pieces to make it easier to review
> the code. I've also did a bit of cleanup while touching the driver.
>=20
> Best regards
> Marek Szyprowski
> Samsung R&D Institute Poland
>=20
>=20
> Patch summary:
>=20
> Marek Szyprowski (15):
> =C2=A0 media: s5p-mfc: Remove unused structures and dead code
> =C2=A0 media: s5p-mfc: Use generic of_device_get_match_data helper
> =C2=A0 media: s5p-mfc: Replace mem_dev_* entries with an array
> =C2=A0 media: s5p-mfc: Replace bank1/bank2 entries with an array
> =C2=A0 media: s5p-mfc: Simplify alloc/release private buffer functions
> =C2=A0 media: s5p-mfc: Move setting DMA max segmetn size to DMA configure
> =C2=A0=C2=A0=C2=A0=C2=A0function

Just notice this small typo "segmetn", associated patch will need
update too.

> =C2=A0 media: s5p-mfc: Put firmware to private buffer structure
> =C2=A0 media: s5p-mfc: Move firmware allocation to DMA configure function
> =C2=A0 media: s5p-mfc: Allocate firmware with internal private buffer all=
oc
> =C2=A0=C2=A0=C2=A0=C2=A0function
> =C2=A0 media: s5p-mfc: Reduce firmware buffer size for MFC v6+ variants
> =C2=A0 media: s5p-mfc: Split variant DMA memory configuration into separa=
te
> =C2=A0=C2=A0=C2=A0=C2=A0functions
> =C2=A0 media: s5p-mfc: Add support for probe-time preallocated block base=
d
> =C2=A0=C2=A0=C2=A0=C2=A0allocator
> =C2=A0 media: s5p-mfc: Remove special configuration of IOMMU domain
> =C2=A0 media: s5p-mfc: Use preallocated block allocator always for MFC v6=
+
> =C2=A0 ARM: dts: exynos: Remove MFC reserved buffers
>=20
> =C2=A0.../devicetree/bindings/media/s5p-mfc.txt=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
> =C2=A0arch/arm/boot/dts/exynos5250-arndale.dts=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 -
> =C2=A0arch/arm/boot/dts/exynos5250-smdk5250.dts=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 -
> =C2=A0arch/arm/boot/dts/exynos5250-spring.dts=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 -
> =C2=A0arch/arm/boot/dts/exynos5420-arndale-octa.dts=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 -
> =C2=A0arch/arm/boot/dts/exynos5420-peach-pit.dts=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 -
> =C2=A0arch/arm/boot/dts/exynos5420-smdk5420.dts=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 -
> =C2=A0arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |=C2=A0=C2=A0=C2=
=A01 -
> =C2=A0arch/arm/boot/dts/exynos5800-peach-pi.dts=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 -
> =C2=A0drivers/media/platform/s5p-mfc/regs-mfc-v6.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/media/platform/s5p-mfc/regs-mfc-v7.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/media/platform/s5p-mfc/regs-mfc-v8.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 210 +++++++++++++--------
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_common.h=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A043 ++---
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A071 +++----
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 -
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_dec.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A08 +-
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_enc.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A010 +-
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A051 +----
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_opr.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A065 +++++--
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_opr.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A08 +-
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A048 ++---
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A014 +-
> =C2=A024 files changed, 264 insertions(+), 283 deletions(-)
>=20
--=-U0+Apvyp9/CufRjo3PSw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlimcNgACgkQcVMCLawGqBwAwACgtvSnmGzYfCXaS8BPri+ZWVfz
WDYAoIc0v9FgdrysEyEA7JoHxQXHJb+e
=6tHD
-----END PGP SIGNATURE-----

--=-U0+Apvyp9/CufRjo3PSw--
