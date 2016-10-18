Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58297 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbcJRIbm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 04:31:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: lars@metafoo.de, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 3/8] media: adv7180: add support for NEWAVMODE
Date: Tue, 18 Oct 2016 11:31:38 +0300
Message-ID: <2462483.bEItkJI9HH@avalon>
In-Reply-To: <34b5e02c-fcfc-1dbe-f67e-aeced11debf5@gmail.com>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com> <3171592.lqAHMF38Fl@avalon> <34b5e02c-fcfc-1dbe-f67e-aeced11debf5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Monday 17 Oct 2016 15:36:14 Steve Longerbeam wrote:
> On 10/16/2016 05:18 AM, Laurent Pinchart wrote:
> > On Wednesday 03 Aug 2016 11:03:45 Steve Longerbeam wrote:
> >> Parse the optional v4l2 endpoint DT node. If the bus type is
> >> V4L2_MBUS_BT656 and the endpoint node specifies "newavmode",
> >> configure the BT.656 bus in NEWAVMODE.
> >> 
> >> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> >> ---
> >> v4: no changes
> >> v3:
> >> - the newavmode endpoint property is now private to adv7180.
> >> ---
> >> .../devicetree/bindings/media/i2c/adv7180.txt      |  4 ++
> >> drivers/media/i2c/adv7180.c                        | 46 ++++++++++++++--
> >> 2 files changed, 47 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
> >> b/Documentation/devicetree/bindings/media/i2c/adv7180.txt index
> >> 0d50115..6c175d2 100644
> >> --- a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
> >> +++ b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
> >> @@ -15,6 +15,10 @@ Required Properties :
> >>   		"adi,adv7282"
> >>   		"adi,adv7282-m"
> >> 
> >> +Optional Endpoint Properties :
> >> +- newavmode: a boolean property to indicate the BT.656 bus is operating
> >> +  in Analog Device's NEWAVMODE. Valid for BT.656 busses only.
> > 
> > This is a vendor-specific property, it should be prefixed with "adi,".
> 
> Ok, I'll do that in next version.
> 
> >   Could
> > 
> > you also explain how this mode works ? I'd like to make sure it qualifies
> > for a DT property.
> 
> The blurb in the ADV718x manual is terse:
> 
> "When NEWAVMODE is 0 (enabled), EAV/SAV codes are generated to
> suit Analog Devices encoders. No adjustments are possible."
> 
> "Setting NEWAVMODE to 1 (default) enables the manual position
> of the VSYNC, FIELD, and AV codes using Register 0x32 to
> Register 0x33 and Register 0xE5 to Register 0xEA. Default register
> settings are CCIR656 compliant;"
> 
> So it's not clear to me how the generated EAV and SAV codes are
> different from standard CCIR656, but apparently they are.

Shouldn't we understand how it works to create proper DT bindings ? :-)

-- 
Regards,

Laurent Pinchart

