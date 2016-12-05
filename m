Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60946 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751080AbcLEOmW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 09:42:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        javier@osg.samsung.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        bjorn.andersson@linaro.org, srinivas.kandagatla@linaro.org
Subject: Re: [PATCH 08/10] media: camss: Add files which handle the video device nodes
Date: Mon, 05 Dec 2016 16:42:33 +0200
Message-ID: <8392504.5O4xIKxA3e@avalon>
In-Reply-To: <9b1cffbc-62a9-c699-5813-189d5f160343@xs4all.nl>
References: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org> <1480085841-28276-7-git-send-email-todor.tomov@linaro.org> <9b1cffbc-62a9-c699-5813-189d5f160343@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 05 Dec 2016 14:44:55 Hans Verkuil wrote:
> > +static int video_querycap(struct file *file, void *fh,
> > +                       struct v4l2_capability *cap)
> > +{
> > +     strlcpy(cap->driver, "qcom-camss", sizeof(cap->driver));
> > +     strlcpy(cap->card, "Qualcomm Camera Subsystem", sizeof(cap->card));
> > +     strlcpy(cap->bus_info, "platform:qcom-camss",
> > sizeof(cap->bus_info));
> > +     cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> > +                                                     V4L2_CAP_DEVICE_CAPS
> > ;
> > +     cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> 
> Don't set capabilities and device_caps here. Instead fill in the struct
> video_device device_caps field and the v4l2 core will take care of
> cap->capabilities and cap->device_caps.

Time to add this to checkpatch.pl ? :-)

> > +
> > +     return 0;
> > +}

-- 
Regards,

Laurent Pinchart

