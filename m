Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B100FC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 12:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D5F520842
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 12:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfBYMOt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 07:14:49 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:48131 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfBYMOs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 07:14:48 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id CB3BAC0008;
        Mon, 25 Feb 2019 12:14:42 +0000 (UTC)
Date:   Mon, 25 Feb 2019 13:15:11 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v4 05/12] media: ov5640: Compute the clock rate at runtime
Message-ID: <20190225121511.vj76qj3bw6hffhss@uno.localdomain>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-6-maxime.ripard@bootlin.com>
 <20190221162020.keonztyi7yq2a4hg@ti.com>
 <20190222143959.gothnp6namn2gt2w@flea>
 <20190222145456.3v6lsslj7slb2kob@ti.com>
 <20190222150421.ilg62fyvrxwp2moh@flea>
 <20190225092151.pra7mvgvpvekth7z@uno.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibfbp4ewubnegsnk"
Content-Disposition: inline
In-Reply-To: <20190225092151.pra7mvgvpvekth7z@uno.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ibfbp4ewubnegsnk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Sorry again,

On Mon, Feb 25, 2019 at 10:21:51AM +0100, Jacopo Mondi wrote:
> Hello Maxime, Benoit,
>   sorry for chiming in, but I'm a bit confused...
>
> On Fri, Feb 22, 2019 at 04:04:21PM +0100, Maxime Ripard wrote:
> > On Fri, Feb 22, 2019 at 08:54:56AM -0600, Benoit Parrot wrote:
> > > Maxime Ripard <maxime.ripard@bootlin.com> wrote on Fri [2019-Feb-22 15:39:59 +0100]:
> > > > On Thu, Feb 21, 2019 at 10:20:20AM -0600, Benoit Parrot wrote:
> > > > > Hi Maxime,
> > > > >
> > > > > A couple of questions,
> > > > >
> > > > > Maxime Ripard <maxime.ripard@bootlin.com> wrote on Thu [2018-Oct-11 04:21:00 -0500]:
> > > > > > The clock rate, while hardcoded until now, is actually a function of the
> > > > > > resolution, framerate and bytes per pixel. Now that we have an algorithm to
> > > > > > adjust our clock rate, we can select it dynamically when we change the
> > > > > > mode.
> > > > > >
> > > > > > This changes a bit the clock rate being used, with the following effect:
> > > > > >
> > > > > > +------+------+------+------+-----+-----------------+----------------+-----------+
> > > > > > | Hact | Vact | Htot | Vtot | FPS | Hardcoded clock | Computed clock | Deviation |
> > > > > > +------+------+------+------+-----+-----------------+----------------+-----------+
> > > > > > |  640 |  480 | 1896 | 1080 |  15 |        56000000 |       61430400 | 8.84 %    |
> > > > > > |  640 |  480 | 1896 | 1080 |  30 |       112000000 |      122860800 | 8.84 %    |
> > > > > > | 1024 |  768 | 1896 | 1080 |  15 |        56000000 |       61430400 | 8.84 %    |
> > > > > > | 1024 |  768 | 1896 | 1080 |  30 |       112000000 |      122860800 | 8.84 %    |
> > > > > > |  320 |  240 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
> > > > > > |  320 |  240 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
> > > > > > |  176 |  144 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
> > > > > > |  176 |  144 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
> > > > > > |  720 |  480 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
> > > > > > |  720 |  480 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
> > > > > > |  720 |  576 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
> > > > > > |  720 |  576 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
> > > > > > | 1280 |  720 | 1892 |  740 |  15 |        42000000 |       42002400 | 0.01 %    |
> > > > > > | 1280 |  720 | 1892 |  740 |  30 |        84000000 |       84004800 | 0.01 %    |
> > > > > > | 1920 | 1080 | 2500 | 1120 |  15 |        84000000 |       84000000 | 0.00 %    |
> > > > > > | 1920 | 1080 | 2500 | 1120 |  30 |       168000000 |      168000000 | 0.00 %    |
> > > > > > | 2592 | 1944 | 2844 | 1944 |  15 |        84000000 |      165862080 | 49.36 %   |
> > > > > > +------+------+------+------+-----+-----------------+----------------+-----------+
> > > > >
> > > > > Is the computed clock above the same for both parallel and CSI2?
> > > > >
> > > > > I want to add controls for PIXEL_RATE and LINK_FREQ, would you have any
> > > > > quick pointer on taking the computed clock and translating that into the
> > > > > PIXEL_RATE and LINK_FREQ values?
> > > > >
> > > > > I am trying to use this sensor with TI CAL driver which at the moment uses
> > > > > the PIXEL_RATE values in order to compute ths_settle and ths_term values
> > > > > needed to program the DPHY properly. This is similar in behavior as the way
> > > > > omap3isp relies on this info as well.
> > > >
> > > > I haven't looked that much into the csi-2 case, but the pixel rate
> > > > should be the same at least.
> > >
> > > I'll have to study the way the computed clock is actually calculated for
> > > either case, but if they yield the same number then I would be surprised
> > > that the pixel rate would be the same as in parallel mode you get 8 data
> > > bits per clock whereas in CSI2 using 2 data lanes you get 4 data bits per
> > > clock.
> >
> > The bus rate will be different, but the pixel rate is the same: you
> > have as many pixels per frames and as many frames per seconds in the
> > parallel and CSI cases.
> >
>
> I agree with that, but..
>
> > > So just to be certain here the "Computed clock" column above would be the
> > > pixel clock frequency?
> >
> > it is
>
> ...it seems to me the Computed clock column is actually the "byte clock".
>
> From a simple calculation for the 640x480@15FPS case:
> "Computed clock" = 1896 * 1080 * 15 * 2 = 61430400
>
> While, in my understanding, the pixel clock would just be
> pixel_clock = HTOT * VTOT * FPS = 1896 * 1080 * 15 = 30715200
>
> So I suspect the "* 2" there is the number of bytes per pixel.
>
> That would match what's also reported here
> file:///home/jmondi/project/renesas/linux/linux-build/Documentation/output/media/kapi/csi2.html?highlight=link_freq
>

