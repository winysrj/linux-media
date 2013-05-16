Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:3207 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3EPHzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 03:55:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [RFCv2] Motion Detection API
Date: Thu, 16 May 2013 09:54:54 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201305131132.26033.hverkuil@xs4all.nl> <5193A875.3000805@gmail.com>
In-Reply-To: <5193A875.3000805@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305160954.54413.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester!

On Wed 15 May 2013 17:23:33 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 05/13/2013 11:32 AM, Hans Verkuil wrote:
> > This RFC looks at adding support for motion detection to V4L2. This is the main
> > missing piece that prevents the go7007 and solo6x10 drivers from being moved
> > into mainline from the staging directory.
> >
> > This is the second version of this RFC. The changes are:
> >
> > - Use a new event to signal motion detection
> > - Make the blocks array a pointer to data to allow for a larger number of blocks
> >    (important when dealing with HDTV in the future).
> 
> This version looks much better. :)

Thanks!

> 
> > Step one is to look at existing drivers/hardware:
> >
> > 1) The go7007 driver:
> >
> >          - divides the frame into blocks of 16x16 pixels each (that's 45x36 blocks for PAL)
> >          - each block can be assigned to region 0, 1, 2 or 3
> >          - each region has:
> >                  - a pixel change threshold
> >                  - a motion vector change threshold
> >                  - a trigger level; if this is 0, then motion detection for this
> >                    region is disabled
> >          - when streaming the reserved field of v4l2_buffer is used as a bitmask:
> >            one bit for each region where motion is detected.
> >
> > 2) The solo6x10 driver:
> >
> >          - divides the frame into blocks of 16x16 pixels each
> >          - each block has its own threshold
> >          - the driver adds one MOTION_ON buffer flag and one MOTION_DETECTED buffer
> >            flag.
> >          - motion detection can be disabled or enabled.
> >          - the driver has a global motion detection mode with just one threshold:
> >            in that case all blocks are set to the same threshold.
> >          - there is also support for displaying a border around the image if motion
> >            is detected (very hardware specific).
> 
> As a side note, there is a similar functionality for face detection 
> feature in the
> Toshiba M-5MOLS and Samsung S5C73M3 camera modules, i.e. a rectangle 
> around detected
> face(s) can be blended by the hardware into the output frames. Even the 
> line's
> thickness (and colour) can be configurable. Such borders look a bit 
> obscure to my
> taste, I guess such things are normally added at GPU stage. Nevertheless 
> such
> functionality seems to be supported by multiple devices.

Thanks for the info. At some point we might want to compare the various
implementations for this and see if there is some common ground.

> > 3) The tw2804 video encoder (based on the datasheet, not implemented in the driver):
> >
> >          - divides the image in 12x12 blocks (block size will differ for NTSC vs PAL)
> >          - motion detection can be enabled or disabled for each block
> >          - there are four controls:
> >                  - luminance level change threshold
> >                  - spatial sensitivity threshold
> >                  - temporal sensitivity threshold
> >                  - velocity control (determines how well slow motions are detected)
> >          - detection is reported by a hardware pin in this case
> >
> > Comparing these three examples of motion detection I see quite a lot of similarities,
> > enough to make a proposal for an API:
> >
> > - Add a MOTION_DETECTION menu control:
> >          - Disabled
> >          - Global Motion Detection
> >          - Regional Motion Detection
> >
> > If 'Global Motion Detection' is selected, then various threshold controls become
> > available. What sort of thresholds are available seems to be quite variable, so
> > I am inclined to leave this as private controls.
> >
> > - Use a new event to report motion detection:
> >
> >    The go7007 driver would need 4 bits for the mask field (one for each region),
> >    the others just one. I see no reason for adding a 'MOTION_ON' flag as the
> >    solo6x10 driver does today: just check the MOTION_DETECTION control if you want
> >    to know if motion detection is on or not.
> 
> Yes, it looks odd 'MOTION_ON' was a buffer flag in the first place, as 
> it would be
> required to control the motion detection per buffer. But AFAICS that's 
> not the case.

No, it isn't the case. You get this flag back from the driver, you don't set it,
so it is pretty pointless if you also have a control that you can just read.
 
