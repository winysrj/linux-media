Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa2.dell-outbound.iphmx.com ([68.232.149.220]:11951 "EHLO
        esa2.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932918AbeFUNlk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 09:41:40 -0400
From: <Mario.Limonciello@dell.com>
To: <pavel@ucw.cz>, <nicolas@ndufresne.ca>
CC: <linux-media@vger.kernel.org>, <sakari.ailus@linux.intel.com>,
        <niklas.soderlund@ragnatech.se>, <jerry.w.hu@intel.com>
Subject: RE: Software-only image processing for Intel "complex" cameras
Date: Thu, 21 Jun 2018 13:41:37 +0000
Message-ID: <da642773adac42a6966b9716f0d53444@ausx13mpc120.AMER.DELL.COM>
References: <20180620203838.GA13372@amd>
 <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
 <20180620211144.GA16945@amd>
In-Reply-To: <20180620211144.GA16945@amd>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Wednesday, June 20, 2018 4:12 PM
> To: Nicolas Dufresne
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com;
> niklas.soderlund@ragnatech.se; jerry.w.hu@intel.com; Limonciello, Mario
> Subject: Re: Software-only image processing for Intel "complex" cameras
>=20
> Hi!
>=20
> > > On Nokia N900, I have similar problems as Intel IPU3 hardware.
> > >
> > > Meeting notes say that pure software implementation is not fast
> > > enough, but that it may be useful for debugging. It would be also
> > > useful for me on N900, and probably useful for processing "raw"
> > > images
> > > from digital cameras.
> > >
> > > There is sensor part, and memory-to-memory part, right? What is
> > > the format of data from the sensor part? What operations would be
> > > expensive on the CPU? If we did everthing on the CPU, what would be
> > > maximum resolution where we could still manage it in real time?
> >
> > The IPU3 sensor produce a vendor specific form of bayer. If we manage
> > to implement support for this format, it would likely be done in
> > software. I don't think anyone can answer your other questions has no
> > one have ever implemented this, hence measure performance.
>=20
> I believe Intel has some estimates.
>=20
> What is the maximum resolution of camera in the current Dell systems?
>=20

5M camera sensor HW spec:
2592x1944

8M camera sensor HW spec:
3264x2448

Thanks,
