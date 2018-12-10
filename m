Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F425C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 07:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C6F7205C9
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 07:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C6F7205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbeLJH7I (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 02:59:08 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52187 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbeLJH7I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 02:59:08 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id B5357C0014;
        Mon, 10 Dec 2018 07:59:04 +0000 (UTC)
Date:   Mon, 10 Dec 2018 08:59:02 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     sakari.ailus@iki.fi
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>, corbet@lwn.net,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l2: i2c: ov7670: Fix PLL bypass register values
Message-ID: <20181210075902.GG5597@w540>
References: <1514550146-20195-1-git-send-email-jacopo+renesas@jmondi.org>
 <20181209233917.dhtwrpb46y2iyx4m@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ewQ5hdP4CtoTt3oD"
Content-Disposition: inline
In-Reply-To: <20181209233917.dhtwrpb46y2iyx4m@valkosipuli.retiisi.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ewQ5hdP4CtoTt3oD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,
   thanks for digging this out

On Mon, Dec 10, 2018 at 01:39:17AM +0200, sakari.ailus@iki.fi wrote:
> Hi Jacopo,
>
> On Fri, Dec 29, 2017 at 01:22:26PM +0100, Jacopo Mondi wrote:
> > The following commits:
> > commit f6dd927f34d6 ("[media] media: ov7670: calculate framerate properly for ov7675")
> > commit 04ee6d92047e ("[media] media: ov7670: add possibility to bypass pll for ov7675")
> > introduced the ability to bypass PLL multiplier and use input clock (xvclk)
> > as pixel clock output frequency for ov7675 sensor.
> >
> > PLL is bypassed using register DBLV[7:6], according to ov7670 and ov7675
> > sensor manuals. Macros used to set DBLV register seem wrong in the
> > driver, as their values do not match what reported in the datasheet.
> >
> > Fix by changing DBLV_* macros to use bits [7:6] and set bits [3:0] to
> > default 0x0a reserved value (according to datasheets).
> >
> > While at there, remove a write to DBLV register in
> > "ov7675_set_framerate()" that over-writes the previous one to the same
> > register that takes "info->pll_bypass" flag into account instead of setting PLL
> > multiplier to 4x unconditionally.
> >
> > And, while at there, since "info->pll_bypass" is only used in
> > set/get_framerate() functions used by ov7675 only, it is not necessary
> > to check for the device id at probe time to make sure that when using
> > ov7670 "info->pll_bypass" is set to false.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>
> I assume this is still valid and long overdue for merging. :-) No other
> work in the area seem to have been done so I'm picking it up...
>

It should still be valid, and should still apply regardless of its
age :) Is it worth a proper 'Fixes' tag?

Fixes: f6dd927f34d6 ("[media] media: ov7670: calculate framerate properly for ov7675")

Thanks
  j

> --
> Regards,
>
> Sakari Ailus

--ewQ5hdP4CtoTt3oD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcDhzGAAoJEHI0Bo8WoVY82NgQAIV7qoBE5Lx1RNvWbIND4yIz
J5Mih+7dLM8eoifrhG3/Edvnji64rI+IwCmCTG2r9Xnf4FIAm+eWz6YRSWwS/X16
5g8AwtTqzqv01YM7sJ2NuUX6EcAsye7GGHbblZeOmgfE/MPkCdOh+j7NcIj0dZWv
nK+azNwCw46aqHaoL3OZ8q4GDPoNDS6n49Xj14Uu1jn4iRdrztUM2NWNi78ex9X6
so3rJ3+OajIKqfpJvhNlaQfq+S82IaHZBvuPUwdDRmPD2y8uytkpFg3nn7uooDsd
iJbnI2elw20LnEzDGh/Gf9pyaFrg2tKytgU6QwB1QgWZ1iE3aF91JeHsm54KF+yn
0pUBHWNu2qxQjWpvmDCEUIfLY4ql9fTKL/EO36CR92OPtWCAnA6xi261NiSIaLEv
ANI7/pYT0XobKnQZxDoXbOF2zqqjnVa4G6QXFxq2u35kNgmN0z1Mp/GonSXSjyX6
8Un+dyXjXBeKTWUoadfXan/nVkAX9Df3ZEsk6HolZD9gjeuTv+RLv25hDwUrsjta
CfF0WN+MdL5UzavTXooF+IUFB2OlKaJyP1anZrTuzeRjthPhvFD1qp78yR69SHuC
yGgJzc6hmnfs+tkhW6MKUYtnAKkYcEl2cxFNWyfycFkL82K6oLcjH2TnI+vOqvA8
uL1+jaKkLtiepgFsMiD/
=AUv6
-----END PGP SIGNATURE-----

--ewQ5hdP4CtoTt3oD--
