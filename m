Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41456 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaDUU6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 16:58:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <posciak@chromium.org>
Subject: Re: [PATCH v2 1/2] v4l: Add resolution change event.
Date: Mon, 21 Apr 2014 22:59:02 +0200
Message-ID: <3623958.Gv7Rj4f0MS@avalon>
In-Reply-To: <CALt3h7921Ad9RCFit70ZFavoKhqjZpYLfvYiXh_ttqnhLQtZSA@mail.gmail.com>
References: <1398072362-24962-1-git-send-email-arun.kk@samsung.com> <1751714.6NNU6hXYoN@avalon> <CALt3h7921Ad9RCFit70ZFavoKhqjZpYLfvYiXh_ttqnhLQtZSA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On Monday 21 April 2014 17:19:26 Arun Kumar K wrote:
> On Mon, Apr 21, 2014 at 3:54 PM, Laurent Pinchart wrote:
> > On Monday 21 April 2014 14:56:01 Arun Kumar K wrote:
> >> From: Pawel Osciak <posciak@chromium.org>
> >> 
> >> This event indicates that the decoder has reached a point in the stream,
> >> at which the resolution changes. The userspace is expected to provide a
> >> new
> >> set of CAPTURE buffers for the new format before decoding can continue.
> >> The event can also be used for more generic events involving resolution
> >> or format changes at runtime for all kinds of video devices.
> >> 
> >> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> >> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> >> ---
> >> 
> >>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   16
> >>  ++++++++++++++++
> >>  include/uapi/linux/videodev2.h                     |    6 ++++++
> >>  2 files changed, 22 insertions(+)
> >> 
> >> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> >> b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml index
> >> 5c70b61..0aec831 100644
> >> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> >> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> >> @@ -155,6 +155,22 @@
> >>           </entry>
> >>         </row>
> >>         <row>
> >> +         <entry><constant>V4L2_EVENT_SOURCE_CHANGE</constant></entry>
> >> +         <entry>5</entry>
> >> +         <entry>
> >> +           <para>This event is triggered when a resolution or format
> >> change +            is detected during runtime by the video device. It
> >> can be a +            runtime resolution change triggered by a video
> >> decoder or the +            format change happening on an HDMI
> >> connector. Application may +            need to reinitialize buffers
> >> before proceeding further.</para> +
> >> +              <para>This event has a &v4l2-event-source-change;
> >> associated
> >> +           with it. This has significance only for v4l2 subdevs where
> >> the
> >> +           <structfield>pad_num</structfield> field will be updated with
> >> +           the pad number on which the event is triggered.</para>
> >> +         </entry>
> >> +       </row>
> >> +       <row>
> >> 
> >>           <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
> >>           <entry>0x08000000</entry>
> >>           <entry>Base event number for driver-private events.</entry>
> >> diff --git a/include/uapi/linux/videodev2.h
> >> b/include/uapi/linux/videodev2.h index 6ae7bbe..12e0614 100644
> >> --- a/include/uapi/linux/videodev2.h
> >> +++ b/include/uapi/linux/videodev2.h
> >> @@ -1733,6 +1733,7 @@ struct v4l2_streamparm {
> >>  #define V4L2_EVENT_EOS                               2
> >>  #define V4L2_EVENT_CTRL                              3
> >>  #define V4L2_EVENT_FRAME_SYNC                        4
> >> +#define V4L2_EVENT_SOURCE_CHANGE             5
> >>  #define V4L2_EVENT_PRIVATE_START             0x08000000
> >>  
> >>  /* Payload for V4L2_EVENT_VSYNC */
> >> @@ -1764,12 +1765,17 @@ struct v4l2_event_frame_sync {
> >>       __u32 frame_sequence;
> >>  };
> >> 
> >> +struct v4l2_event_source_change {
> >> +     __u32 pad_num;
> > 
> > I would call the field just "pad",
> 
> Ok.
> 
> >> +};
> >> +
> >> 
> >>  struct v4l2_event {
> >>       __u32                           type;
> >>       union {
> >>               struct v4l2_event_vsync         vsync;
> >>               struct v4l2_event_ctrl          ctrl;
> >>               struct v4l2_event_frame_sync    frame_sync;
> >> +             struct v4l2_event_source_change source_change;
> >>               __u8                            data[64];
> > 
> > This looks pretty good to me, but I'm a bit concerned about future
> > compatibility. We might need to report more information to userspace, and
> > in particular what has been changed at the source (resolution, format,
> > ...). In order to do so, we'll need to add a flag field to
> > v4l2_event_source_change.
>
> Ok a flag can be added with bitfields for reporting specific event type.

I don't think we need to add it now. Just making sure it can be added later 
without breaking the userspace API would be enough for me.

> > The next __u32 right after the source_change field must thus be zeroed. I
> > see two ways of doing so:
> > 
> > - zeroing the whole data array before setting event-specific data
> > - adding a reserved must-be-zeroed field to v4l2_event_source_change
> > 
> > I like the former better as it's more generic, but we then need to ensure
> > that all drivers zero the whole data field correctly. Adding a new
> > v4l2_event_init() function would help with that.
> 
> Is that a good idea to have an init() function just for zeroing the data
> field? If this is agreed upon, I can add this, but it can be easily missed
> out by drivers.

I'm not sure. On one hand it would be easier to catch missing calls if we use 
a dedicated function, as the function could set an initialized flag in the 
event structure that would be checked by v4l2_event_queue. On the other hand, 
that might be overengineering, and we could just manually check that all 
drivers memset the structure to 0 before initializing fields. In both cases 
the goal is to make sure that the structure is properly initialized, to avoid 
leaking kernel data to userspace, and to avoid breaking the ABI when we'll 
need to extend the v4l2_event_source_change structure. Hans might have an 
opinion on that.

> Also how about the drivers already using the v4l2_event. Should we
> update those drivers too with v4l2_event_init() ?

If we decide to introduce a new function, yes. Otherwise, no :-)

> >>       } u;
> >>       __u32                           pending;

-- 
Regards,

Laurent Pinchart

