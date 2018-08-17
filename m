Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbeHQNld (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 09:41:33 -0400
Date: Fri, 17 Aug 2018 07:38:28 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, nicolas@ndufresne.ca
Subject: Re: [RFC] Request API questions
Message-ID: <20180817073828.6dbbda32@coco.lan>
In-Reply-To: <3b59475f-b06e-4d9a-868c-04f608677cca@xs4all.nl>
References: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
        <20180816081522.76f71891@coco.lan>
        <CAAFQd5C9y2oZJ7HpRqCVqNhsMgUbnoxcafumX1fU9oXMnjiuww@mail.gmail.com>
        <3b59475f-b06e-4d9a-868c-04f608677cca@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Aug 2018 12:09:40 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 17/08/18 12:02, Tomasz Figa wrote:
> > On Thu, Aug 16, 2018 at 8:15 PM Mauro Carvalho Chehab
> > <mchehab+samsung@kernel.org> wrote:  
> >>
> >> Em Thu, 16 Aug 2018 12:25:25 +0200
> >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>  
> >>> Laurent raised a few API issues/questions in his review of the documentation.
> >>>
> >>> I've consolidated those in this RFC. I would like to know what others think
> >>> and if I should make changes.  
> > 

...

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

Works for me.

Thanks,
Mauro
