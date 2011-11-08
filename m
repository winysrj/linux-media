Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40599 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab1KHLqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 06:46:38 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] v4l2 doc: Added
 FBUF_CAP_SRC_CHROMAKEY/FLAG_SRC_CHROMAKEY
Date: Tue, 8 Nov 2011 11:46:32 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A8025FDD@DBDE01.ent.ti.com>
References: <hvaibhav@ti.com>
 <1257864345-13595-1-git-send-email-hvaibhav@ti.com>
 <201111071435.39805.hverkuil@xs4all.nl>
In-Reply-To: <201111071435.39805.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Monday, November 07, 2011 7:06 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org
> Subject: Re: [PATCH] v4l2 doc: Added
> FBUF_CAP_SRC_CHROMAKEY/FLAG_SRC_CHROMAKEY
> 
> Hi Vaibhav!
> 
> This is a bit of a 'blast from the past', but when I went through the
> documentation of the framebuffer flags in the V4L2 spec I noticed that the
> definition of V4L2_FBUF_CAP_SRC_CHROMAKEY seemed to be wrong.
> 
> The definition of V4L2_FBUF_CAP_CHROMAKEY says:
	> 
> 'The device supports clipping by chroma-keying the
> images. That is, image pixels replace pixels in the VGA or video
> signal only where the latter assume a certain color. Chroma-keying
> makes no sense for destructive overlays.'
> 
> The definition of V4L2_FBUF_CAP_SRC_CHROMAKEY says:
> 
> 'The device supports Source Chroma-keying. Framebuffer pixels
> with the chroma-key colors are replaced by video pixels, which
> is exactly opposite of V4L2_FBUF_CAP_CHROMAKEY.'
> 
> As far as I can tell these definitions are really the same. I would expect
> that V4L2_FBUF_CAP_SRC_CHROMAKEY was defined as:
> 
> 'The device supports Source Chroma-keying. Video pixels
> with the chroma-key colors are replaced by framebuffer pixels, which
> is exactly opposite of V4L2_FBUF_CAP_CHROMAKEY.'
> 
> The only driver that implements this is omap_vout.c. So is the mistake
> in the documentation or in the driver? I think the documentation is wrong
> in this case.
> 
I remember long time back we had discussion on this, we consider
V4L2_FBUF_CAP_CHROMAKEY as a destination color keying (term used in OMAP
spec) and V4L2_FBUF_CAP_SRC_CHROMAKEY as a source color keying(term used in
OMAP spec).

As per OMAP spec the source color key is, replace video pixels by underneath gfx pixels based on chroma-key color. I think we aligned in this at that time, isn't it? AM I missing something?


FYI, as per OMAP spec,

Destination color keying:
The graphics destination transparency color key value defines the encoded
pixels in the video layers to be displayed. The encoded pixel values with
the destination color key value are pixels not visible on the screen and the
pixels different from the transparency color key are displayed over the
video layers. The destination transparency color key is applicable only in
the graphics region when graphics and video overlap; otherwise, the
destination transparency color key is ignored.


Source color keying:
The video source transparency color key value defines the encoded pixel data
considered as the transparent pixel. The encoded pixel values with the
source color key value are pixels not visible on the screen, and the
underlayer encoded pixel values or solid background color are visible.


Thanks,
Vaibhav

> Regards,
> 
> 	Hans
> 
> On Tuesday, November 10, 2009 15:45:45 hvaibhav@ti.com wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> >
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  linux/Documentation/DocBook/v4l/videodev2.h.xml   |    2 ++
> >  linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml |   17
> +++++++++++++++++
> >  2 files changed, 19 insertions(+), 0 deletions(-)
> >
> > diff --git a/linux/Documentation/DocBook/v4l/videodev2.h.xml
> b/linux/Documentation/DocBook/v4l/videodev2.h.xml
> > index 9700206..eef7ba4 100644
> > --- a/linux/Documentation/DocBook/v4l/videodev2.h.xml
> > +++ b/linux/Documentation/DocBook/v4l/videodev2.h.xml
> > @@ -565,6 +565,7 @@ struct <link linkend="v4l2-
> framebuffer">v4l2_framebuffer</link> {
> >  #define V4L2_FBUF_CAP_LOCAL_ALPHA       0x0010
> >  #define V4L2_FBUF_CAP_GLOBAL_ALPHA      0x0020
> >  #define V4L2_FBUF_CAP_LOCAL_INV_ALPHA   0x0040
> > +#define V4L2_FBUF_CAP_SRC_CHROMAKEY     0x0080
> >  /*  Flags for the 'flags' field. */
> >  #define V4L2_FBUF_FLAG_PRIMARY          0x0001
> >  #define V4L2_FBUF_FLAG_OVERLAY          0x0002
> > @@ -572,6 +573,7 @@ struct <link linkend="v4l2-
> framebuffer">v4l2_framebuffer</link> {
> >  #define V4L2_FBUF_FLAG_LOCAL_ALPHA      0x0008
> >  #define V4L2_FBUF_FLAG_GLOBAL_ALPHA     0x0010
> >  #define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA  0x0020
> > +#define V4L2_FBUF_FLAG_SRC_CHROMAKEY    0x0040
> >
> >  struct <link linkend="v4l2-clip">v4l2_clip</link> {
> >          struct <link linkend="v4l2-rect">v4l2_rect</link>        c;
> > diff --git a/linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml
> b/linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml
> > index f701706..e7dda48 100644
> > --- a/linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml
> > +++ b/linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml
> > @@ -336,6 +336,13 @@ alpha value. Alpha blending makes no sense for
> destructive overlays.</entry>
> >  inverted alpha channel of the framebuffer or VGA signal. Alpha
> >  blending makes no sense for destructive overlays.</entry>
> >  	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_FBUF_CAP_SRC_CHROMAKEY</constant></entry>
> > +	    <entry>0x0080</entry>
> > +	    <entry>The device supports Source Chroma-keying. Framebuffer
> pixels
> > +with the chroma-key colors are replaced by video pixels, which is
> exactly opposite of
> > +<constant>V4L2_FBUF_CAP_CHROMAKEY</constant></entry>
> > +	  </row>
> >  	</tbody>
> >        </tgroup>
> >      </table>
> > @@ -411,6 +418,16 @@ images, but with an inverted alpha value. The blend
> function is:
> >  output = framebuffer pixel * (1 - alpha) + video pixel * alpha. The
> >  actual alpha depth depends on the framebuffer pixel format.</entry>
> >  	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_FBUF_FLAG_SRC_CHROMAKEY</constant></entry>
> > +	    <entry>0x0040</entry>
> > +	    <entry>Use source chroma-keying. The source chroma-key color is
> > +determined by the <structfield>chromakey</structfield> field of
> > +&v4l2-window; and negotiated with the &VIDIOC-S-FMT; ioctl, see <xref
> > +linkend="overlay" /> and <xref linkend="osd" />.
> > +Both chroma-keying are mutual exclusive to each other, so same
> > +<structfield>chromakey</structfield> field of &v4l2-window; is being
> used.</entry>
> > +	  </row>
> >  	</tbody>
> >        </tgroup>
> >      </table>
> >
