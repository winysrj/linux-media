Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55092 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3JXKkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Oct 2013 06:40:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
	linux-media@vger.kernel.org, sylvester.nawrocki@gmail.com,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFR 2/2] drm/panel: Add simple panel support
Date: Thu, 24 Oct 2013 12:40:58 +0200
Message-ID: <1853455.BSevh91aGB@avalon>
In-Reply-To: <525FD8DD.3090509@ti.com>
References: <1381947912-11741-1-git-send-email-treding@nvidia.com> <3768216.eiA2v5KI6a@avalon> <525FD8DD.3090509@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1991938.SzpaPU423k"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1991938.SzpaPU423k
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Thursday 17 October 2013 15:32:29 Tomi Valkeinen wrote:
> On 17/10/13 15:17, Laurent Pinchart wrote:
> > On Thursday 17 October 2013 14:59:41 Tomi Valkeinen wrote:
> >> On 17/10/13 14:51, Laurent Pinchart wrote:
> >>>> I'm not sure if there's a specific need for the port or endpoint nodes
> >>>> in cases like the above. Even if we have common properties describing
> >>>> the endpoint, I guess they could just be in the parent node.
> >>>> 
> >>>> panel {
> >>>> 	remote = <&dc>;
> >>>> 	common-video-property = <asd>;
> >>>> };
> >>>> 
> >>>> The above would imply one port and one endpoint. Would that work? If we
> >>>> had a function like parse_endpoint(node), we could just point it to
> >>>> either a real endpoint node, or to the device's node.
> >>> 
> >>> You reference the display controller here, not a specific display
> >>> controller output. Don't most display controllers have several outputs ?
> >> 
> >> Sure. Then the display controller could have more verbose description.
> >> But the panel could still have what I wrote above, except the 'remote'
> >> property would point to a real endpoint node inside the dispc node, not
> >> to the dispc node.
> >> 
> >> This would, of course, need some extra code to handle the different
> >> cases, but just from DT point of view, I think all the relevant
> >> information is there.
> > 
> > There's many ways to describe the same information in DT. While we could
> > have DT bindings that use different descriptions for different devices
> > and still support all of them in our code, why should we opt for that
> > option that will make the implementation much more complex when we can
> > describe connections in a simple and generic way ?
> 
> My suggestion was simple and generic. I'm not proposing per-device
> custom bindings.
> 
> My point was, if we can describe the connections as I described above,
> which to me sounds possible, we can simplify the panel DT data for 99.9%
> of the cases.
> 
> To me, the first of these looks much nicer:
> 
> panel {
> 	remote = <&remote-endpoint>;
> 	common-video-property = <asd>;
> };
> 
> panel {
> 	port {
> 		endpoint {
> 			remote = <&remote-endpoint>;
> 			common-video-property = <asd>;
> 		};
> 	};
> };

Please note that the common video properties would be in the panel node, not 
in the endpoint node (unless you have specific requirements to do so, which 
isn't the common case).

> If that can be supported in the SW by adding complexity to a few functions,
> and it covers practically all the panels, isn't it worth it?
> 
> Note that I have not tried this, so I don't know if there are issues.
> It's just a thought. Even if there's need for a endpoint node, perhaps
> the port node can be made optional.

It can be worth it, as long as we make sure that simplified bindings cover the 
needs of the generic code.

We could assume that, if the port subnode isn't present, the device will have 
a single port, with a single endpoint. However, isn't the number of endpoints 
a system property rather than a device property ? If a port of a device is 
connected to two remote ports it will require two endpoints. We could select 
the simplified or full bindings based on the system topology though.

I've CC'ed Sylwester Nawrocki and Guennadi Liakhovetski, the V4L2 DT bindings 
authors, as well as the linux-media list, to get their opinion on this.

-- 
Regards,

Laurent Pinchart

--nextPart1991938.SzpaPU423k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJSaPk/AAoJEIkPb2GL7hl1Ud0IALTgkNiiNO09zYQFAeasdvCD
s+AjL50H2kHu2HygCAldvl+uCSmCFHNi2gj88vxao5r7/rfec3sJZ1OEB7S/1JOX
O6L7C1JA4uSbzx0TRomDwRTaPnAku52atXAREcOWcInIhUm21cJj3zERC++SvnnV
s02yYOECOpdDO1V81Tcm/k0CqeohoQfTUcmbKLkKtdJd3eZAc+vVVIpMv36CQBip
VkN/UQNtkaVVBnh2frFVQy0KDR+S7uM7/mlAzyn1Uw808kRtZDJ6RH67t3OQEsih
hVl4ghl3joiOGeY0zhLYS5o7c7xPhqTkqMakl5ttaxDq5haZaBEh2yjajdzGjsg=
=CODO
-----END PGP SIGNATURE-----

--nextPart1991938.SzpaPU423k--

