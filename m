Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57293 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751164AbaBZAEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 19:04:10 -0500
Date: Wed, 26 Feb 2014 02:04:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v5 7/7] v4l: Document timestamp buffer flag behaviour
Message-ID: <20140226000405.GG15635@valkosipuli.retiisi.org.uk>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-8-git-send-email-sakari.ailus@iki.fi>
 <5309DF58.9030004@xs4all.nl>
 <20140225170842.GF15635@valkosipuli.retiisi.org.uk>
 <530CD2A6.80906@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530CD2A6.80906@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Feb 25, 2014 at 06:28:06PM +0100, Hans Verkuil wrote:
> On 02/25/2014 06:08 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Sun, Feb 23, 2014 at 12:45:28PM +0100, Hans Verkuil wrote:
> >> On 02/15/2014 09:53 PM, Sakari Ailus wrote:
> >>> Timestamp buffer flags are constant at the moment. Document them so that 1)
> >>> they're always valid and 2) not changed by the drivers. This leaves room to
> >>> extend the functionality later on if needed.
> >>>
> >>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >>> ---
> >>>  Documentation/DocBook/media/v4l/io.xml |   10 ++++++++++
> >>>  1 file changed, 10 insertions(+)
> >>>
> >>> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> >>> index fbd0c6e..4f76565 100644
> >>> --- a/Documentation/DocBook/media/v4l/io.xml
> >>> +++ b/Documentation/DocBook/media/v4l/io.xml
> >>> @@ -653,6 +653,16 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
> >>>  In that case, struct <structname>v4l2_buffer</structname> contains an array of
> >>>  plane structures.</para>
> >>>  
> >>> +    <para>Dequeued video buffers come with timestamps. These
> >>> +    timestamps can be taken from different clocks and at different
> >>> +    part of the frame, depending on the driver. Please see flags in
> >>> +    the masks <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
> >>> +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
> >>> +    linkend="buffer-flags">. These flags are guaranteed to be always
> >>> +    valid and will not be changed by the driver autonomously. Changes
> >>> +    in these flags may take place due as a side effect of
> >>> +    &VIDIOC-S-INPUT; or &VIDIOC-S-OUTPUT; however.</para>
> >>
> >> There is one exception to this: if the timestamps are copied from the output
> >> buffer to the capture buffer (TIMESTAMP_COPY), then it can change theoretically
> >> for every buffer since it entirely depends on what is being sent to it. The
> >> value comes from userspace and you simply don't have any control over that.
> > 
> > Yes; I agree.
> > 
> > And a good point as well --- the timestamp source flags currently come from
> > __fill_v4l2_buffer() which takes them from q->timestamp. This isn't right
> > for m2m devices.
> > 
> > I'll fix and resend (3rd patch most likely).
> 
> You'll want to reference this patch I posted today:
> 
> [RFCv1 PATCH 16/20] vb2: fix timecode and flags handling for output buffers
> 
> Also available in this git repo:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/vb2-part4
> 
> The current implementation in vb2 is actually broken (which is one of the
> things fixed by this patch): if you prepare a buffer (VIDIOC_PREPARE_BUF)
> and only then call VIDIOC_QBUF with a timestamp, that timestamp will be
> lost since it will use the one set by PREPARE_BUF (either that or it is
> zeroed, I've forgotten which of the two it was).
> 
> If you want to take that patch and add your own changes to it, then that's
> fine by me. It should be pretty much standalone.

I'll keep that as-is and write another to pass the timestamp source flags
when needed. Would it be ok if I prepend the patch to the set?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
