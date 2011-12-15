Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38928 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab1LOLvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 06:51:52 -0500
Message-ID: <4EE9DF50.20904@infradead.org>
Date: Thu, 15 Dec 2011 09:51:44 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 1/2] media: tvp5150 Fix default input selection.
References: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com> <4EE9C7FA.8070607@infradead.org> <CACKLOr1DLj_uc-NDQPNjXHcej2isE==d=_wUinXDDfJLgFiPKg@mail.gmail.com>
In-Reply-To: <CACKLOr1DLj_uc-NDQPNjXHcej2isE==d=_wUinXDDfJLgFiPKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15-12-2011 08:24, javier Martin wrote:
>> Changing this could break em28xx that might be expecting it
>> to be set to composite1. On a quick look, the code there seems to be
>> doing the right thing: during the probe procedure, it explicitly
>> calls s_routing, in order to initialize the device input to the
>> first input type found at the cards structure. So, this patch
>> is likely harmless.
>>
>> Yet, why do you need to change it? Any bridge driver that uses it should
>> be doing the same: at initialization, it should set the input to a
>> value that it is compatible with the way the device is wired, and not
>> to assume a particular arrangement.
> 
> What I'm trying to do with these patches and my previous one related
> to mx2_camera,
> is to be able to use mx2_camera host driver with tvp5150 video decoder.
> 
> I'm not sure how mx2_camera could be aware that the sensor or decoder
> attached to it
> needs s_routing function to be called with a certain parameter without
> making it too board specific.
> The only solution I could think of was assuming that if s_routing
> function was not called at all,
> the enabled input in tvp5150 would be the default COMPOSITE0 as it is
> specified in the datasheet.
> 
> However, If you or anyone suggests a cleaner approach I'm totally
> open. But still, changing default
> value of the selected input in tvp5150 probe function is a bit dirty IMHO.

Board-specific information is needed anyway, if someone wants to use any
driver. It doesn't matter if the pipelines are set via libv4l, via direct
calls or whatever.

On em28xx, the board-specific info is stored in Kernel. It would be possible
to put that info on userspace, but that would require some code at libv4l.

The mx2_camera needs some code to forward calls to S_INPUT/S_ROUTING to
tvp5150, in order to set the pipelines there.

The libv4l plugin also needs to know about that.

Regards,
Mauro
