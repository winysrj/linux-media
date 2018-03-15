Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35771 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752131AbeCOQUf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 12:20:35 -0400
Date: Thu, 15 Mar 2018 17:20:08 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] media: i2c: Copy mt9t112 soc_camera sensor driver
Message-ID: <20180315162008.GA31710@w540>
References: <1520862185-17150-1-git-send-email-jacopo+renesas@jmondi.org>
 <1520862185-17150-2-git-send-email-jacopo+renesas@jmondi.org>
 <20180315113533.cwgf7g7sir7gyplk@valkosipuli.retiisi.org.uk>
 <20180315143856.GF16424@w540>
 <d1cfdb88-ec5d-5229-6fd7-0916905fc8e8@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <d1cfdb88-ec5d-5229-6fd7-0916905fc8e8@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hans,

On Thu, Mar 15, 2018 at 08:30:21AM -0700, Hans Verkuil wrote:
> On 03/15/2018 07:38 AM, jacopo mondi wrote:
> > Hi Sakari,
> >    thanks for looking into this!
> >
> > On Thu, Mar 15, 2018 at 01:35:34PM +0200, Sakari Ailus wrote:
> >> Hi Jacopo,
> >>
> >> I wonder if it'd make sense to just make all the changes to the driver and
> >> then have it reviewed; I'm not sure the old driver can be said to have been
> >> in a known-good state that'd be useful to compare against. I think you did
> >> that with another driver as well.
> >>
> >
> > Well, I understand this is still debated, and I see your point.
> > As far as I can tell the driver had been developed to work with SH4
> > Ecovec boards and there tested.
> >
> > I'm not sure I fully got you here though. Are you proposing to
> > squash my next patch that cleans up the driver into this one and
> > propose it as a completely new driver to be reviewed from scratch?
> >
> > In the two previous driver I touched in this "remove soc_camera"
> > journey (ov772x and tw9910) I have followed this same pattern: copy
> > the soc_camera driver without removing the existing one, and pile on
> > top my changes/cleanups in another patch. Then port the board code to
> > use the new sensor driver, and the new CEU driver as well.
> >
> > Also, how would you like to proceed here? Hans sent a pull request for
> > the series, should I go with incremental changes on top of this?
>
> I don't want to postpone this conversion. The i2c/mt9t112.c is bug-compatible
> with i2c/soc-camera/mt9t112.c which is good enough for me. Being able to
> remove soc-camera in the (hopefully very) near future is the most important
> thing here.
>
> Once Jacopo can actually test the sensor, then that's a good time to review
> the driver in more detail.
>
> This reminded me that I actually started testing this sensor a year
> ago (I bought the same sensor on ebay, I completely forgot about that!).
>
> My attempt is here:
>
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=mt9t112
>
> I never finished it because I had no documentation on the pinout and never
> got around to hooking my oscilloscope up to it to figure this out. I was
> testing this with the atmel-isc.c driver.
>
> This might be of some use to you, Jacopo, once you have the sensor.

Thanks for the info. I'll see what I can do. I don't have register
level document, and if the module is the same you have neither a
pinout description. This is going to be fun :/

I'll then refrain from sending more patches for this series/driver
until we cannot actually test the sensor, fixes apart, if any, of course.

Thanks
   j

>
> Regards,
>
> 	Hans

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJaqp04AAoJEHI0Bo8WoVY8JQQP/jHzm5tlUBjYLExvnJcOnDAD
ocK4En9NHx3NOL/hcxEj8y+RILFoDlE2QxQvXj2ZF113HP/ZdbegUKv4HU66tRIT
L9aw7NHd8CDv4lE6pLUZBQIqFnhO0ejvY4vGJrQUJGwkCld50sQnaHCp4XOtgMK7
QmJ1SQtDQNEBPL4kJNiyYEbYol8uKr/TBX5uCTlac7/Rua5JJ2dR/CVKoqZIz1Qr
iRfWpLbuIoUrNXyDy+YEKvwP+2YFbkETzajG18hg1GIeZwPmLjZu7zUji2N5o7D8
raqLYgfsaFrtSXo+u325OhdnH/86s+k7AmF871l2LNi+emTMYjgrxbcQFPRjPrfi
ptwH0diNJQccPVwqnceXH+CJoAcC9Z/earDge70hIFKz3u3j0DCoWU7+21Obvq8k
Uc4dD/WdKP3pFPIWKMqoeUT/i0Hc7aeLwckcVjjcR52WYjN80HTuo1EEhncI/45G
L+8utn4b6AvQ48N6sfY8946eGQzdZD138b+2YBm+uUFbkwZCfimIDHMYvNKcdJGH
/0ioAcvJjThekLb/chUXZfY3Fivoi6Rf57hIlrX0gMehfCc8m3l6XtOFbZ4FP0JB
ocYGHb38FQ8TTSv88WRVNn2QPTqlzS4kWKNbsV9SiuLHhcZeTuuFeZ1EmzdcIDeU
t2kIrGCNWUH+KXr9D0Xv
=rVaa
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
