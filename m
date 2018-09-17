Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40559 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbeIQNNg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 09:13:36 -0400
Date: Mon, 17 Sep 2018 09:47:19 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: hugues.fruchet@st.com, Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v3 0/5] Fix OV5640 exposure & gain
Message-ID: <20180917074505.GE16851@w540>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
 <20180914160712.GD16851@w540>
 <20180915230229.ivldwawzwignkbxv@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9ADF8FXzFeE7X4jE"
Content-Disposition: inline
In-Reply-To: <20180915230229.ivldwawzwignkbxv@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9ADF8FXzFeE7X4jE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,
        thanks for handling this

On Sun, Sep 16, 2018 at 02:02:30AM +0300, Sakari Ailus wrote:
> Hi Jacopo, Hugues,
>
> On Fri, Sep 14, 2018 at 06:07:12PM +0200, jacopo mondi wrote:
> > Hi Sakari,
> >
> > On Tue, Sep 11, 2018 at 03:48:16PM +0200, Hugues Fruchet wrote:
> > > This patch serie fixes some problems around exposure & gain in OV5640 driver.
> >
> > As you offered to collect this series and my CSI-2 fixes I have just
> > re-sent, you might be interested in this branch:
> >
> > git://jmondi.org/linux
> > engicam-imx6q/media-master/ov5640/csi2_init_v4_exposure_v3
> >
> > I have there re-based this series on top of mine, which is in turn
> > based on latest media master, where this series do not apply as-is
> > afaict.
> >
> > I have added to Hugues' patches my reviewed-by and tested-by tags.
> > If you prefer to I can send you a pull request, or if you want to have
> > a chance to review the whole patch list please refer to the above
> > branch.
> >
> > Let me know if I can help speeding up the inclusion of these two
> > series as they fix two real issues of MIPI CSI-2 capture operations
> > for this sensor.
>
> I've pushed the patches here:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.20-5>
>
> There was a merge commit and a few extra patches in your tree; I threw them
> out. :-)

Yeah, those are a few patches I need for my testing platform... Forgot to
remove them, hope you didn't spend too much time on this.
>
> I also edited the commit messages slightly (format; no change in content)
> --- the patches are as-is. I'll still check they look right before sending
> a pull request, likely on Monday.

Thanks, let me now if I can help.
Cheers
   j

>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--9ADF8FXzFeE7X4jE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbn1wHAAoJEHI0Bo8WoVY8T8gQAK8vAR+U+GHl/uQ0HHkn7EDW
O74a9eiKJRJ5IOIcF0c+9FWVIO+1sQ5kwzcAa70ZmXHFNtNmYvTU+PXQUy0xBqDc
RnXTBEG1MPGimMYb3sxqHgJBh1XcKQ8A3jJd3XtxeLYs4h6bvhBkI1iqAvkd875C
vBuwY8hsIobG1nFMT/wgXh1W/NY9mMEXPidEXYzrN0MRIwrZ6M6TbjUE6wCWG88/
Ug+thXR1uDAKJgI08GyeRcqZ40NYh0Qthrmax07h3lq+CgUt1b+rG7AS+syEUvmK
W/xioNHCIX+fK0P6q7B3yRen+jq7jZwXNweugD0x93tPs1JepVcR1hUb1QJ/R6XZ
mB0CiWaVhAO62dBDI7JWb7l32uAVSmj1LYYBrjGDMxfZJN8LavC87lBeQzZtfZly
2WlLyHvb+kU8lpbN1zg/L/NVkti/puTY1dRoveKJ7TCMDHgNk23sRELWgnrhLQ/P
pJAoEE01gwOvixFWkyjOsHYi/m2sjjoHVk+oUe/gKs2RGc86zfmMnWCBkZdRuSxZ
aRerV5I0A1fTLbV8Axfq7EcC2pF8XXmWzetIoDH+8IJ5SYBZ0Y77wPx0kj0sDhvO
z6GEEQH2fgTH14joQkMuwUNGYmEzylgLUXLquC1RYFOboB7dDuhEo//fl0lNcXEq
DcudBhHeXkE+rOyORYwc
=6FiA
-----END PGP SIGNATURE-----

--9ADF8FXzFeE7X4jE--
