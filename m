Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1548 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1FLTlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 15:41:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv4 PATCH 6/8] v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner.
Date: Sun, 12 Jun 2011 21:41:12 +0200
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <201106121746.58795.hverkuil@xs4all.nl> <4DF4F273.7000608@redhat.com>
In-Reply-To: <4DF4F273.7000608@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106122141.12435.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, June 12, 2011 19:08:03 Mauro Carvalho Chehab wrote:
> > I think in the longer term we need to change the spec so that:
> > 
> > 1) Opening a radio node no longer switches to radio mode. Instead, you need to
> >    call VIDIOC_S_FREQUENCY for that.
> > 2) When VIDIOC_S_FREQUENCY the type field should match the video/radio node it
> >    is called on. So for /dev/radio type should be RADIO, for others it should be
> >    ANALOG_TV. Otherwise -EINVAL is called.
> > 
> > So this might be a good feature removal for 3.2 or 3.3.
> 
> I'm OK with that.

How about this:

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1a9446b..9df0e09 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -600,3 +600,25 @@ Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
 ----------------------------
+
+What:	For VIDIOC_S_FREQUENCY the type field must match the device node's type.
+	If not, return -EINVAL.
+When:	3.2
+Why:	It makes no sense to switch the tuner to radio mode by calling
+	VIDIOC_S_FREQUENCY on a video node, or to switch the tuner to tv mode by
+	calling VIDIOC_S_FREQUENCY on a radio node. This is the first step of a
+	move to more consistent handling of tv and radio tuners.
+Who:	Hans Verkuil <hans.verkuil@cisco.com>
+
+----------------------------
+
+What:	Opening a radio device node will no longer automatically switch the
+	tuner mode from tv to radio.
+When:	3.3
+Why:	Just opening a V4L device should not change the state of the hardware
+	like that. It's very unexpected and against the V4L spec. Instead, you
+	switch to radio mode by calling VIDIOC_S_FREQUENCY. This is the second
+	and last step of the move to consistent handling of tv and radio tuners.
+Who:	Hans Verkuil <hans.verkuil@cisco.com>
+
+----------------------------

Regards,

	Hans
