Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1210 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3EMJcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:32:31 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4D9WR2D046456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 13 May 2013 11:32:29 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id B31CB1300054
	for <linux-media@vger.kernel.org>; Mon, 13 May 2013 11:32:26 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFCv2] Motion Detection API
Date: Mon, 13 May 2013 11:32:26 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305131132.26033.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC looks at adding support for motion detection to V4L2. This is the main
missing piece that prevents the go7007 and solo6x10 drivers from being moved
into mainline from the staging directory.

This is the second version of this RFC. The changes are:

- Use a new event to signal motion detection
- Make the blocks array a pointer to data to allow for a larger number of blocks
  (important when dealing with HDTV in the future).


Step one is to look at existing drivers/hardware:

1) The go7007 driver:

        - divides the frame into blocks of 16x16 pixels each (that's 45x36 blocks for PAL)
        - each block can be assigned to region 0, 1, 2 or 3
        - each region has:
                - a pixel change threshold
                - a motion vector change threshold
                - a trigger level; if this is 0, then motion detection for this
                  region is disabled
        - when streaming the reserved field of v4l2_buffer is used as a bitmask:
          one bit for each region where motion is detected.

2) The solo6x10 driver:

        - divides the frame into blocks of 16x16 pixels each
        - each block has its own threshold
        - the driver adds one MOTION_ON buffer flag and one MOTION_DETECTED buffer
          flag.
        - motion detection can be disabled or enabled.
        - the driver has a global motion detection mode with just one threshold:
          in that case all blocks are set to the same threshold.
        - there is also support for displaying a border around the image if motion
          is detected (very hardware specific).

3) The tw2804 video encoder (based on the datasheet, not implemented in the driver):

        - divides the image in 12x12 blocks (block size will differ for NTSC vs PAL)
        - motion detection can be enabled or disabled for each block
        - there are four controls: 
                - luminance level change threshold
                - spatial sensitivity threshold
                - temporal sensitivity threshold
                - velocity control (determines how well slow motions are detected)
        - detection is reported by a hardware pin in this case

Comparing these three examples of motion detection I see quite a lot of similarities,
enough to make a proposal for an API:

- Add a MOTION_DETECTION menu control:
        - Disabled
        - Global Motion Detection
        - Regional Motion Detection

If 'Global Motion Detection' is selected, then various threshold controls become
available. What sort of thresholds are available seems to be quite variable, so
I am inclined to leave this as private controls.

- Use a new event to report motion detection:

  The go7007 driver would need 4 bits for the mask field (one for each region),
  the others just one. I see no reason for adding a 'MOTION_ON' flag as the
  solo6x10 driver does today: just check the MOTION_DETECTION control if you want
  to know if motion detection is on or not.


	#define V4L2_EVENT_MOTION_DET 5

	/**
	 * struct v4l2_event_motion_det - motion detection event
	 * @flags:             if set to V4L2_EVENT_MD_VALID_FRAME, then the
	 *                     frame_sequence field is valid.
	 * @frame_sequence:    the frame sequence number associated with this event.
	 * @mask:              which regions detected motion.
	 */
	struct v4l2_event_motion_det {
	       __u32 flags;
	       __u32 frame_sequence;
	       __u32 mask;
	};	

- Add two new ioctls to get and set the block data:

        #define V4L2_MD_TYPE_REGION     (1)
        #define V4L2_MD_TYPE_THRESHOLD  (2)

        struct v4l2_md_blocks {
                __u32 type;
                struct v4l2_rect rect;
                __u32 block_min;
                __u32 block_max;
		__u32 __user *blocks;
                __u32 reserved[32];
        } __attribute__ ((packed));

        #define VIDIOC_G_MD_BLOCKS    _IORW('V', 103, struct v4l2_md_blocks)
        #define VIDIOC_S_MD_BLOCKS    _IORW('V', 104, struct v4l2_md_blocks)

  Apps must fill in type and blocks, then can call G_MD_BLOCKS to get the current
  block values for that type. TYPE_REGION returns to which region each block belongs,
  TYPE_THRESHOLD returns threshold values for each block.

  If blocks == NULL, then no data is returned, but all other fields are filled in.

  rect returns the rectangle of valid blocks, and blocks_min and blocks_max are the
  min and max values for each 'blocks' array element. If type == REGION, then
  blocks_max is the maximum number of regions - 1.

  blocks points to a buffer of size 'sizeof(__u32) * rect.width * rect.height'.

  To change the blocks apps call S_MD_BLOCKS, fill in type, rect (rect is useful
  here to set only a subset of all blocks) and blocks.

So the go7007 would return 45x36 in rect, only the REGION type would be supported,
min/max would be 0-3.

solo6x10 would return 45x36 in rect, type REGION would return all 0's in blocks
(as there is only one region), and for type THRESHOLD min/max would be 0-65535.

TW2804 would return 12x12 in rect, type REGION would return all 0's in blocks
(as there is only one region), and for type THRESHOLD min/max would be 0-1.

Currently blocks is a __u32 pointer, but that is perhaps overkill. __u16 might
be OK as well.

Comment? Questions?

Regards,

        Hans
