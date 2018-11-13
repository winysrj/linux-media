Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:10936 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732298AbeKNBiW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 20:38:22 -0500
Subject: Re: [PATCH 3/5] media: sunxi: Add A10 CSI driver
To: Joe Perches <joe@perches.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <c53e1cdc3b139382b00ee06bf3980d3fd1742ec0.1542097288.git-series.maxime.ripard@bootlin.com>
 <f34c79f5-66d6-2c2f-5616-020ad2b96400@xs4all.nl>
 <71d315a34e4b12b0eb1d4c9003b297e46695f9cf.camel@perches.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <6153b08e-b81d-8e4a-9fd2-0f593523d8da@cisco.com>
Date: Tue, 13 Nov 2018 16:39:42 +0100
MIME-Version: 1.0
In-Reply-To: <71d315a34e4b12b0eb1d4c9003b297e46695f9cf.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/18 16:19, Joe Perches wrote:
> On Tue, 2018-11-13 at 13:24 +0100, Hans Verkuil wrote:
>> On 11/13/18 09:24, Maxime Ripard wrote:
>>> The older CSI drivers have camera capture interface different from the one
>>> in the newer ones.
> []
>>> diff --git a/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h
> []
>>> +	// Videobuf2
>>
>> Doesn't checkpatch.pl --strict complain about the use of '//'?
> 
> No, not since
> 
> commit dadf680de3c2eb4cba9840619991eda0cfe98778
> Author: Joe Perches <joe@perches.com>
> Date:   Tue Aug 2 14:04:33 2016 -0700
> 
>     checkpatch: allow c99 style // comments
>     
>     Sanitise the lines that contain c99 comments so that the error doesn't
>     get emitted.
> 
> 

Huh, I'm really out of date. But the good news is that I learned something
new today!

Thank you,

	Hans
