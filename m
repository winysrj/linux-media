Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50815
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750903AbdCaJsH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 05:48:07 -0400
Date: Fri, 31 Mar 2017 06:47:59 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        jgebben@codeaurora.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/2] [media] docs-rst: add V4L2_INPUT_TYPE_DEFAULT
Message-ID: <20170331064759.4dbab034@vento.lan>
In-Reply-To: <20170330202626.GM16657@valkosipuli.retiisi.org.uk>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
        <1490889738-30009-2-git-send-email-helen.koike@collabora.com>
        <20170330202626.GM16657@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 23:26:26 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Helen and others,
> 
> On Thu, Mar 30, 2017 at 01:02:18PM -0300, Helen Koike wrote:
> > add documentation for V4L2_INPUT_TYPE_DEFAULT
> > 
> > Signed-off-by: Helen Koike <helen.koike@collabora.com>
> > ---
> >  Documentation/media/uapi/v4l/vidioc-enuminput.rst | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> > index 17aaaf9..0237e10 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> > @@ -112,6 +112,9 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
> >      :stub-columns: 0
> >      :widths:       3 1 4
> >  
> > +    * - ``V4L2_INPUT_TYPE_DEFAULT``
> > +      - 0
> > +      - This is the default value returned when no input is supported.

Input *IS* supported. The device has one input. So, the description is wrong ;)

> >      * - ``V4L2_INPUT_TYPE_TUNER``
> >        - 1
> >        - This input uses a tuner (RF demodulator).  
> 
> What would you think of calling this input as "unknown" instead of
> "default"? That's what an input which isn't really specified actually is.

Yeah, default seems a bad name to me, too.

Actually, I think that the best here would be to not create a new type.
just use V4L2_INPUT_TYPE_CAMERA. That's actually the default for the
embedded drivers. If a driver is providing input for something else,
then it should implement vidioc_enuminput method.

Thanks,
Mauro
