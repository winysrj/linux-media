Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32908 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934532AbdGTMbd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 08:31:33 -0400
Date: Thu, 20 Jul 2017 14:31:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] omap3isp: Return -EPROBE_DEFER if the required
 regulators can't be obtained
Message-ID: <20170720123132.GA25295@amd>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-5-sakari.ailus@linux.intel.com>
 <1652763.9EYemjAvaH@avalon>
 <20170718100352.GA28481@amd>
 <20170718101702.qi72355jjjuq7jjs@valkosipuli.retiisi.org.uk>
 <20170718210228.GA13046@amd>
 <20170718211640.qzplt2sx7gjlgqox@valkosipuli.retiisi.org.uk>
 <20170718212712.GA19771@amd>
 <20170718214622.eftjn6zz2fqo3khl@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20170718214622.eftjn6zz2fqo3khl@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > No idea really. I only have N900 working with linux at the moment. =
I'm
> > > > trying to get N9 and N950 working, but no luck so far.
> > >=20
> > > Still no? :-(
> > >=20
> > > Do you know if you get the kernel booting? Do you have access to the =
serial
> > > console? I might have seen the e-mail chain but I lost the track. What
> > > happens after the flasher has pushed the kernel to RAM and the boot s=
tarts?
> > > It's wonderful for debugging if something's wrong...
> >=20
> > Still no. No serial cable, unfortunately. Flasher seems to run the
> > kernel, but I see no evidence new kernel started successfully. I was
> > told display is not expected to work, and on USB I see bootloader
> > disconnecting and that's it.
> >=20
> > If you had a kernel binary that works for you, and does something I
> > can observe, that would be welcome :-).
>=20
> I put my .config I use for N9 here:
>=20
> <URL:http://www.retiisi.org.uk/v4l2/tmp/config.n9>
>=20
> The root filesystem is over NFS root with usbnet. You should see something
> like this in dmesg:
>=20
> [35792.056138] usb 2-2: new high-speed USB device number 58 using ehci-pci
> [35792.206238] usb 2-2: New USB device found, idVendor=3D0525, idProduct=
=3Da4a1
> [35792.206247] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
> [35792.206252] usb 2-2: Product: Ethernet Gadget
> [35792.206257] usb 2-2: Manufacturer: Linux 4.13.0-rc1-00089-g4c341695f3b=
6 with musb-hdrc

Could not get it to work, same result as usual: no response on the
device, disconnect on USB and then quiet.

Could I get actual zImage-dtb from you? What development options are
enabled in your case? I was mostly using none -- sudo
=2E./maemo/0xffff/src/0xFFFF -F "" -R 0 .

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllwoqMACgkQMOfwapXb+vLzowCffy7fwUUa5xvru6oNeSZcmrjZ
rAAAoLZBKXUaXKH2JeM8I3om3010EhtV
=m7im
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
