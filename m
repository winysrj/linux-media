Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:36726 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbeBFI3A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 03:29:00 -0500
Date: Tue, 6 Feb 2018 09:28:56 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing
 with a mask
Message-ID: <20180206082856.qx4pj7of36yytetc@ninjato>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
 <CAMuHMdWnV17DCxr71k6n3w+5jPtQmeuPugr58xadq9U_qchJnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i7fjmlnpcylye3br"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWnV17DCxr71k6n3w+5jPtQmeuPugr58xadq9U_qchJnQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--i7fjmlnpcylye3br
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I found two more using "git grep 'define.*0x[0-9a-f]* < '":

I added '[0-9]\+' at the end of the regex to reduce the number of false
positives...

> drivers/net/can/m_can/m_can.c:#define RXFC_FWM_MASK     (0x7f < RXFC_FWM_SHIFT)
> drivers/usb/gadget/udc/goku_udc.h:#define INT_EPnNAK(n)
> (0x00100 < (n))         /* 0 < n < 4 */

... but you found those two true positives in there. Nice, thanks!


--i7fjmlnpcylye3br
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlp5Z0QACgkQFA3kzBSg
KbbYSA//brJm3Wk+jt6LxTyCknABbUX/AufrL2WXLokJ0ZmBYFIXcLww7cpJsl87
xpIkpfJmefWYgLTI3pqDWKZmAFKSV3r4auXeGTfGcZs+TceknU4GubxM75Swq0v9
1hXwREddK/RO5nnpfIER8oubrmZgCmHF6Z9ZrLOAOvXDaIbsxkLDnVXtxi3Xkii3
JvQ6tEer53ghJsLUj+PFN28yxgcBbQScisgr0Help/yEld++jf9nyAf02Ktccn9D
HPpXfqOrIgE9XYplI4dl0dDUYM6wV7yOPvj4cQSTDRLX2Qf1iZ9sNVdkAAXFRSia
9YlmKE9+Zc0rcCrIjkbmFz+RDwYiT1/2UmxjPUvvPJskXqbdw6DBYEkcEqs/Xy7G
Api/nktPfnbyT2f17k7kTWKh5YK5ZQfuf4WGTC/Nf54a2k8lASZrFyMqigxq1YXA
DW5ypA/mqS+jZTi9R8FaZNz+oVn5HCMts2aDrATJ7+u2RaqzlN+rHk2qoa7AVEQW
4pRelcKxktnxIQWr1N/KH7EX4ktREprBRPAQH6O6CG/pIO+t9uILs0+ba21tt/Uf
fFgoM+xBO/SO9R43kcYKq5uNs57KYI/Y9qyMln4ae4MmsDDRx3XM/6EoSJa5Q+Yu
bpSI8U7C1v1elUOudk8RqPy7eWn2x7ufHBApRBkFZNvsqb/4CzY=
=7Gs7
-----END PGP SIGNATURE-----

--i7fjmlnpcylye3br--
