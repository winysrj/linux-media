Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:63238 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1765133AbdEZOrj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 10:47:39 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v5 3/7] media: i2c: max2175: Add MAX2175 support
Date: Fri, 26 May 2017 14:47:32 +0000
Message-ID: <KL1PR0601MB2038AAC0C02926FE168A7952C3FC0@KL1PR0601MB2038.apcprd06.prod.outlook.com>
References: <20170509133738.16414-1-ramesh.shanmugasundaram@bp.renesas.com>
 <20170509133738.16414-4-ramesh.shanmugasundaram@bp.renesas.com>
 <20170510081231.GB3227@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170510081231.GB3227@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review comments on the patches. Sorry for the late response =
as I was caught up with another work.=20

I will incorporate your comments and rebase it on top of your branch. I see=
 it is not there in media-tree master yet. Please let me know if there is a=
 change in plan.

Thanks,
Ramesh

> Subject: Re: [PATCH v5 3/7] media: i2c: max2175: Add MAX2175 support
>=20
> Hi Ramesh,
>=20
> On Tue, May 09, 2017 at 02:37:34PM +0100, Ramesh Shanmugasundaram wrote:
> ...
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-of.h>
>=20
> Could you rebase this on the V4L2 fwnode patchset here, please?
>=20
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=3Dv4l2-acpi>
>=20
> It depends on other patches which will reach media-tree master in next
> rc1, for now I've merged them here:
>=20
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=3Dv4l2-acpi-mer=
ge>
>=20
> I'll send a pull request for media-tree once we have 4.12rc1 in media-tre=
e
> master.
>=20
> Thanks.
>=20
> --
> Kind regards,
>=20
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
