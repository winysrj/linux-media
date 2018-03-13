Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:37817 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbeCMJ0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 05:26:37 -0400
Date: Tue, 13 Mar 2018 10:26:32 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v8 13/13] [media] v4l: Document explicit synchronization
 behavior
Message-ID: <20180313092632.GF12967@w540>
References: <20180309174920.22373-1-gustavo@padovan.org>
 <20180309174920.22373-14-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VuQYccsttdhdIfIP"
Content-Disposition: inline
In-Reply-To: <20180309174920.22373-14-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VuQYccsttdhdIfIP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Gustavo,
  a very small comment below

On Fri, Mar 09, 2018 at 02:49:20PM -0300, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>
> Add section to VIDIOC_QBUF and VIDIOC_QUERY_BUF about it
>
> v6:	- Close some gaps in the docs (Hans)
>
> v5:
> 	- Remove V4L2_CAP_ORDERED
> 	- Add doc about V4L2_FMT_FLAG_UNORDERED
>
> v4:
> 	- Document ordering behavior for in-fences
> 	- Document V4L2_CAP_ORDERED capability
> 	- Remove doc about OUT_FENCE event
> 	- Document immediate return of out-fence in QBUF
>
> v3:
> 	- make the out_fence refer to the current buffer (Hans)
> 	- Note what happens when the IN_FENCE is not set (Hans)
>
> v2:
> 	- mention that fences are files (Hans)
> 	- rework for the new API
>
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst     | 55 +++++++++++++++++++++++-
>  Documentation/media/uapi/v4l/vidioc-querybuf.rst | 12 ++++--
>  2 files changed, 63 insertions(+), 4 deletions(-)
>
[snip]
> +Note the the same `fence_fd` field is used for both sending the in-fence as
> +input argument to receive the out-fence as a return argument. A buffer can
> +have both in-fence ond out-fence.

I feel like an "and" is missing here...

 the same `fence_fd` field is used for both sending the in-fence as
 input argument to receive the out-fence as a return argument

 the same `fence_fd` field is used for both sending the in-fence as
 input argument *and* to receive the out-fence as a return argument

I'm not a native speaker so I might be wrong though.

Thanks
   j

--VuQYccsttdhdIfIP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJap5lIAAoJEHI0Bo8WoVY8xT4P/RG+sYHMAf/nQNc77TrbStah
ygnQaJog6ZR9gSuwhWnTGvqRH4yBgyO68JDmM2aFglz0IILEvewoZwlbrhVRQpsz
wsna/JbcfrRe6Ga3PdT0LILID4WoWfJod34v5IuP0kj/V98k5H26BGvgZPcDMP2c
tOtiyBimtEnZs3z/u54Ijjtnb3LKs+fr4SYRMIp99t7J3s4DTwRv+PlNzmaO0u//
SRkSPHWgCjAe6H0nuNmNFv9Tcwd7ryRixk8Y55IdDbuJvDevbAvxxlUsSPRm2G8z
+lWq+Y2wLPo7W9vKw0pBWVtXU9VhSjPCUHT5eQ0JCHjXVfOWSVUtToAsSsoYXXcc
MUffuLB5kAjXBvdUsYLJ86rNv4EWZfYhBtV5sYleu2mhBsik9MDgBHV8G53FHozR
f0F/gGGmbAD0zzbH1cJc4lSTve/WvY4PGUmYpG38Hc0KMJSMVdcOgPd5VLyKFJNi
y3Em8SbfRfMn9nH8beZChRWIL+ja/hmYNPaD3dl0oJnYPWpfpFUiNWIX4NMHw/82
kEAkgNdNqRye6Qvqj3bSADMnKSjwHkV9JmDk8/S/we0WaucYxzclKimbx7bq1jHg
dL+2dS447Te9VpxOpi5sOg24clnIYKFoKBLSSy3iHr2PMTMVEUcsYc8+qA5pW+wd
lFDtkbUfJ5/WlCV2lzZo
=gXy3
-----END PGP SIGNATURE-----

--VuQYccsttdhdIfIP--
