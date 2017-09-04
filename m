Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56931 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753515AbdIDMdN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 08:33:13 -0400
Date: Mon, 4 Sep 2017 12:33:25 +0000 (UTC)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Edgar Thier <edgar.thier@theimagingsource.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: UVC property auto update
In-Reply-To: <c36606bf-a412-894b-82bc-37fb88b50121@theimagingsource.com>
Message-ID: <alpine.DEB.2.20.1709041208520.13291@axis700.grange>
References: <c3f8b20a-65f9-ead3-9ffd-041641254af7@theimagingsource.com> <Pine.LNX.4.64.1709031714570.29016@axis700.grange> <4ce389e0-f63e-049e-b200-14ada55bb630@theimagingsource.com> <alpine.DEB.2.20.1709040801550.13291@axis700.grange>
 <c36606bf-a412-894b-82bc-37fb88b50121@theimagingsource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 Sep 2017, Edgar Thier wrote:

> Hi Guennadi,
> 
> 
> > But that patch only re-reads the flags. What does that give you? Do those 
> > flags change? In which way? As far as I understand the UVC Autoupdate
> > feature, a change in GET_INFO data is only one possibility, (arguably) a 
> > more important one is changes in GET_CUR data.

Sorry, I misunderstood, please, ignore that.

> My understanding of the driver is rather narrow, so please correct me if I am wrong.
> From what I can see the uvc driver is currently not asking the device if a property has self
> modifying properties (and thus would require the AUTO_UPDATE flag).
> This is only done for properties in the extension unit but not for 'standard' properties.
> Thus properties exhibit different behavior depending on where they are defined.
> By changing this the driver now assumes that a property with AUTO_UPDATE has to be re-read when
> getting/setting a property and does not rely on cached values, no matter if extension unit or not.
> 
> I did not consider the possibility that a lower level change would be necessary or that a more
> previce update mechanism for different property parts was possible.
> 
> Basically the entry point for my change would be here:
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/usb/uvc/uvc_ctrl.c#n1405
> 
> How an update is handled by the driver did not seem important for this patch as the retrieval of a
> correct property value seemed more important.

Ok, looking more at the spec, the driver and your patch, here's what I 
come up with:

1. UVC defines which standard controls should have which flags. Among 
those flags it specifies, which controls should specify the Autoupdate 
flag. E.g. see the first of them as it appears in my copy of the spec 
"4.2.2.4.8 Average Bit Rate Control"
2. The driver could read out flags from descriptors, but it hard-codes 
them instead. So, (arguably), there's no need to actually read them at 
probe time. XUs on the other hand aren't standard, therefore their flags 
have to be read out.
3. In your patch you provide gain as an example. Do you mean the 
PU_GAIN_CONTROL? The spec doesn't specify, that it should have Autoupdate 
set. Now, whether that means, that using that flag with PU_GAIN_CONTROL is 
a violation of the spec - I'm not sure about.

So, I think, the question really is - are hard-coded flags a proper and 
sufficient approach or should flags be read from descriptors?

> > In either case, this should 
> > be implemented using the UVC Interrupt endpoint. Here's my latest 
> > asynchronous control patch:
> > 
> > https://patchwork.linuxtv.org/patch/42800/
> > 
> > As you can see, it only handles the VALUE_CHANGE (GET_CUR) case. I would 
> > suggest implementing a patch on top of it to add support for INFO_CHANGE 
> > and you'd be the best person to test it then!
> 
> I will try it out. I should be able to give you feedback tomorrow.

Thanks.

> I will also ask the firmware developer if only value changes are available or flag changes are also
> a possibility.

Well, flags aren't likely to change, perhaps. I think min and max values 
are more likely to be updated.

Regards
Guennadi

> Cheers,
> Edgar
