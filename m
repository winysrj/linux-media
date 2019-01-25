Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F18C282C2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 12:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8461E217D7
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 12:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfAYMrt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:47:49 -0500
Received: from mail.bootlin.com ([62.4.15.54]:49656 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfAYMrt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 07:47:49 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id BF42F207B0; Fri, 25 Jan 2019 13:47:46 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 8F9C620798;
        Fri, 25 Jan 2019 13:47:46 +0100 (CET)
Date:   Fri, 25 Jan 2019 13:47:47 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Ayaka <ayaka@soulik.info>
Cc:     tfiga@chromium.org, acourbot@chromium.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, posciak@chromium.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        nicolas.dufresne@collabora.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
Message-ID: <20190125124747.u32sgm3kto5uo3op@flea>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com>
 <20181115145650.9827-2-maxime.ripard@bootlin.com>
 <20190108095228.GA5161@misaki.sumomo.pri>
 <20190117110130.lvmwqmn6wd5eeoxi@flea>
 <e589088d-560c-a4e2-c339-27b45a0caa6a@soulik.info>
 <20190124142353.hnhd5kez6wrwcyrn@flea>
 <2C346EE9-7066-497C-BDE2-D4ED0BC3E8CF@soulik.info>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4j77cwpxkml3x2rt"
Content-Disposition: inline
In-Reply-To: <2C346EE9-7066-497C-BDE2-D4ED0BC3E8CF@soulik.info>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--4j77cwpxkml3x2rt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2019 at 10:37:23PM +0800, Ayaka wrote:
> >>>>> +#define V4L2_H264_DPB_ENTRY_FLAG_VALID        0x01
> >>>>> +#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE        0x02
> >>>>> +#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM    0x04
> >>>>> +
> >>>>> +struct v4l2_h264_dpb_entry {
> >>>>> +    __u32 tag;
> >>>>> +    __u16 frame_num;
> >>>>> +    __u16 pic_num;
> >>>> Although the long term reference would use picture order count
> >>>> and short term for frame num, but only one of them is used
> >>>> for a entry of a dpb.
> >>>>=20
> >>>> Besides, for a frame picture frame_num =3D pic_num * 2,
> >>>> and frame_num =3D pic_num * 2 + 1 for a filed.
> >>>=20
> >>> I'm not sure what is your point?
> >>=20
> >> I found I was wrong at the last email.
> >>=20
> >> But stateless hardware decoder usually don't care about whether it is =
long
> >> term or short term, as the real dpb updating or management work are no=
t done
> >> by the the driver or device and decoding job would only use the two li=
st(or
> >> one list for slice P) for reference pictures. So those flag for long t=
erm or
> >> status can be removed as well.
> >=20
> > I'll remove the LONG_TERM flag then. We do need the other two for the
> > Allwinner driver though.
> >
>
> I would ask Paulk and check the manual and vendor library later.
>
> Even there are two register fields, it don=E2=80=99t mean they would be u=
sed
> and required at the same times. Because it don=E2=80=99t follow ISO manua=
l.

It's not a matter of decoding per se, but how the hardware
behaves. All the buffers needed for one particular frame to be decoded
are uploaded to an SRAM, and the position of each buffer in that SRAM
cannot change during the time when it has been decoded, and then later
on when it's used as a reference. If you only have the frames needed
to decode the current frame, you will have no idea which slot in the
SRAM can be reused, whereas having the full DPB allows you to do
that. And that's what _FLAG_ACTIVE gives you.

> >> And I agree above with my last mail, so I would suggest to keep a prop=
erty
> >> as index for both frame_num and pic_num, as only one of them would be =
used
> >> for a picture decoding once time.
> >=20
> > I'd really prefer to keep everything that is in the bitstream defined
> > here. We don't want to cover the usual cases, but all of them even the
> > one that haven't been designed yet, so we should be really
> > conservative.
>
> As I mention in the other mail, a stateless decoder or encoder like
> means the device won=E2=80=99t track the previous result. But you have no
> idea on what data the device would need to process this picture. It
> is hard to define a standard structure for it.
>
> As you see, even allwinner doesn=E2=80=99t obey all the standard the IOS
> document said.

It's not that it disobeys it, it's that it requires the full blown DPB
to have a working driver.

> In my original suggestion, I would just to add more reservation
> fields then future driver can use it.

This interface is not stable at the moment, so it doesn't really
matter does it?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--4j77cwpxkml3x2rt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEsFcwAKCRDj7w1vZxhR
xU9NAQCZ1qMdFglALC1FLCsl6lJcRymPFtnvZK3rEaitAU6G7gEAuNPCTfcLx9q5
hobcl0NLL0Glc+KUy2OgGK9srXLahgA=
=OB3Z
-----END PGP SIGNATURE-----

--4j77cwpxkml3x2rt--
