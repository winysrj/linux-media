Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21829 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaCKNrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 09:47:21 -0400
Message-id: <531F13E2.3040603@samsung.com>
Date: Tue, 11 Mar 2014 14:47:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Grant Likely <grant.likely@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
 <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>
 <530DE8A9.9050809@ti.com> <1393426623.3248.70.camel@paszta.hi.pengutronix.de>
 <530DFF4C.8080807@ti.com> <20140307181132.B2D71C40A88@trevor.secretlab.ca>
 <531AE46A.2060808@ti.com> <20140308122532.1AED9C40612@trevor.secretlab.ca>
 <531D6178.3070906@ti.com>
In-reply-to: <531D6178.3070906@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/14 07:53, Tomi Valkeinen wrote:
> On 08/03/14 14:25, Grant Likely wrote:
> 
>> Sure. If endpoints are logical, then only create the ones actually
>> hooked up. No problem there. But nor do I see any issue with having
>> empty connections if the board author things it makes sense to have them
>> in the dtsi.
> 
> I don't think they are usually logical, although they probably might be
> in some cases.

The endpoint nodes are supposed to be logical, they just group properties
describing a port's configuration.

> As I see it, a "port" is a group of pins in a hardware component, and
> two endpoints define a connection between two ports, which on the HW
> level are the wires between the ports.
> 
> So a port with two endpoints is a group of pins, with wires that go from
> the same pins to two different components.

It could be approximated like this, but I don't think it is needed.
I would rather stay with only port nodes mapped to hardware and the
endpoint nodes logical.

--
Regards,
Sylwester
