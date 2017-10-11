Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35882 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbdJKXOj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 19:14:39 -0400
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
 <87b48a34-4beb-eb21-3361-28f6edb6d73c@gmail.com>
 <20171011230633.GZ20805@n2100.armlinux.org.uk>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <ef2c750e-3713-3d20-f7d6-0a3a37e03c9b@gmail.com>
Date: Wed, 11 Oct 2017 16:14:36 -0700
MIME-Version: 1.0
In-Reply-To: <20171011230633.GZ20805@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/11/2017 04:06 PM, Russell King - ARM Linux wrote:
> On Wed, Oct 11, 2017 at 03:14:26PM -0700, Steve Longerbeam wrote:
>>
>> On 10/11/2017 02:49 PM, Russell King - ARM Linux wrote:
>>> On Tue, Oct 03, 2017 at 12:09:13PM -0700, Steve Longerbeam wrote:
>>>> imx_media_link_notify() should not return error if the source subdevice
>>>> is not recognized by imx-media, that isn't an error. If the subdev has
>>>> controls they will be inherited starting from a known subdev.
>>> What does "a known subdev" mean?
>> It refers to the previous sentence, "not recognized by imx-media". A
>> subdev that was not registered via async registration and so not in
>> imx-media's async subdev list. I could elaborate in the commit message
>> but it seems fairly obvious to me.
> I don't think it's obvious, and I suspect you won't think it's obvious
> in years to come (I talk from experience of some commentry I've added
> in the past.)
>
> Now, isn't it true that for a subdev to be part of a media device, it
> has to be registered, and if it's part of a media device that is made
> up of lots of different drivers, it has to use the async registration
> code?  So, is it not also true that any subdev that is part of a
> media device, it will be "known"?
>
> Under what circumstances could a subdev be part of a media device but
> not be "known" ?
>
> Now, if you mean "known" to be equivalent with "recognised by
> imx-media" then, as I've pointed out several times already, that
> statement is FALSE.  I'm not sure how many times I'm going to have to
> state this fact.  Let me re-iterate again.  On my imx219 driver, I
> have two subdevs.  Both subdevs have controls attached.  The pixel
> subdev is not "recognised" by imx-media, and without a modification
> like my or your patch, it fails.  However, with the modification,
> this "unrecognised" subdev _STILL_ has it's controls visible through
> imx-media.

Well that's true, the controls for your pixel subdev (which was
not registered via async) still are visible to imx-media, so in that
sense the subdev is "known" to imx-media.

>
> Hence, I believe your comment in the code and your commit message
> are misleading and wrong.

Ok you convinced me, I'll fix the code comment and commit
message.

Steve
