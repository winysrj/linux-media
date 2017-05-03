Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0091.outbound.protection.outlook.com ([104.47.2.91]:11680
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751540AbdECLNw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 07:13:52 -0400
Subject: Re: [PATCH 2/2] [media] platform: add video-multiplexer subdevice
 driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <20170428141330.16187-1-p.zabel@pengutronix.de>
 <20170428141330.16187-2-p.zabel@pengutronix.de>
 <beb9f7c4-4959-1bb2-03e2-c5ccecbb8368@axentia.se>
 <df5f38c4-b0e8-64c6-d6ba-c554133f4bbf@axentia.se>
 <1493738491.2391.20.camel@pengutronix.de>
 <74bfa70b-3407-9484-9717-bb2d07356f70@axentia.se>
 <1493800556.3599.15.camel@pengutronix.de>
CC: <linux-media@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        <kernel@pengutronix.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
From: Peter Rosin <peda@axentia.se>
Message-ID: <e1cda75b-4967-7d79-7f07-b4f392153d73@axentia.se>
Date: Wed, 3 May 2017 13:13:42 +0200
MIME-Version: 1.0
In-Reply-To: <1493800556.3599.15.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-05-03 10:35, Philipp Zabel wrote:
> On Tue, 2017-05-02 at 19:42 +0200, Peter Rosin wrote:
>> On 2017-05-02 17:21, Philipp Zabel wrote:
>>> Thank you, I've resent a version with a mutex lock around vmux->active.
>>
>> I had a bunch of ifs in the above message, so I'm not sure it's needed.
>> I would expect there to be a lock outside somewhere in the media layer.
>> A cursory look gets me to media-entity.c and media_entity_setup_link()
>> which does have a mutex. But I'm no media expert, so maybe there are other
>> ways of getting to video_mux_link_setup that I'm not aware of?
> 
> link_setup is always called under the graph mutex of the /dev/media
> device. That is why I didn't think about locking too hard. In fact, I
> initially wrote this expecting mux_control_get_exclusive to exist and
> the mux select/deselect not to be locked at all.
> 
> But set_format is called from an unlocked ioctl on a /dev/v4l-subdev
> device. Until your comments I didn't notice that it would be possible to
> let link_setup set active = -1 in the middle of the set_format call,
> causing it to return garbage.

Obviously, now that you point it out. I completely missed set_format...

Cheers,
peda
