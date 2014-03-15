Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2498 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaCOK01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 06:26:27 -0400
Message-ID: <53242AC7.9080301@xs4all.nl>
Date: Sat, 15 Mar 2014 11:26:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-sparse@vger.kernel.org
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: sparse and anonymous unions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I'm trying to cut down the list of sparse warnings and errors I get when
compiling drivers/media. Most of them are obviously our problem, but there
is one that seems to be a sparse bug:

drivers/media/v4l2-core/v4l2-dv-timings.c:30:9: error: unknown field name in initializer

This uses the v4l2_dv_timings type which is defined here:

include/uapi/linux/videodev2.h

and which has an anonymous union:

struct v4l2_dv_timings {
        __u32 type;
        union {
                struct v4l2_bt_timings  bt;
                __u32   reserved[32];
        };
} __attribute__ ((packed));

The macro used in the source above comes from this header:

include/uapi/linux/v4l2-dv-timings.h

and is defined as follows:

#if __GNUC__ < 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ < 6))
/* Sadly gcc versions older than 4.6 have a bug in how they initialize
   anonymous unions where they require additional curly brackets.
   This violates the C1x standard. This workaround adds the curly brackets
   if needed. */
#define V4L2_INIT_BT_TIMINGS(_width, args...) \
        { .bt = { _width , ## args } }
#else
#define V4L2_INIT_BT_TIMINGS(_width, args...) \
        .bt = { _width , ## args }
#endif

/* CEA-861-E timings (i.e. standard HDTV timings) */
        
#define V4L2_DV_BT_CEA_640X480P59_94 { \
        .type = V4L2_DV_BT_656_1120, \
        V4L2_INIT_BT_TIMINGS(640, 480, 0, 0, \
                25175000, 16, 96, 48, 10, 2, 33, 0, 0, 0, \
                V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, 0) \
}

The problem is that it seems that sparse follows the old pre-4.6 rules for
initializing anonymous unions instead of what is actually in the C standard.

If I add ' || defined(__CHECKER__)' to the #if above it will pass without
generating sparse errors.

Is this something that can be fixed in sparse, or am I forced to add the
'defined(__CHECKER__)' to the #if condition?

Regards,

	Hans