Of course that is a link to the local copy of the documentation,
what I actually meant to link was:
https://www.kernel.org/doc/html/latest/media/kapi/csi2.html?highlight=link_freq

Sorry!
   j


> Where:
> link_freq = (pixel_rate * bpp) / (2 * nr_lanes)
>
> So if I were to calculate PIXEL_RATE and LINK_FREQ in this driver,
> that would be:
> PIXEL_RATE = mode->vtot * mode->htot * ov5640_framerates[sensor->current_fr];
> LINK_FREQ = PIXEL_RATE * 16 / ( 2 * sensor->ep.bus.mipi_csi2.num_data_lanes);
> (assuming, as the driver does now, all formats have 16bpp)
>
> Does this match your understanding as well?
>
> Thanks
>   j
>
> >
> > Maxime
> >
> > --
> > Maxime Ripard, Bootlin
> > Embedded Linux and Kernel engineering
> > https://bootlin.com
>
>



--ibfbp4ewubnegsnk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxz3E8ACgkQcjQGjxah
VjzCgQ//Sjsu4hHvUJnMwS7x+Hop8lgkmKVKKNRlCw7+Gl/0ZaVpM9R1EHtXy9F7
JuLgv5RkbzcfYIJlFQmLzrbnd1gUGrtj810mW1BX7W8W8yKegxCUETulo/L9KBAM
uhJ3ceOIBPr5fXqUQzLLbWhDSWwCBgqT6CZD6begFtoidaSR3lLYdMPafLvBL86g
vF46BxtePRxEFBI5bfHG3Arz5l7fBNmwF89iHuMJ++ReUVVmsr/ZsX0PBJACyGX6
KmlbKzJt3JIDF/ZSo+18LFBnwT4cH+k180WMq9TLXxOQ4AU3BUosgBu5H8XlzjUe
XXIteYDLqchmxGKnXsSvPFlqKq1tdPBvZzBHJ8tnzhW1VgNVKvQoWAHu/UMexfZY
54QGDgzGWnqzDFljssGPms5hPH0tEGKdClBdsLoSq72WQFE64royGXYjOqDjCY0i
MfSNmpaO2NBKOuHccCufPksP9HHstzXsTS9mIJAJrIawmB7QOeK8hIobO1DMvtzO
bOZqFu04D4OC7oAfPgotm0UkE1SzLaTjGP77Ex6SmXpn0i7qxHVLL1eK1c2DFJSM
cT7cdosXZWjc+RImGgSec1VVgKyAVwsqTMeHeDsPaHmADxrH9aT3AAnx95D7Fr1V
HSVYBkDLOLq30bH0sz9yuc2UBu2VWwPGGNLziEccOWOEdAs7OdI=
=b9mm
-----END PGP SIGNATURE-----

--ibfbp4ewubnegsnk--
