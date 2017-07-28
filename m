Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51153 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751740AbdG1NFq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 09:05:46 -0400
Date: Fri, 28 Jul 2017 15:03:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/6 v5] uvcvideo: add a metadata device node
In-Reply-To: <ee61391f-4183-eaf3-437a-666652cd4f23@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1707281453220.16637@axis700.grange>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
 <1501245205-15802-5-git-send-email-g.liakhovetski@gmx.de>
 <ee61391f-4183-eaf3-437a-666652cd4f23@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 28 Jul 2017, Hans Verkuil wrote:

> On 07/28/2017 02:33 PM, Guennadi Liakhovetski wrote:

[snip]

> > +/**
> > + * struct uvc_meta_buf - metadata buffer building block
> > + * @ns		- system timestamp of the payload in nanoseconds
> > + * @sof		- USB Frame Number
> > + * @length	- length of the payload header
> > + * @flags	- payload header flags
> > + * @buf		- optional device-specific header data
> > + *
> > + * UVC metadata nodes fill buffers with possibly multiple instances of this
> > + * struct. The first two fields are added by the driver, they can be used for
> > + * clock synchronisation. The rest is an exact copy of a UVC payload header.
> > + * Only complete objects with complete buffers are included. Therefore it's
> > + * always sizeof(meta->ts) + sizeof(meta->sof) + meta->length bytes large.
> > + */
> > +struct uvc_meta_buf {
> > +	__u64 ns;
> > +	__u16 sof;
> > +	__u8 length;
> > +	__u8 flags;
> 
> I think the struct layout is architecture dependent. I could be wrong, but I think
> for x64 there is a 4-byte hole here, but not for arm32/arm64.
> 
> Please double-check the struct layout.

It worked for me so far on an x86-64 system, I was able to access buffer 
data correctly, but yes, it's probably safer to use __packed.

> BTW: __u8 for length? The payload can never be longer in UVC?

No, it cannot. That's exactly how UVC defines it.

Thanks
Guennadi

> 
> Regards,
> 
> 	Hans
> 
> > +	__u8 buf[];
> > +};
> > +
> >  #endif
> > 
> 
