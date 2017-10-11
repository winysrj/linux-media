Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34354 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbdJKWOb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 18:14:31 -0400
Subject: Re: [PATCH] media: staging/imx: do not return error in link_notify
 for unknown sources
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1507057753-31808-1-git-send-email-steve_longerbeam@mentor.com>
 <20171011214906.GX20805@n2100.armlinux.org.uk>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <87b48a34-4beb-eb21-3361-28f6edb6d73c@gmail.com>
Date: Wed, 11 Oct 2017 15:14:26 -0700
MIME-Version: 1.0
In-Reply-To: <20171011214906.GX20805@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/11/2017 02:49 PM, Russell King - ARM Linux wrote:
> On Tue, Oct 03, 2017 at 12:09:13PM -0700, Steve Longerbeam wrote:
>> imx_media_link_notify() should not return error if the source subdevice
>> is not recognized by imx-media, that isn't an error. If the subdev has
>> controls they will be inherited starting from a known subdev.
> What does "a known subdev" mean?

It refers to the previous sentence, "not recognized by imx-media". A
subdev that was not registered via async registration and so not in
imx-media's async subdev list. I could elaborate in the commit message
but it seems fairly obvious to me.

Steve