> > 	#define V4L2_EVENT_MOTION_DET 5
> >
> > 	/**
> > 	 * struct v4l2_event_motion_det - motion detection event
> > 	 * @flags:             if set to V4L2_EVENT_MD_VALID_FRAME, then the
> > 	 *                     frame_sequence field is valid.
> > 	 * @frame_sequence:    the frame sequence number associated with this event.
> > 	 * @mask:              which regions detected motion.
> > 	 */
> > 	struct v4l2_event_motion_det {
> > 	       __u32 flags;
> > 	       __u32 frame_sequence;
> > 	       __u32 mask;
> > 	};	
> >
> > - Add two new ioctls to get and set the block data:
> >
> >          #define V4L2_MD_TYPE_REGION     (1)
> >          #define V4L2_MD_TYPE_THRESHOLD  (2)
> >
> >          struct v4l2_md_blocks {
> >                  __u32 type;
> >                  struct v4l2_rect rect;
> >                  __u32 block_min;
> >                  __u32 block_max;
> > 		__u32 __user *blocks;
> >                  __u32 reserved[32];
> >          } __attribute__ ((packed));
> 
> How about changing it to:
> 
>            struct v4l2_md_blocks {
>                  __u32 type;
>                  __u32 size;
>                  struct v4l2_rect rect;
>                  __u32 block_min;
>                  __u32 block_max;
>                  __u32 reserved[32];
>   		__u16 __user blocks[];
>            } __attribute__ ((packed));
> 
> i.e. making 'blocks' a flexible length array, so the size of the structure
> is same on 32 and 64-bit architectures ? And we don't need any compat code ?
> 'size' would indicate actual size of the blocks array.

Nice idea, but it won't work: video_usercopy() will copy that struct to a
kernel-space buffer and pass that on to the driver. But at that point the
blocks array is cut off and the driver doesn't have access to the userspace
pointer anymore.

It's really not all that difficult to add compat code for this, so I'll just
stick with a pointer.

> 
> Also, the motion detection normally involves at least 2 frames, but 
> don't we
> need a means to get MD result per frame ? Since the event is per frame ?
> I guess this is something that could be added later if required.

???

The event provides the result on a per-frame basis. Actually, it doesn't
have to be per-frame: if flags == 0, it will depend on the hardware whether
you can actually relate motion to frames.

I just realized that there is a hole in this RFC if flags == 0: if the motion
detection is not per-frame, but just some global state, then we also need a
way to tell userspace when the motion stopped.

My original idea was that you get an event per frame where there is motion.
So if you get a frame but no associated event, then motion stopped.

An alternative implementation would be that you get an event whenever the
mask changes value (with the assumption that mask == 0 when you start
streaming).

I think this might be more efficient and it works better if you can't
associate this event with a specific frame.

What do you think?

> 
> I have been thinking about similar dedicated ioctl for object detection 
> features,
> then the OD result would have associated frame_sequence with it. I'm 
> going to
> look closer at your extended event payload RFC and perhaps prepare some POC
> implementation using that idea. However I'm inclined to use dedicated 
> ioctl(s)
> and v4l2 events and controls for OD.
> 
> >          #define VIDIOC_G_MD_BLOCKS    _IORW('V', 103, struct v4l2_md_blocks)
> >          #define VIDIOC_S_MD_BLOCKS    _IORW('V', 104, struct v4l2_md_blocks)
> >
> >    Apps must fill in type and blocks, then can call G_MD_BLOCKS to get the current
> >    block values for that type. TYPE_REGION returns to which region each block belongs,
> >    TYPE_THRESHOLD returns threshold values for each block.
> >
> >    If blocks == NULL, then no data is returned, but all other fields are filled in.
> >
> >    rect returns the rectangle of valid blocks, and blocks_min and blocks_max are the
> >    min and max values for each 'blocks' array element. If type == REGION, then
> >    blocks_max is the maximum number of regions - 1.
> >
> >    blocks points to a buffer of size 'sizeof(__u32) * rect.width * rect.height'.
> >
> >    To change the blocks apps call S_MD_BLOCKS, fill in type, rect (rect is useful
> >    here to set only a subset of all blocks) and blocks.
> >
> > So the go7007 would return 45x36 in rect, only the REGION type would be supported,
> > min/max would be 0-3.
> >
> > solo6x10 would return 45x36 in rect, type REGION would return all 0's in blocks
> > (as there is only one region), and for type THRESHOLD min/max would be 0-65535.
> >
> > TW2804 would return 12x12 in rect, type REGION would return all 0's in blocks
> > (as there is only one region), and for type THRESHOLD min/max would be 0-1.
> >
> > Currently blocks is a __u32 pointer, but that is perhaps overkill. __u16 might
> > be OK as well.
> 
> I would expect u16 to be large enough. For small rectangles this array 
> may become
> significantly large. In theory we could have 1x1 'rectangles' and size 
> of the blocks
> array would be comparable to the image size ?

Right, I'll switch to u16.

Thanks for your comments!

Regards,

	Hans
