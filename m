Return-path: <mchehab@pedra>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:41324 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1DDLww (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:52 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p34BqDrV001853
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 11:52:16 GMT
Received: from cobaltpc1.rd.tandberg.com (cobaltpc1.rd.tandberg.com [10.47.3.155])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p34BqDdG009325
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 13:52:14 +0200
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 0/9] Control Events
Date: Mon,  4 Apr 2011 13:51:45 +0200
Message-Id: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Before and during the Warsaw brainstorm meeting we discussed control events
and how those could be used for HDMI controls in addition to automatically
updating control panels.

This patch series implements this functionality.

Note that there are no official DocBook patches yet. I'd like to get some
feedback first.

But here is the informal documentation:

1) A new control type was added to represent bitmasks. This is needed by both
   HDMI controls and Flash controls. When defining a bitmask control the minimum
   and step fields are 0 and the maximum field is the bitmask value with all
   valid bits set to 1.

2) struct v4l2_fh now has a pointer to v4l2_ctrl_handler. This is needed for
   control events, but also for per-filehandle controls. If this pointer is NULL,
   then v4l2_fh will inherit the ctrl_handler of video_device.

3) Add a new 'id' field when (un)subscribing an event: this will identify a
   particular object from which you want to get an event. In the case of control
   events this is of course the control ID.

4) Add two new events:

#define V4L2_EVENT_CTRL_CH_VALUE                3
#define V4L2_EVENT_CTRL_CH_STATE                4

/* Payload for V4L2_EVENT_CTRL_CH_VALUE */
struct v4l2_event_ctrl_ch_value {
        __u32 type;
        union {
                __s32 value;
                __s64 value64;
        };
} __attribute__ ((packed));

/* Payload for V4L2_EVENT_CTRL_CH_STATE */
struct v4l2_event_ctrl_ch_state {
        __u32 type;
        __u32 flags;
} __attribute__ ((packed));

The first is sent when the value of a control changes (or when a button control
is activated), the second is sent when the flags field describing the state of a
control (active/grabbed/disabled) changes. The control type is also sent to make
it easier to interpret the value union and flags.

5) Added a new subscription flag field with currently one flag:

#define V4L2_EVENT_SUB_FL_SEND_INITIAL (1 << 0)

If set, then an initial event with the state at the time of subscription will
be sent. This avoids race conditions where an application has to get the current
state of a control, then subscribe an event. The application may have missed
state changes between the two.

This flag has no effect for events that are triggered by real events like
a Vsync.

I have thought about a 'FL_SKIP_SELF' event where the file handle that changes
the control value does not get an event in response. However, that is a bit
tricky and also does not seem to be necessary based on some tests with qv4l2.

So I won't implement that for now.

An updated qv4l2 can be found here:

http://git.linuxtv.org/hverkuil/v4l-utils.git?a=shortlog;h=refs/heads/core

It's based on a slightly older patch series, though.

6) Modified vb2_poll. See the commit log in that patch for the details.

Comments are welcome!

Regards,

	Hans


