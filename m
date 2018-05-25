Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:57689 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934393AbeEYHMN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 03:12:13 -0400
Date: Fri, 25 May 2018 09:12:05 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Tomasz Figa <tfiga@google.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        bingbu.cao@linux.intel.com, tian.shu.qiu@linux.intel.com,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v3] media: imx319: Add imx319 camera sensor driver
Message-ID: <20180525071205.GH18369@w540>
References: <1526886658-14417-1-git-send-email-bingbu.cao@intel.com>
 <1526963581-28655-1-git-send-email-bingbu.cao@intel.com>
 <20180522200848.GB15035@w540>
 <20180523073833.onxqj72hi23qkz42@paasikivi.fi.intel.com>
 <20180524200738.GD18369@w540>
 <20180524204733.s2ijd3t2izztvjnv@kekkonen.localdomain>
 <CAAFQd5CtOkGmGsixJg1XO-stwY=+DSGdQhR28SieHN-vHfPY9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W2ydbIOJmkm74tJ2"
Content-Disposition: inline
In-Reply-To: <CAAFQd5CtOkGmGsixJg1XO-stwY=+DSGdQhR28SieHN-vHfPY9g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--W2ydbIOJmkm74tJ2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Tomasz,

On Fri, May 25, 2018 at 03:18:38PM +0900, Tomasz Figa wrote:
> On Fri, May 25, 2018 at 5:47 AM Sakari Ailus <sakari.ailus@linux.intel.com>
> wrote:
>
> > Hi Jacopo,
>
> > On Thu, May 24, 2018 at 10:07:38PM +0200, jacopo mondi wrote:
> > ...
> > > > > about that, but I wonder why setting controls should be enabled only
> > > > > when streaming. I would have expected runtime_pm_get/put in
> subdevices
> > > > > node open/close functions not only when streaming. Am I missing
> something?
> > > >
> > > > You can do it either way. If powering on the sensor takes a long
> time, then
> > > > doing that in the open callback may be helpful as the user space has
> a way
> > > > to keep the device powered.
> > >
> > > Ok, so I assume my comment could be ignored, assuming is fine not
> > > being able to set control if the sensor is not streaming. Is it?
>
> > I'd say so. From the user's point of view, the sensor doesn't really do
> > anything when it's in software standby mode.
>
> Just to make sure we're on the same page, the code actually does nothing
> when the sensor is not in streaming mode (i.e. powered off). When stream is
> being started, the V4L2 control framework will call s_ctrl for all the
> controls in the handler to synchronize hardware state and this is when all
> the controls set before powering on will actually be programmed into the
> hardware registers.

Thanks, I had missed that part.

I quickly tried searching for 's_ctrl' calls in the v4l2-core/ code
and I've found nothing that invokes that in response to a streaming
start operation. Just if you happen to have any reference handy, could
you please point me to that part, just for my better understanding?

Thanks
   j

>
> Best regards,
> Tomasz

--W2ydbIOJmkm74tJ2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbB7dFAAoJEHI0Bo8WoVY8WxAP/j4/AdFGFETfdV4rYJpt19jH
tSfT+eufS7CeDPu3WanDVS2c4uoVHJasBc2lXrTzu/zU80fcCs0z5enOzJGzoaqq
txNs28VSx90XnlSPFMpBIOPXqRFWyH0bVyEz5eE9WHOOg37ZVyb3jin/7+DBeYLk
nOUmko0S0zK8b+91bF/gTq1iB8aKx0y/0qCZnZnyloMAQQT1yn6n8zJD5lJZOE1Z
WpkEhdaM2CAaF+R8MYMYqNhbEWgETOVBkVVoNkTYXWdE0GBZco3E2HMXjqimjFfI
7KbyRnbxND4gb0DBI0z9MJM/hGJB2kP7U5mVos8NwJsObNKzHTuW1dvwbPEMnJqh
v9BjcEiR1e/y1TFdXmeH2N5HVHeCrN4Aeu0StGAsG7hwUFAYKbLnfrgtE/KsOMHE
b4r7FOogFHtZPYuLwi9BARKNHooYCzhBMhs6jJxu6Ul4VFjIQxvDbfm6U225kZvH
YpGGNYf1tMa/X/CggbziusihxkuaDPbqGCAxCjOsQNUoKLJlNn6etd4SlmLS9elu
Xwj+a24QVXIpEu1qM2z/80xEuuilxjCI0qcABP5rzIVJ8MD2VpsCO3JLLMu42QsB
AvbCqeXxpPAVe1E//HU8nkL5Aj5JfOi9y4vFJecw/Tr0lIMDqdT+zLjrfivZf12b
k9AYiZ255M9C9NFkTuUY
=BqoC
-----END PGP SIGNATURE-----

--W2ydbIOJmkm74tJ2--
