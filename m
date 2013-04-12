Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4946 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3DLPgf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:36:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC] Motion Detection API
Date: Fri, 12 Apr 2013 17:36:16 +0200
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kamil Debski <k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304121736.16542.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC looks at adding support for motion detection to V4L2. This is the main
missing piece that prevents the go7007 and solo6x10 drivers from being moved
into mainline from the staging directory.

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

- Add new buffer flags when motion is detected. The go7007 driver would need 4
  bits (one for each region), the others just one. This can be done by taking
  4 bits from the v4l2_buffer flags field. There are still 16 bits left there,
  and if it becomes full, then we still have two reserved fields. I see no
  reason for adding a 'MOTION_ON' flag as the solo6x10 driver does today: just
  check the MOTION_DETECTION control if you want to know if motion detection
  is on or not.

- Add two new ioctls to get and set the block data:

	#define V4L2_MD_HOR_BLOCKS (64)
	#define V4L2_MD_VERT_BLOCKS (48)

	#define V4L2_MD_TYPE_REGION	(1)
	#define V4L2_MD_TYPE_THRESHOLD	(2)

	struct v4l2_md_blocks {
		__u32 type;
		struct v4l2_rect rect;
		__u32 minimum;
		__u32 maximum;
		__u32 reserved[32];
        	__u16 blocks[V4L2_MD_HOR_BLOCKS][V4L2_MD_VERT_BLOCKS];
	};

	#define VIDIOC_G_MD_BLOCKS    _IORW('V', 103, struct v4l2_md_blocks)
	#define VIDIOC_S_MD_BLOCKS    _IORW('V', 104, struct v4l2_md_blocks)

  Apps must fill in type, then can call G_MD_BLOCKS to get the current block
  values for that type. TYPE_REGION returns to which region each block belongs,
  TYPE_THRESHOLD returns threshold values for each block.

  rect returns the rectangle of valid blocks, minimum and maximum the min and max
  values for each 'blocks' array element.

  To change the blocks apps call S_MD_BLOCKS, fill in type, rect (rect is useful
  here to set only a subset of all blocks) and blocks.

So the go7007 would return 45x36 in rect, type would be REGION, min/max would be
0-3.

solo6x10 would return 45x36 in rect, type would be THRESHOLD, min/max would be
0-65535.

TW2804 would return 12x12 in rect, type would be THRESHOLD, min/max would be 0-1.

Comment? Questions?

Regards,

	Hans
