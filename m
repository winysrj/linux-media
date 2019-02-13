Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D81C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 10:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9F892190A
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 10:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391472AbfBMKjA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:39:00 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:47697 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbfBMKjA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 05:39:00 -0500
X-Greylist: delayed 4700 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2019 05:38:58 EST
Received: from aptenodytes (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 20FF220000F;
        Wed, 13 Feb 2019 10:38:56 +0000 (UTC)
Message-ID: <7877d69965ca7ee4caa3a26e17137c535776e61e.camel@bootlin.com>
Subject: Re: [PATCHv2 4/6] videodev2.h: add V4L2_CTRL_FLAG_REQUIRES_REQUESTS
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Date:   Wed, 13 Feb 2019 11:38:56 +0100
In-Reply-To: <e334fb92-31a2-28c0-02e4-a9ccac49ba03@xs4all.nl>
References: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
         <20190211101357.48754-5-hverkuil-cisco@xs4all.nl>
         <e334fb92-31a2-28c0-02e4-a9ccac49ba03@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Mon, 2019-02-11 at 14:04 +0100, Hans Verkuil wrote:
> On 2/11/19 11:13 AM, Hans Verkuil wrote:
> > Indicate if a control can only be set through a request, as opposed
> > to being set directly. This is necessary for stateless codecs where
> > it makes no sense to set the state controls directly.
> 
> Kwiboo on irc pointed out that this clashes with this line the in Initialization
> section of the stateless decoder API:
> 
> "Call VIDIOC_S_EXT_CTRLS() to set all the controls (parsed headers, etc.) required
>  by the OUTPUT format to enumerate the CAPTURE formats."
> 
> So for now ignore patches 4-6: I need to think about this some more.
> 
> My worry here is what happens when userspace is adding these controls to a
> request and at the same time sets them directly. That may cause weird side-effects.

This seems to be a very legitimate concern, as nothing guarantees that
the controls setup by v4l2_ctrl_request_setup won't be overridden
before the driver uses them.

One solution could be to mark the controls as "in use" when the request
has new data for them, clear that in v4l2_ctrl_request_complete and
return EBUSY when trying to set the control in between the two calls.

This way, we ensure that any control set via a request will retain the
value passed with the request, which is independent from the control
itself (so we don't need special handling for stateless codec
controls). It also allows setting the control outside of a request for
enumerating formats.

What do you think?

Cheers,

Paul

> Regards,
> 
> 	Hans
> 
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > ---
> >  .../media/uapi/v4l/vidioc-queryctrl.rst       |  4 ++++
> >  .../media/videodev2.h.rst.exceptions          |  1 +
> >  include/uapi/linux/videodev2.h                | 23 ++++++++++---------
> >  3 files changed, 17 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > index f824162d0ea9..b08c69cedb92 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > @@ -539,6 +539,10 @@ See also the examples in :ref:`control`.
> >  	``V4L2_CTRL_FLAG_GRABBED`` flag when buffers are allocated or
> >  	streaming is in progress since most drivers do not support changing
> >  	the format in that case.
> > +    * - ``V4L2_CTRL_FLAG_REQUIRES_REQUESTS``
> > +      - 0x0800
> > +      - This control cannot be set directly, but only through a request
> > +        (i.e. by setting ``which`` to ``V4L2_CTRL_WHICH_REQUEST_VAL``).
> >  
> >  
> >  Return Value
> > diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
> > index 64d348e67df9..0caa72014dba 100644
> > --- a/Documentation/media/videodev2.h.rst.exceptions
> > +++ b/Documentation/media/videodev2.h.rst.exceptions
> > @@ -351,6 +351,7 @@ replace define V4L2_CTRL_FLAG_VOLATILE control-flags
> >  replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
> >  replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
> >  replace define V4L2_CTRL_FLAG_MODIFY_LAYOUT control-flags
> > +replace define V4L2_CTRL_FLAG_REQUIRES_REQUESTS control-flags
> >  
> >  replace define V4L2_CTRL_FLAG_NEXT_CTRL control
> >  replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 7f035d44666e..a78bfdc1df97 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -1736,17 +1736,18 @@ struct v4l2_querymenu {
> >  } __attribute__ ((packed));
> >  
> >  /*  Control flags  */
> > -#define V4L2_CTRL_FLAG_DISABLED		0x0001
> > -#define V4L2_CTRL_FLAG_GRABBED		0x0002
> > -#define V4L2_CTRL_FLAG_READ_ONLY	0x0004
> > -#define V4L2_CTRL_FLAG_UPDATE		0x0008
> > -#define V4L2_CTRL_FLAG_INACTIVE		0x0010
> > -#define V4L2_CTRL_FLAG_SLIDER		0x0020
> > -#define V4L2_CTRL_FLAG_WRITE_ONLY	0x0040
> > -#define V4L2_CTRL_FLAG_VOLATILE		0x0080
> > -#define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
> > -#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
> > -#define V4L2_CTRL_FLAG_MODIFY_LAYOUT	0x0400
> > +#define V4L2_CTRL_FLAG_DISABLED			0x0001
> > +#define V4L2_CTRL_FLAG_GRABBED			0x0002
> > +#define V4L2_CTRL_FLAG_READ_ONLY		0x0004
> > +#define V4L2_CTRL_FLAG_UPDATE			0x0008
> > +#define V4L2_CTRL_FLAG_INACTIVE			0x0010
> > +#define V4L2_CTRL_FLAG_SLIDER			0x0020
> > +#define V4L2_CTRL_FLAG_WRITE_ONLY		0x0040
> > +#define V4L2_CTRL_FLAG_VOLATILE			0x0080
> > +#define V4L2_CTRL_FLAG_HAS_PAYLOAD		0x0100
> > +#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE		0x0200
> > +#define V4L2_CTRL_FLAG_MODIFY_LAYOUT		0x0400
> > +#define V4L2_CTRL_FLAG_REQUIRES_REQUESTS	0x0800
> >  
> >  /*  Query flags, to be ORed with the control ID */
> >  #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
> > 
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

