Return-path: <linux-media-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:38601 "EHLO
        bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdF1U0Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 16:26:25 -0400
Date: Wed, 28 Jun 2017 13:26:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robb Glasser <rglasser@google.com>,
        Richard Simmons <rssimmo@amazon.com>
Subject: Re: [media] uvcvideo: Prevent heap overflow in uvc driver
Message-ID: <20170628202621.GA19176@roeck-us.net>
References: <1495482484-32125-1-git-send-email-linux@roeck-us.net>
 <20170628143643.GA30654@roeck-us.net>
 <1797631.lsAEjhpLaU@avalon>
 <1612560.vxfrDdQTFq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612560.vxfrDdQTFq@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 28, 2017 at 09:18:37PM +0300, Laurent Pinchart wrote:
> Hi Guenter,
> 
> On Wednesday 28 Jun 2017 20:59:17 Laurent Pinchart wrote:
> > On Wednesday 28 Jun 2017 07:36:43 Guenter Roeck wrote:
> > > On Mon, May 22, 2017 at 12:48:04PM -0700, Guenter Roeck wrote:
> > >> From: Robb Glasser <rglasser@google.com>
> > >> 
> > >> The size of uvc_control_mapping is user controlled leading to a
> > >> potential heap overflow in the uvc driver. This adds a check to verify
> > >> the user provided size fits within the bounds of the defined buffer
> > >> size.
> > >> 
> > >> Signed-off-by: Robb Glasser <rglasser@google.com>
> > >> [groeck: cherry picked from
> > >> 
> > >>  https://source.codeaurora.org/quic/la/kernel/msm-3.10
> > >>  commit b7b99e55bc7770187913ed092990852ea52d7892;
> > >>  updated subject]
> > >> 
> > >> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > >> ---
> > >> Fixes CVE-2017-0627.
> > > 
> > > Please do not apply this patch. It is buggy.
> > 
> > I apologize for not noticing the initial patch, even if it looks like it was
> > all for the best. Will you send a new version ?
> > 
> > >>  drivers/media/usb/uvc/uvc_ctrl.c | 3 +++
> > >>  1 file changed, 3 insertions(+)
> > >> 
> > >> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > >> b/drivers/media/usb/uvc/uvc_ctrl.c index c2ee6e39fd0c..252ab991396f
> > >> 100644
> > >> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > >> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > >> @@ -1992,6 +1992,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> > >> *chain,
> > >>  	if (!found)
> > >>  		return -ENOENT;
> > >> 
> > >> +	if (ctrl->info.size < mapping->size)
> > >> +		return -EINVAL;
> > >> +
> 
> By the way, I believe the right fix should be
> 
> 	if (mapping->offset + mapping->size > ctrl->info.size * 8)
> 		return -EINVAL;
> 
> Both mapping->offset and mapping->size are 8-bit integers, so there's no risk 
> of overflow in the addition. If we want to safeguard against a possible future 
> bug if the type of the fields change, we could add
> 
> 	if (mapping->offset + mapping->size < mapping->offset)
> 		return -EINVAL;
> 

I currently have this:

@@ -2004,6 +2004,13 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		goto done;
 	}
 
+	/* validate that the user provided bit-size and offset is valid */
+	if ((mapping->size > 32) ||
+	    ((mapping->offset + mapping->size) > (ctrl->info.size * 8))) {
+		ret = -EINVAL;
+		goto done;
+	}
+
 	list_for_each_entry(map, &ctrl->info.mappings, list) {
 		if (mapping->id == map->id) {
 			uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', "

This version originates from Richard Simmons. Copying him to see if he wants
to submit it himself.

Guenter
