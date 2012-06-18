Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37534 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2FRLyu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:54:50 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5T00BVFAG6OQ80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jun 2012 12:55:19 +0100 (BST)
Received: from [106.116.48.198] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M5T00AHPAFBFL50@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jun 2012 12:54:48 +0100 (BST)
Subject: Re: [PATCH 1/2] v4l: added V4L2_BUF_FLAG_EOS flag indicating the last
 frame in the stream
From: Andrzej Hajda <a.hajda@samsung.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	m.szyprowski@samsung.com, k.debski@samsung.com
In-reply-to: <4FDF0FE6.3060301@redhat.com>
References: <1337700835-13634-1-git-send-email-a.hajda@samsung.com>
 <1337700835-13634-2-git-send-email-a.hajda@samsung.com>
 <4FDF0FE6.3060301@redhat.com>
Content-type: text/plain; charset=UTF-8
Date: Mon, 18 Jun 2012 13:54:46 +0200
Message-id: <1340020486.21426.104.camel@AMDC1061>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-06-18 at 08:24 -0300, Mauro Carvalho Chehab wrote:
> Em 22-05-2012 12:33, Andrzej Hajda escreveu:
> > Some devices requires indicator if the buffer is the last one in the stream.
> > Applications and drivers can use this flag in such case.
> > 
> > Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >   Documentation/DocBook/media/v4l/io.xml          |    7 +++++++
> >   Documentation/DocBook/media/v4l/vidioc-qbuf.xml |    2 ++
> >   include/linux/videodev2.h                       |    1 +
> >   3 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > index fd6aca2..dcbf1e0 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -956,6 +956,13 @@ Typically applications shall use this flag for output buffers if the data
> >   in this buffer has not been created by the CPU but by some DMA-capable unit,
> >   in which case caches have not been used.</entry>
> >   	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_EOS</constant></entry>
> > +	    <entry>0x2000</entry>
> > +	    <entry>Application should set this flag in the output buffer
> > +in order to inform the driver about the last frame of the stream. Some
> > +drivers may require it to properly finish processing the stream.</entry>
> 
> This breaks backward compatibility, as applications written before this change
> won't set this flag.

I am preparing a new patch which will use VIDIOC_ENCODER_CMD with
command V4L2_ENC_CMD_STOP and a new flag
V4L2_ENC_CMD_STOP_AFTER_NEXT_FRAME, according to suggestions by Hans
Verkuil. Discussion is at thread started from the parent email (subject
"[PATCH 0/2] s5p-mfc: added encoder support for end of stream
handling").
> 
> > +	  </row>
> >   	</tbody>
> >         </tgroup>
> >       </table>
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> > index 9caa49a..ad49f7d 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> > @@ -76,6 +76,8 @@ supports capturing from specific video inputs and you want to specify a video
> >   input, then <structfield>flags</structfield> should be set to
> >   <constant>V4L2_BUF_FLAG_INPUT</constant> and the field
> >   <structfield>input</structfield> must be initialized to the desired input.
> > +Some drivers expects applications set <constant>V4L2_BUF_FLAG_EOS</constant>
> > +flag on the last buffer of the stream.
> >   The <structfield>reserved</structfield> field must be set to 0. When using
> >   the <link linkend="planar-apis">multi-planar API</link>, the
> >   <structfield>m.planes</structfield> field must contain a userspace pointer
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 370d111..e44a7cd 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -676,6 +676,7 @@ struct v4l2_buffer {
> >   /* Cache handling flags */
> >   #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
> >   #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
> > +#define V4L2_BUF_FLAG_EOS	0x2000	/* The last buffer in the stream */
> >   
> >   /*
> >    *	O V E R L A Y   P R E V I E W
> > 
> 
> 
Regards
Andrzej


