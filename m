Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0070.outbound.protection.outlook.com ([104.47.40.70]:29600
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752337AbeA3Py2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 10:54:28 -0500
From: Simon Hatliff <hatliff@cadence.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "nm@ti.com" <nm@ti.com>
Subject: Re: [PATCH v5 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Date: Tue, 30 Jan 2018 15:54:24 +0000
Message-ID: <3F3A3B73-D31C-41D0-8E88-C78BC3E55A81@cadence.com>
References: <20180119081357.20799-1-maxime.ripard@free-electrons.com>
 <20180119081357.20799-3-maxime.ripard@free-electrons.com>
 <20180129191036.GE25980@ti.com> <20180130154126.keytdulix5imq6b3@flea.lan>
In-Reply-To: <20180130154126.keytdulix5imq6b3@flea.lan>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A0960E0884F50E4E8F6C8A6BDB9C93CB@namprd07.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30 Jan 2018, at 15:41, Maxime Ripard <maxime.ripard@free-electrons.com> =
wrote:
>=20
> Since the lanes are not in use, I'm not sure we have to worry about
> lanes collision. Simon, would it cause any trouble if we map to lanes
> to the same physical lane?

Yes IIRC it would cause trouble.  Due to the internals of the design each
lane needs to have a unique mapping even if it's not in use.=
