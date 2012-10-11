Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44296 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab2JKWV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 18:21:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alain VOLMAT <alain.volmat@st.com>
Cc: "Linux Media Mailing List (linux-media@vger.kernel.org)"
	<linux-media@vger.kernel.org>
Subject: Re: Proposal for the addition of a binary V4L2 control type
Date: Fri, 12 Oct 2012 00:22:14 +0200
Message-ID: <4301765.LiL07lAPUi@avalon>
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA01012C91166A@SAFEX1MAIL1.st.com>
References: <E27519AE45311C49887BE8C438E68FAA01012C91166A@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alain,

On Thursday 11 October 2012 22:50:29 Alain VOLMAT wrote:
> Hi guys,
> 
> In the context of supporting the control of our HDMI-TX via V4L2 in our
> SetTopBox, we are facing interface issue with V4L2 when trying to set some
> information from the application into the H/W.
> 
> As an example, in the HDCP context, an application controlling the HDMI-TX
> have the possibility to inform the transmitter that it should fail
> authentication to some identified HDMI-RX because for example they might be
> known to be "bad" HDMI receiver that cannot be trusted. This is basically
> done by setting the list of key (BKSV) into the HDMI-TX H/W.
> 
> Currently, V4L2 ext control can be of the following type:
> 
> enum v4l2_ctrl_type {
>         V4L2_CTRL_TYPE_INTEGER       = 1,
>         V4L2_CTRL_TYPE_BOOLEAN       = 2,
>         V4L2_CTRL_TYPE_MENU          = 3,
>         V4L2_CTRL_TYPE_BUTTON        = 4,
>         V4L2_CTRL_TYPE_INTEGER64     = 5,
>         V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
>         V4L2_CTRL_TYPE_STRING        = 7,
>         V4L2_CTRL_TYPE_BITMASK       = 8,
> }
> 
> There is nothing here than could efficiently be used to push this kind of
> long (several bytes long .. not fitting into an int64) key information.
> STRING exists but actually since they are supposed to be strings, the V4L2
> core code (v4l2-ctrls.c) is using strlen to figure out the length of data
> to be copied and it thus cannot be used to push this kind of blob data.
> 
> Would you consider the addition of a new v4l2_ctrl_type, for example called
> V4L2_CTRL_TYPE_BINARY or so, that basically would be pointer + length. That
> would be helpful to pass this kind of control from the application to the
> driver. (here I took the example of HDCP key blob but that isn't of course
> the only example we can find of course).

If I remember correctly Hans Verkuil wasn't happy with the concept of binary 
controls. While I'm not totally against it, I agree with him that it could 
open the door to abuses. There are valid use cases though, both for binary 
"strings" (such as encryption keys) and binary arrays (such as gamma tables). 
Completely random binary blobs are not a good idea though.

So far we've worked around the absence of binary controls by using custom 
ioctls (or even standardizing new ioctls). It might or might not be a good 
solution for your problem, depending on your exact use cases.

-- 
Regards,

Laurent Pinchart

