Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44255 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbeIMS3B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 14:29:01 -0400
Date: Thu, 13 Sep 2018 15:19:30 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3 16/23] v4l: fwnode: Initialise the V4L2 fwnode
 endpoints to zero
Message-ID: <20180913131929.GE11509@w540>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
 <20180912212942.19641-17-sakari.ailus@linux.intel.com>
 <20180913094614.GS20333@w540>
 <20180913095533.nu6yjf6swga7fa6x@paasikivi.fi.intel.com>
 <20180913101912.ee4qfkphw3zsypbi@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0QFb0wBpEddLcDHQ"
Content-Disposition: inline
In-Reply-To: <20180913101912.ee4qfkphw3zsypbi@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0QFb0wBpEddLcDHQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Thu, Sep 13, 2018 at 01:19:12PM +0300, Sakari Ailus wrote:
> On Thu, Sep 13, 2018 at 12:55:33PM +0300, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > On Thu, Sep 13, 2018 at 11:46:14AM +0200, jacopo mondi wrote:
> > > Hi Sakari,
> > >
> > > On Thu, Sep 13, 2018 at 12:29:35AM +0300, Sakari Ailus wrote:
> > > > Initialise the V4L2 fwnode endpoints to zero in all drivers using
> > > > v4l2_fwnode_endpoint_parse(). This prepares for setting default endpoint
> > > > flags as well as the bus type. Setting bus type to zero will continue to
> > > > guess the bus among the guessable set (parallel, Bt.656 and CSI-2 D-PHY).
> > > >
> > >
> > > I've played around with this patch, trying to use defaults in the
> > > renesas-ceu driver.
> > >
> > > This is the resulting patch, if you want I can send it as follow-up or
> > > send it so that you can include it in your series if it's correct):
> > > https://paste.debian.net/hidden/a7795d3e/
> >
> > Looks nice; could you send it out to the list for review?
> >
> > The bus width default isn't specified in DT bindings; could you write a
> > patch that defines it?
>
> Same for "pclk-sample". DT bindings do not document that; it should go to
> the same patch.

Actually it is 'wrong' to specify it in the default configuration in
first place, as the interface does not support configuring the pixel
clock edge on which to sample data.
Same for data-shift, as the interface supports 8 or 16 bits only
capture modes.

I'll document bus_width restricting the accepted values to 8 and 16
and field-even-active as even if they're not actually implemented in the
driver, they are configurable for the interface.

Thanks
  j
>
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com

--0QFb0wBpEddLcDHQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbmmPhAAoJEHI0Bo8WoVY8MmQP+wVYzn7rA+QCZlv/na60KCKu
9qWSE41nOchMHiLKb+oA1uO4aLf53fOpCceWJKWGAtEKMGzi1i7xft8CFAV8z+U+
q+POGF6nHnRfk2mtqLqO/X2pb4U85uB/DrUjjRN5GrRNfTmFAVjKgqfaKLHHqG7v
RLmr8MVn3M+iTrZbkbPgiThBLfKL3g9xJAjw0wtAXT5XLhJbZN/eX4liRoL6kq4i
yCIVgLsSedfNTM4avrHzmYqCW7c/0MPU7sTtJpDhffLSR8lDhlRPGvBUD+ew3133
atW8IZu3Sf4+OZ6YfnjWV12ZCwuyfFOd3FIT8WtWe+HVHlc/TQJU3rb31x+ut4XE
Auy/NI/+PJzTQIKGgf9PUURSDeqpYCF9J34vV5dLwlwFRwPM5PhwPjOC8UMmke4a
PBwF5u80xqLTyay3Pz7RFyklCsa6PLC+VDPb8qyW2c1gNqDY9N9mhWOZvjJs8bur
wavPiuWINEYw1XpFZXYzRbcwF0q644tR1aapx+yl+S6+6j6WG5LoRyy8Atct4SNc
n6xixhoLRZjtr8jxE/cLJZDg4wVtd8PDgE84CdUPS1O684a4TFJu8yYdiR7k+1+R
dz9yRYXY6Qgdyxk+3ba8Yto0hyOFz7CzQBiIazMrS11klRvbyvmG/k3AV/I0Sss5
+QaKhtsodzqSAXGU6Rrb
=7Uad
-----END PGP SIGNATURE-----

--0QFb0wBpEddLcDHQ--
