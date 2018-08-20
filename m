Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:42065 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbeHTKce (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 06:32:34 -0400
Received: by mail-yb0-f194.google.com with SMTP id y130-v6so4227168yby.9
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 00:18:05 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id t2-v6sm3368777ywd.99.2018.08.20.00.18.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Aug 2018 00:18:03 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id y134-v6so2658937ywg.1
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 00:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
 <20180816081522.76f71891@coco.lan> <CAAFQd5C9y2oZJ7HpRqCVqNhsMgUbnoxcafumX1fU9oXMnjiuww@mail.gmail.com>
 <3b59475f-b06e-4d9a-868c-04f608677cca@xs4all.nl>
In-Reply-To: <3b59475f-b06e-4d9a-868c-04f608677cca@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 20 Aug 2018 16:17:51 +0900
Message-ID: <CAAFQd5DsGgdUrfhcvBHyzbAHpKuFV_oTiBxVQKPYpWu1GtFz-w@mail.gmail.com>
Subject: Re: [RFC] Request API questions
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, nicolas@ndufresne.ca
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Aug 17, 2018 at 7:09 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 17/08/18 12:02, Tomasz Figa wrote:
> > On Thu, Aug 16, 2018 at 8:15 PM Mauro Carvalho Chehab
> > <mchehab+samsung@kernel.org> wrote:
> >>
> >> Em Thu, 16 Aug 2018 12:25:25 +0200
> >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>
[snip]
> >>> 3) Calling VIDIOC_G_EXT_CTRLS for a request that has not been queued yet will
> >>>    return either the value of the control you set earlier in the request, or
> >>>    the current HW control value if it was never set in the request.
> >>>
> >>>    I believe it makes sense to return what was set in the request previously
> >>>    (if you set it, you should be able to get it), but it is an idea to return
> >>>    ENOENT when calling this for controls that are NOT in the request.
> >>>
> >>>    I'm inclined to implement that. Opinions?
> >>
> >> Return the request "cached" value, IMO, doesn't make sense. If the
> >> application needs such cache, it can implement itself.
> >
> > Can we think about any specific use cases for a user space that first
> > sets a control value to a request and then needs to ask the kernel to
> > get the value back? After all, it was the user space which set the
> > value, so I'm not sure if there is any need for the kernel to be an
> > intermediary here.
> >
> >>
> >> Return an error code if the request has not yet completed makes
> >> sense. Not sure what would be the best error code here... if the
> >> request is queued already (but not processed), EBUSY seems to be the
> >> better choice, but, if it was not queued yet, I'm not sure. I guess
> >> ENOENT would work.
> >
> > IMHO, as far as we assign unique error codes for different conditions
> > and document them well, we should be okay with any not absurdly
> > mismatched code. After all, most of those codes are defined for file
> > system operations and don't really map directly to anything else.
> >
> > FYI, VIDIOC_G_(EXT_)CTRL returns EINVAL if an unsupported control is
> > queried, so if we decided to keep the "cache" functionality after all,
> > perhaps we should stay consistent with it?
> > Reference: https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-ext-ctrls.html#return-value
> >
> > My suggestion would be:
> >  - EINVAL: the control was not in the request, (if we keep the cache
> > functionality)
> >  - EPERM: the value is not ready, (we selected this code for Decoder
> > Interface to mean that CAPTURE format is not ready, which is similar;
> > perhaps that could be consistent?)
> >
> > Note that EINVAL would only apply to writable controls, while EPERM
> > only to volatile controls, since the latter can only change due to
> > request completion (non-volatile controls can only change as an effect
> > of user space action).
> >
>
> I'm inclined to just always return EPERM when calling G_EXT_CTRLS for
> a request. We can always relax this in the future.
>
> So when a request is not yet queued G_EXT_CTRLS returns EPERM, when
> queued but not completed it returns EBUSY and once completed it will
> work as it does today.

Not sure I'm following. What do we differentiate between with EPERM
and EBUSY? In both cases the value is not available yet and for codecs
we decided to have that signaled by EPERM.

On top of that, I still think we should be able to tell the case of
querying for a control that can never show up in the request, even
after it completes, specifically for any non-volatile control. That
could be done by returning a different code and -EINVAL would match
the control API behavior without requests.

The general logic would be like the pseudo code below:

G_EXT_CTRLS()
{
    if ( control is not volatile )
        return -EINVAL;

    if ( request is not complete )
        return -EPERM;

    return control from the request;
}

Best regards,
Tomasz
