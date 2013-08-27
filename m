Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37047 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208Ab3H0JPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 05:15:05 -0400
Date: Tue, 27 Aug 2013 10:14:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v7] s5k5baf: add camera sensor driver
Message-ID: <20130827091448.GA19893@e106331-lin.cambridge.arm.com>
References: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

[trimming down to relevant context]

> +endpoint node
> +-------------
> +
> +- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
> +  video-interfaces.txt. This property can be only used to specify number
> +  of data lanes, i.e. the array's content is unused, only its length is
> +  meaningful. When this property is not specified default value of 1 lane
> +  will be used.

Apologies for having not replied to the last posting, but having looked
at the documentation I was provided last time [1], I don't think the
values in the data-lanes property should be described as unused. That
may be the way the Linux driver functions at present, but it's not how
the generic video-interfaces binding documentation describes the
property.

If the CSI transmitter hardware doesn't support logical remapping of
lanes, then the only valid values for data-lanes would be a contiguous
list of lane IDs starting at 1, ending at 4 at most. Valid values for
the property would be one of:

data-lanes = <1>;
data-lanes = <1>, <2>;
data-lanes = <1>, <2>, <3>;
data-lanes = <1>, <2>, <3>, <4>;

We can mention the fact the hardware doesn't support remapping of lanes,
and therefore the list must start with lane 1 and end with (at most)
lane 4. That way a dts will match the generic binding and actually
describe the hardware, and it's possible for Linux (or any other OS) to
factor out the parsing of data-lanes later as desired.

I don't think we should offer freedom to encode garbage in the dt when
we can just as easily encourage more standard use of bindings that will
make our lives easier in the long-term.

Thanks,
Mark.

[1] http://www.mipi.org/specifications/camera-interface#CSI2
