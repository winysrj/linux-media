Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52522 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758765AbcEFVsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 17:48:36 -0400
Date: Sat, 7 May 2016 00:48:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: nicolas@ndufresne.ca
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [RFC 08/22] videodev2.h: Add request field to
 v4l2_pix_format_mplane
Message-ID: <20160506214829.GP26360@valkosipuli.retiisi.org.uk>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462532011-15527-9-git-send-email-sakari.ailus@linux.intel.com>
 <1462552391.3041.1.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1462552391.3041.1.camel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Fri, May 06, 2016 at 12:33:11PM -0400, Nicolas Dufresne wrote:
> Le vendredi 06 mai 2016 à 13:53 +0300, Sakari Ailus a écrit :
> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > Let userspace specify a request ID when getting or setting formats.
> > The
> > support is limited to the multi-planar API at the moment, extending
> > it
> > to the single-planar API is possible if needed.
> > 
> > From a userspace point of view the API change is also minimized and
> > doesn't require any new ioctl.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboar
> > d.com>
> > ---
> >  include/uapi/linux/videodev2.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h
> > index ac28299..6260d0e 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -1972,6 +1972,7 @@ struct v4l2_plane_pix_format {
> >   * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr
> > encoding
> >   * @quantization:	enum v4l2_quantization, colorspace
> > quantization
> >   * @xfer_func:		enum v4l2_xfer_func, colorspace
> > transfer function
> > + * @request:		request ID
> >   */
> >  struct v4l2_pix_format_mplane {
> >  	__u32				width;
> > @@ -1986,7 +1987,8 @@ struct v4l2_pix_format_mplane {
> >  	__u8				ycbcr_enc;
> >  	__u8				quantization;
> >  	__u8				xfer_func;
> > -	__u8				reserved[7];
> > +	__u8				reserved[3];
> > +	__u32				request;
> 
> Shouldn't the request member be added before the padding ?

In this case, no. The reason is that struct fields are aligned in most ABIs
(and to my knowledge, all ABIs Linux supports by default work that way, some
have looser limitations) to the size of the field. The struct is packed so
unaligned access would work, too, but it'd be more expensive.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
