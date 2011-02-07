Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38255 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1BGMkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 07:40:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Subject: Re: [PATCH 1/5] uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
Date: Mon, 7 Feb 2011 13:40:17 +0100
Cc: martin_rubli@logitech.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com> <1294416040-28371-2-git-send-email-laurent.pinchart@ideasonboard.com> <1296500724.17673.72.camel@svmlwks101>
In-Reply-To: <1296500724.17673.72.camel@svmlwks101>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071340.18268.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stephan,

On Monday 31 January 2011 20:05:24 Stephan Lachowsky wrote:
> On Fri, 2011-01-07 at 08:00 -0800, Laurent Pinchart wrote:
> > From: Martin Rubli <martin_rubli@logitech.com>
> > 
> > This ioctl extends UVCIOC_CTRL_GET/SET by not only allowing to get/set
> > XU controls but to also send arbitrary UVC commands to XU controls,
> > namely GET_CUR, SET_CUR, GET_MIN, GET_MAX, GET_RES, GET_LEN, GET_INFO
> > and GET_DEF. This is required for applications to work with XU controls,
> > so that they can properly query the size and allocate the necessary
> > buffers.
> > 
> > Signed-off-by: Martin Rubli <martin_rubli@logitech.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I think that this is a great improvement to the existing ioctls, but I'd
> like some feedback on the vacuum around bUnitID.  The XU descriptor
> basically associates a unique address (bUnitID) with a specific
> extension unit (guidExtensionCode).  It is the GUID that specifies the
> semantics of the control, and bUnitID simply provides routing to a
> specific instance.
> 
> Now, the ioctls as currently implemented are very flexible, but I feel
> that there should be some mechanism for discovering the bUnitID(s)
> associated with a specific guidExtensionCode.  Currently there is no way
> to do this: you must either dead reckon the bUnitID value, or parse the
> USB descriptors in user space to come up with the value needed for
> UVCIOC_CTRL_GET/SET/QUERY (UVCIOC_CTRL_MAP matches on the GUID, which
> makes bUnitID opaque to the user).
> 
> I think this functionality has been missed in the dynctrl ioctls since
> their inception.  As UVC XU controls are standardized it is inevitable
> that different vendors will implement the same control with different
> bUnitID values.  I propose that we add something along the lines of
> UVCIOC_CTRL_ENUM to enumerate through the XUs so that userspace can
> simply discover the guidExtensionCode <-> bUnitID mappings that exist on
> the specific device (or any other type of XU reporting they wish).
> 
> I would be willing to implement the patch provided I get some feedback
> that this functionality belongs in the driver.  We had implemented
> something similar prior to just using to UVCIOC_CTRL_MAP'ings.

My current plan is to use the media controller API for this. All UVC entities 
would be mapped to media controller entities, and a new ioctl (not available 
yet) will be used to retrieve driver-specific entity details.

-- 
Regards,

Laurent Pinchart
