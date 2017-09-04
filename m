Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp106.iad3a.emailsrvr.com ([173.203.187.106]:37369 "EHLO
        smtp106.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753480AbdIDLQq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 07:16:46 -0400
Subject: Re: UVC property auto update
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <c3f8b20a-65f9-ead3-9ffd-041641254af7@theimagingsource.com>
 <Pine.LNX.4.64.1709031714570.29016@axis700.grange>
 <4ce389e0-f63e-049e-b200-14ada55bb630@theimagingsource.com>
 <alpine.DEB.2.20.1709040801550.13291@axis700.grange>
From: Edgar Thier <edgar.thier@theimagingsource.com>
Message-ID: <c36606bf-a412-894b-82bc-37fb88b50121@theimagingsource.com>
Date: Mon, 4 Sep 2017 13:16:45 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1709040801550.13291@axis700.grange>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,


> But that patch only re-reads the flags. What does that give you? Do those > flags change? In which way? As far as I understand the UVC Autoupdate
> feature, a change in GET_INFO data is only one possibility, (arguably) a 
> more important one is changes in GET_CUR data.

My understanding of the driver is rather narrow, so please correct me if I am wrong.
>From what I can see the uvc driver is currently not asking the device if a property has self
modifying properties (and thus would require the AUTO_UPDATE flag).
This is only done for properties in the extension unit but not for 'standard' properties.
Thus properties exhibit different behavior depending on where they are defined.
By changing this the driver now assumes that a property with AUTO_UPDATE has to be re-read when
getting/setting a property and does not rely on cached values, no matter if extension unit or not.

I did not consider the possibility that a lower level change would be necessary or that a more
previce update mechanism for different property parts was possible.

Basically the entry point for my change would be here:
https://git.linuxtv.org/media_tree.git/tree/drivers/media/usb/uvc/uvc_ctrl.c#n1405

How an update is handled by the driver did not seem important for this patch as the retrieval of a
correct property value seemed more important.

> In either case, this should 
> be implemented using the UVC Interrupt endpoint. Here's my latest 
> asynchronous control patch:
> 
> https://patchwork.linuxtv.org/patch/42800/
> 
> As you can see, it only handles the VALUE_CHANGE (GET_CUR) case. I would 
> suggest implementing a patch on top of it to add support for INFO_CHANGE 
> and you'd be the best person to test it then!

I will try it out. I should be able to give you feedback tomorrow.
I will also ask the firmware developer if only value changes are available or flag changes are also
a possibility.

Cheers,

Edgar
