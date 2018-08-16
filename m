Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbeHPQrV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 12:47:21 -0400
MIME-Version: 1.0
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
 <20180723134706.15334-6-sakari.ailus@linux.intel.com> <20180731213210.GA28374@rob-hp-laptop>
 <20180801111627.gtvnhzo2b2j4haa2@paasikivi.fi.intel.com> <20180816091752.xnefm7b6cza67j4k@paasikivi.fi.intel.com>
In-Reply-To: <20180816091752.xnefm7b6cza67j4k@paasikivi.fi.intel.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 16 Aug 2018 07:48:24 -0600
Message-ID: <CAL_JsqL_nLQA29qsfS11NvhHThbAEmax+qBe1Dtqf8FXxLUxDg@mail.gmail.com>
Subject: Re: [PATCH 05/21] dt-bindings: media: Specify bus type for MIPI
 D-PHY, others, explicitly
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 16, 2018 at 3:17 AM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Ping?
>
> On Wed, Aug 01, 2018 at 02:16:27PM +0300, Sakari Ailus wrote:
> > Hi Rob,
> >
> > Thanks for the review.
> >
> > On Tue, Jul 31, 2018 at 03:32:10PM -0600, Rob Herring wrote:
> > > On Mon, Jul 23, 2018 at 04:46:50PM +0300, Sakari Ailus wrote:
> > > > Allow specifying the bus type explicitly for MIPI D-PHY, parallel and
> > > > Bt.656 busses. This is useful for devices that can make use of different
> > > > bus types. There are CSI-2 transmitters and receivers but the PHY
> > > > selection needs to be made between C-PHY and D-PHY; many devices also
> > > > support parallel and Bt.656 interfaces but the means to pass that
> > > > information to software wasn't there.
> > > >
> > > > Autodetection (value 0) is removed as an option as the property could be
> > > > simply omitted in that case.
> > >
> > > Presumably there are users, so you can't remove it. But documenting
> > > behavior when absent would be good.
> >
> > Well, it's effectively the same as having no such property at all: the type
> > is not specified. Generally there are two possibilities: the hardware
> > supports just a single bus or it supports more than one. If there's just
> > one, the type can be known by the driver. In that case there's no use for
> > autodetection.
> >
> > The second case is a bit more complicated: the bus type detection is solely
> > based on properties available in the endpoint, and I think that may have
> > been feasible approach when there were just parallel and Bt.656 busses that
> > were supported, but with the additional busses, the V4L2 fwnode framework
> > may no longer guess the bus in any meaningful way from the available
> > properties. I'd think the only known-good option here is to specify the
> > type explicitly in that case: there's no room for guessing. (This patchset
> > makes it possible for drivers to explicitly define the bus type, but the
> > autodetection support is maintained for backwards compatibility.)
> >
> > One of the existing issues is that there are combined parallel/Bt.656
> > receivers that need to know the type of the bus. This is based on the
> > existence parallel interface only properties: if any of these exist, then
> > the interface is parallel, otherwise it is Bt.656. The DT bindings for the
> > same devices also define the defaults for the parallel interface. This
> > leaves the end result ambiguous: is it the parallel interface with the
> > default configuration or is it Bt.656?
> >
> > There will likely be similar issues for CSI-2 D-PHY and CSI-2 C-PHY. The
> > question there would be: is this CSI-2 C-PHY or CSI-2 D-PHY with default
> > clock lane configuration?
> >
> > In either case the autodetection option for the bus type provides no useful
> > information. If it exists in DT source, that's fine, there's just no use
> > for it.
> >
> > Let me know if you still think it should be maintained in binding
> > documentation.
>
> If you prefer to keep it, I'd propose to mark it as deprecated or something
> as it provides no information to software.

Looks like there's only one user in tree:

arch/arm/boot/dts/omap3-n900.dts:
bus-type = <3>; /* CCP2 */
arch/arm/boot/dts/omap3-n900.dts:
bus-type = <3>; /* CCP2 */

So I guess removing is okay.

Rob
