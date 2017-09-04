Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60385 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753422AbdIDKFy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 06:05:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 5/5] v4l: fwnode: Support generic parsing of graph endpoints in a single port
Date: Mon, 04 Sep 2017 13:05:52 +0300
Message-ID: <41798047.7Eux7kmorh@avalon>
In-Reply-To: <20170903074339.vswbczv2lfxykssq@valkosipuli.retiisi.org.uk>
References: <20170830114946.17743-1-sakari.ailus@linux.intel.com> <1981884.TcuAFemERJ@avalon> <20170903074339.vswbczv2lfxykssq@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday, 3 September 2017 10:43:39 EEST Sakari Ailus wrote:
> On Sat, Sep 02, 2017 at 12:52:47PM +0300, Laurent Pinchart wrote:
> > On Saturday, 2 September 2017 01:57:48 EEST Sakari Ailus wrote:
> >> On Fri, Sep 01, 2017 at 01:28:40PM +0200, Hans Verkuil wrote:

[sinp]

> >>> I'm lost. What's the relationship between
> >>> v4l2_async_notifier_parse_fwnode_endpoints and this function? When do
> >>> you use which? When you should zero the notifier?
> >> 
> >> I thought there would be advantages in this approach as it lets you to
> >> choose which endpoints specifically you want to parse. That said, the
> >> expectation is that the device has no endpoints that aren't supported in
> >> hardware either.
> >> 
> >> Some drivers currently iterate over all the endpoints and then validate
> >> them whereas others poke for some endpoints only (port 0, endpoint 0,
> >> for the rcar-vin driver, for instance). In DT binding documentation the
> >> endpoint numbers are currently not specified nor drivers have checked
> >> them. Common sense tells to use zero if there's no reason to do
> >> otherwise, but still this hasn't been documented nor validated in the
> >> past. So if we add that now, there could be a chance of breaking
> >> something.
> >> 
> >> Additionally, specifying the endpoints to parse explicitly has been seen
> >> beneficial (or even necessary) in parsing endpoints for devices that
> >> have both input and output interfaces. Perhaps Niklas can comment on
> >> that.
> >> 
> >> What I though was to introduce a specific error code (EPERM, better
> >> suggestions are taken)
> > 
> > Maybe ENOTCONN ?
> 
> Sounds good to me.
> 
> >> for the driver callback function (parse_endpoint) to silently skip
> >> endpoints the driver doesn't like for reason or another. This lets
> >> drivers to use the endpoint parser function added by the previous patch
> >> and still maintain the old behaviour, i.e. ignore endpoints that aren't
> >> explicitly recognised by the driver.
> >> 
> >> I'll drop this patch from the next version.
> > 
> > Parsing a specific endpoint of a specific port is probably indeed a bit
> > too fine-grained, but I think there are use cases for parsing at the port
> > level instead of parsing all ports.
> 
> Could you elaborate?
> 
> If a driver would be interested in skipping endpoints in a subset of ports,
> in which case only a single port would be excluded from this?

I meant that I see use cases for parsing specific ports only (for instance in 
the R-Car case parsing only the sink ports in a CSI-2 receiver DT node), but 
not really for parsing specific endpoints only.

-- 
Regards,

Laurent Pinchart
