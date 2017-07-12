Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:39064 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbdGLSdR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 14:33:17 -0400
From: Eric Anholt <eric@anholt.net>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/4] drm/vc4: Add register defines for CEC.
In-Reply-To: <20170711112021.38525-4-hverkuil@xs4all.nl>
References: <20170711112021.38525-1-hverkuil@xs4all.nl> <20170711112021.38525-4-hverkuil@xs4all.nl>
Date: Wed, 12 Jul 2017 11:33:12 -0700
Message-ID: <87inixh5ef.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Hans Verkuil <hverkuil@xs4all.nl> writes:

> From: Eric Anholt <eric@anholt.net>
>
> Basic usage:
>
> poweron: HSM clock should be running.  Set the bit clock divider,
> set all the other _US timeouts based on bit clock rate.  Bring RX/TX
> reset up and then down.
>
> powerdown: Set RX/TX reset.
>
> interrupt: read CPU_STATUS, write bits that have been handled to
> CPU_CLEAR.
>
> Bits are added to /debug/dri/0/hdmi_regs so you can check out the
> power-on values.

Let's drop my hints to you from the commit message here :)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAllma2gACgkQtdYpNtH8
nugLxg//dgFbYVVuOxDsnwCb1Lo+X1LAajGi9ts5VBFMo6XGfRbED+x3zXYTiTIw
nVT0dRBBwiS0ze+Nm2ULLsToUQPd2jlxG9OLsLAJOUw8ovYYcpXANycjWVMONnzb
9eSXXdpB2iD6fzaAgiS1PsrFPqDNd0XV/YhLD3qE9hSGcpbVErXFXBXbPQgVr50f
s5AzuI1/gLy5stvikCy/tHvJmkd0y6bmhWqNum8PWweYfsOFI40NToUGFYGh47fB
2COy9IFuE9MY9dmh288G3ptipaQmux9nUho7Uh8qHfToY0cpSru6z3kOqzdwZMe0
y+66IM1fUNbQmkQ1BgJEcOhkZmxmy1hx5cvAAxwsU0jKn6QXXutMJ9LGO0B/NL2X
fkA9DScr/ZA/iyumzuEoEFu6DOZ0r3SJyPTM4dABTiMGHC4lBnbh4mK3vwWyKQ+6
PK9zpaf+HjFYef8VDr+xsC6VJfroWIS4/jVMefhn+dj0ShxZ8viUZQnZfPXKYtfd
IIVx9yhKHhpnD53mT4K4bm/Bjd/bTBmk52Y+7l075rLmIy94hJ/rLoHmXfK+YmDL
d20PTdxcBFGwXmZW+8C+YUh54SOTS9CW6eyvhaee4MRP6Wm61zvMWD68q0fPME9L
UFLdsEj8DrUcOE0JzUiuNNgcx7Flk37dwoN/ecbakKx0tanef40=
=x0Zb
-----END PGP SIGNATURE-----
--=-=-=--
