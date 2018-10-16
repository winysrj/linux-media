Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58314 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbeJPIZU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 04:25:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH v3 1/4] dt-bindings: media: i2c: Add bindings for Maxim Integrated MAX9286
Date: Tue, 16 Oct 2018 03:37:44 +0300
Message-ID: <2443594.YVDbUcPb3K@avalon>
In-Reply-To: <20181015190121.GI24305@bigcity.dyn.berto.se>
References: <20181009205726.7664-1-kieran.bingham@ideasonboard.com> <71c30ead-66cd-2c84-3349-0dd393f66300@ideasonboard.com> <20181015190121.GI24305@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, 15 October 2018 22:01:21 EEST Niklas S=F6derlund wrote:
> On 2018-10-15 18:37:40 +0100, Kieran Bingham wrote:
> >>> diff --git
> >>> a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> >>> b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> >>> new file mode 100644
> >>> index 000000000000..a73e3c0dc31b
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> >>> @@ -0,0 +1,182 @@
> >>> +Maxim Integrated Quad GMSL Deserializer
> >>> +---------------------------------------
> >>> +
> >>> +The MAX9286 deserializer receives video data on up to 4 Gigabit
> >>> Multimedia
> >>> +Serial Links (GMSL) and outputs them on a CSI-2 port using up to 4
> >>> data lanes.
> >>
> >> CSI-2 D-PHY I presume?
> >=20
> > Yes, that's how I've adapted the driver based on the latest bus changes.
> >=20
> > Niklas - Could you confirm that everything in VIN/CSI2 is configured to
> > use D-PHY and not C-PHY at all ?
>=20
> Yes it's only D-PHY.
>=20
> >>> +
> >>> +- remote-endpoint: phandle to the remote GMSL source endpoint subnode
> >>> in the
> >>> +  remote node port.
> >>> +
> >>> +Required Endpoint Properties for CSI-2 Output Port (Port 4):
> >>> +
> >>> +- data-lanes: array of physical CSI-2 data lane indexes.
> >>> +- clock-lanes: index of CSI-2 clock lane.
> >>=20
> >> Is any number of lanes supported? How about lane remapping? If you do
> >> not have lane remapping, the clock-lanes property is redundant.
> >=20
> > Uhm ... Niklas?
>=20
> The MAX9286 documentation contains information on lane remapping and
> support for any number (1-4) of enabled data-lanes. I have not tested if
> this works in practice but the registers are there and documented :-)

That's my understanding too. Clock lane remapping doesn't seem to be suppor=
ted=20
though. We could thus omit the clock-lanes property.

=2D-=20
Regards,

Laurent Pinchart
