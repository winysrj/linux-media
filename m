Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40512 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755355AbdHYLu3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 07:50:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "mchehab@s-opensource.com" <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v2] media: open.rst: document devnode-centric and mc-centric types
Date: Fri, 25 Aug 2017 14:51:01 +0300
Message-ID: <34177144.tT2mTFkc37@avalon>
In-Reply-To: <fc2457ae-b4de-67aa-76ca-765f607d7d8d@xs4all.nl>
References: <779378fa18f93929547665467990ff9284a60521.1503576451.git.mchehab@osg.samsung.com> <fc2457ae-b4de-67aa-76ca-765f607d7d8d@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday, 25 August 2017 11:59:40 EEST Hans Verkuil wrote:
> On 24/08/17 14:07, Mauro Carvalho Chehab wrote:
> > From: "mchehab@s-opensource.com" <mchehab@s-opensource.com>
> > 
> > When we added support for omap3, back in 2010, we added a new
> > type of V4L2 devices that aren't fully controlled via the V4L2
> > device node. Yet, we never made it clear, at the V4L2 spec,
> > about the differences between both types.
> > 
> > Let's document them with the current implementation.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> > 
> >  Documentation/media/uapi/v4l/open.rst | 47 ++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/open.rst
> > b/Documentation/media/uapi/v4l/open.rst index afd116edb40d..cf522d9bb53c
> > 100644
> > --- a/Documentation/media/uapi/v4l/open.rst
> > +++ b/Documentation/media/uapi/v4l/open.rst
> > @@ -6,6 +6,53 @@
> > 
> >  Opening and Closing Devices
> >  ***************************
> > 
> > +Types of V4L2 device control
> 
> I don't like calling this 'device control'. Mostly because the word 'device'
> can mean almost anything and is very overused.
> 
> How about "hardware control"?

The word device is used for different purposes that make the text unclear in 
my opinion. We have at least three different kinds of devices:

- device node
- kernel struct device (fortunately not relevant to the V4L2 API discussion)
- hardware counterpart of the kernel struct device (SoC IP core, I2C chip, 
...)
- group of hardware devices that together make a larger user-facing functional 
device (for instance the SoC ISP IP cores and external camera sensors together 
make a camera device)

We need different terms for those different concepts, and we need to be very 
consistent in our usage of those terms. I believe we should also define them 
formally at the beginning of the documentation to avoid confusion.

[snip]

-- 
Regards,

Laurent Pinchart
