Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E407BC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A56F120863
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:41:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="PYnpAyxs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfBGPlq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:41:46 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48402 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGPlq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 10:41:46 -0500
Received: from pendragon.ideasonboard.com (d51A4137F.access.telenet.be [81.164.19.127])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id E18A22EF;
        Thu,  7 Feb 2019 16:41:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549554104;
        bh=b291rOE+wMJvoJwTdx1zp/ueTDOWf+ZlJfOkw+vpkyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PYnpAyxsS3xxxGzG7KqF2WQJpOd9/KGhdKzqLQa/vEK5apuYuJ37af/zhgCd0iTVZ
         STkeIItSfJ0qR+0qs4WeAUcv0eLZCrMiXZpLL6na6HzPdGTDD1fLWfuxYOIu6vglN/
         VM8VtKVRyPmHl6MdUSNNenD3KvKpLWvwBwB4YXMI=
Date:   Thu, 7 Feb 2019 17:41:31 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Subject: Re: [PATCH 3/6] uvc: fix smatch warning
Message-ID: <20190207154131.GE5378@pendragon.ideasonboard.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-4-hverkuil-cisco@xs4all.nl>
 <694295a0-48c0-f35a-47c1-ab89f5c5a866@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <694295a0-48c0-f35a-47c1-ab89f5c5a866@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On Thu, Feb 07, 2019 at 03:57:26PM +0100, Kieran Bingham wrote:
> On 07/02/2019 10:13, Hans Overkill wrote:
> > drivers/media/usb/uvc/uvc_video.c: drivers/media/usb/uvc/uvc_video.c:1893 uvc_video_start_transfer() warn: argument 2 to %u specifier is cast from pointer
> > 
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> This look fine to me.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Even though I believe we should fix tooling instead of code to handle
these issues, the patch for uvcvideo doesn't adversely affect the code,
so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Should I take this in my tree ?

> > ---
> >  drivers/media/usb/uvc/uvcvideo.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > index 9b41b14ce076..c7c1baa90dea 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -620,8 +620,10 @@ struct uvc_streaming {
> >  	     (uvc_urb) < &(uvc_streaming)->uvc_urb[UVC_URBS]; \
> >  	     ++(uvc_urb))
> >  
> > -#define uvc_urb_index(uvc_urb) \
> > -	(unsigned int)((uvc_urb) - (&(uvc_urb)->stream->uvc_urb[0]))
> > +static inline u32 uvc_urb_index(const struct uvc_urb *uvc_urb)
> > +{
> > +	return uvc_urb - &uvc_urb->stream->uvc_urb[0];
> > +}
> > 
> >  struct uvc_device_info {
> >  	u32	quirks;
> > 

-- 
Regards,

Laurent Pinchart
