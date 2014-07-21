Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37242 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaGUU4l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 16:56:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 03/23] v4l: Support extending the v4l2_pix_format structure
Date: Mon, 21 Jul 2014 22:56:51 +0200
Message-ID: <1941629.cBcif0Vq2p@avalon>
In-Reply-To: <53C83A49.7060501@xs4all.nl>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <53C83A49.7060501@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 17 July 2014 23:04:09 Hans Verkuil wrote:
> Hi Laurent,
> 
> Something that just caught my eye:
> 
> On 06/24/2014 01:54 AM, Laurent Pinchart wrote:
> > The v4l2_pix_format structure has no reserved field. It is embedded in
> > the v4l2_framebuffer structure which has no reserved fields either, and
> > in the v4l2_format structure which has reserved fields that were not
> > previously required to be zeroed out by applications.
> > 
> > To allow extending v4l2_pix_format, inline it in the v4l2_framebuffer
> > structure, and use the priv field as a magic value to indicate that the
> > application has set all v4l2_pix_format extended fields and zeroed all
> > reserved fields following the v4l2_pix_format field in the v4l2_format
> > structure.
> > 
> > The availability of this API extension is reported to userspace through
> > the new V4L2_CAP_EXT_PIX_FORMAT capability flag. Just checking that the
> > priv field is still set to the magic value at [GS]_FMT return wouldn't
> > be enough, as older kernels don't zero the priv field on return.
> > 
> > To simplify the internal API towards drivers zero the extended fields
> > and set the priv field to the magic value for applications not aware of
> > the extensions.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml
> > b/Documentation/DocBook/media/v4l/pixfmt.xml index 91dcbc8..8c56cacd
> > 100644
> > --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> > +++ b/Documentation/DocBook/media/v4l/pixfmt.xml

[snip]

> > +<para>To use the extended fields, applications must set the
> > +<structfield>priv</structfield> field to
> > +<constant>V4L2_PIX_FMT_PRIV_MAGIC</constant>, initialize all the extended
> > fields
> > +and zero the unused bytes of the <structname>v4l2_format</structname>
> > +<structfield>raw_data</structfield> field.</para>
> 
> Easy to write, much harder to implement. You would end up with something
> like:
> 
> memset(&fmt.fmt.pix.flags + sizeof(fmt.fmt.pix.flags), 0,
> 	sizeof(fmt.fmt.raw_data) - sizeof(fmt.fmt.pix));
> 
> Not user-friendly and error-prone.

Or, rather, memset the whole v4l2_format structure to 0 and then fill it.

> I would suggest adding a reserved array to pix_format instead, of at least
> size (10 + 2 * 7) / 4 = 6 __u32. So: __u32 reserved[6]. Better would be to
> go with 10 + 17 = 27 elements (same as the number of reserved elements in
> v4l2_pix_format_mplane and one struct v4l2_plane_pix_format).

Maybe it's a bit late, but I'm not sure to see where you got those values. If 
we want to use a reserved array, it would make more sense to make it cover the 
whole raw_data array, otherwise future extensions could require an API change. 
On the other hand this would result in the v4l2_pix_format structure suddenly 
consuming 200 bytes instead of 36 today. That wouldn't be good when allocated 
on the stack.

> That will allow you to just say that the app should zero the reserved array.

-- 
Regards,

Laurent Pinchart

