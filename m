Return-path: <mchehab@localhost>
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:4729 "EHLO
	rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1GFLQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 07:16:37 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p66BGXME007433
	for <linux-media@vger.kernel.org>; Wed, 6 Jul 2011 11:16:36 GMT
Received: from cobaltpc1.localnet ([10.54.77.72])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p66BGY7V031410
	for <linux-media@vger.kernel.org>; Wed, 6 Jul 2011 13:16:35 +0200
From: Hans Verkuil <hansverk@cisco.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: Changes to preset handling
Date: Wed, 6 Jul 2011 13:16:12 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061316.12948.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

There has been some discussion recently regarding the preset API:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg33774.html

The current presets are:

#define         V4L2_DV_INVALID         0
#define         V4L2_DV_480P59_94       1 /* BT.1362 */
#define         V4L2_DV_576P50          2 /* BT.1362 */
#define         V4L2_DV_720P24          3 /* SMPTE 296M */
#define         V4L2_DV_720P25          4 /* SMPTE 296M */
#define         V4L2_DV_720P30          5 /* SMPTE 296M */
#define         V4L2_DV_720P50          6 /* SMPTE 296M */
#define         V4L2_DV_720P59_94       7 /* SMPTE 274M */
#define         V4L2_DV_720P60          8 /* SMPTE 274M/296M */
#define         V4L2_DV_1080I29_97      9 /* BT.1120/ SMPTE 274M */
#define         V4L2_DV_1080I30         10 /* BT.1120/ SMPTE 274M */
#define         V4L2_DV_1080I25         11 /* BT.1120 */
#define         V4L2_DV_1080I50         12 /* SMPTE 296M */
#define         V4L2_DV_1080I60         13 /* SMPTE 296M */
#define         V4L2_DV_1080P24         14 /* SMPTE 296M */
#define         V4L2_DV_1080P25         15 /* SMPTE 296M */
#define         V4L2_DV_1080P30         16 /* SMPTE 296M */
#define         V4L2_DV_1080P50         17 /* BT.1120 */
#define         V4L2_DV_1080P60         18 /* BT.1120 */

One thing that needs to change is that the comments should refer to the
CEA-861 standard since all these presets are from that document. The other
thing is that the macros should contain the name of the standard and the
exact resolution. This allows for adding presets from other standards
such as the VESA DMT standard.

The proposed list of presets would look like this:

#define         V4L2_DV_INVALID                    0
#define         V4L2_DV_CEA861_720X480P59_94       1 /* CEA-861, VIC 2, 3 */
#define         V4L2_DV_480P59_94       V4L2_DV_CEA861_720X480P59_94
#define         V4L2_DV_CEA861_720X576P50          2 /* CEA-861, VIC 17, 18 */
#define         V4L2_DV_576P50          V4L2_DV_CEA861_720X576P50
#define         V4L2_DV_CEA861_1280X720P24         3 /* CEA-861, VIC 60 */
#define         V4L2_DV_720P24          V4L2_DV_CEA861_1280X720P24
...
#define         V4L2_DV_CEA861_1280X720P59_94      7 /* CEA-861, VIC 4 */
#define         V4L2_DV_720P59_94       V4L2_DV_CEA861_1280X720P59_94
#define         V4L2_DV_CEA861_1280X720P60         8 /* CEA-861, VIC 4 */
#define         V4L2_DV_720P60          V4L2_DV_CEA861_1280X720P60
...

The old names become aliases to the new ones.

I would also like to reserve the range 1-65535 for the CEA presets, so a comment
is needed for this.

The other part that needs to be extended is struct v4l2_dv_enum_presets. Currently
this returns a human readable description of the format and the width and height.

What is missing is the fps or frame period and a flags field that can tell whether
this is an interlaced or progressive format.

So I propose to extend the struct as follows:

struct v4l2_dv_enum_preset {
        __u32   index;
        __u32   preset;
        __u8    name[32]; /* Name of the preset timing */
        __u32   width;
        __u32   height;
        struct v4l2_fract fps;
        __u32   flags;
        __u32   reserved[1];
};

#define V4L2_DV_ENUM_FL_INTERLACED (1 << 0)

What is better: that the v4l2_fract represents frames-per-second or that it represents
time-per-frame? G/S_PARM uses the latter, but I find the first more logical.

Another thing that is missing in VIDIOC_ENUM_DV_PRESETS is that you cannot put in a
specific preset and get back this information. Instead it is index based. This is fine
when you want to enumerate all available presets, but it is annoying when you want to
find the specifics one particular preset.

I propose that we define a specific index value (e.g. 0x80000000) that will let the
driver return the information about the preset instead (or -EINVAL if the preset is
not supported by the driver). So:

#define V4L2_DV_ENUM_USE_PRESET 0x80000000

A separate issue is how to handle calculated modes based on the VESA GTF and CVT
standards. For a video transmitter the VIDIOC_S_DV_TIMINGS can be used, although
the application has to do the calculations. For video receiving things are much
more complex. This needs more research. There are several possibilities, but it
isn't clear which works best. Some experimentation is needed, but due to vacations
this will have to be postponed.

Comment?

	Hans
