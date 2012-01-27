Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3880 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2A0HWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 02:22:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: RFC: removal of video/radio/vbi_nr module options?
Date: Fri, 27 Jan 2012 08:21:49 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201270821.49381.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm working on cleaning up some old radio drivers and while doing that I
started wondering about the usefulness of the radio_nr module option (and
the corresponding video_nr/vbi_nr module options for video devices).

Is that really still needed? It originates from pre-udev times, but it seems
fairly useless to me these days.

It is also hit-and-miss whether a driver supports it (e.g. uvc doesn't and
nobody seems to miss it) and if it does, whether it is an array (and how
long that array is) or a single integer.

So my question is: when I'm cleaning up drivers like the old radio drivers,
should I keep support for those module options or should I just drop it?

I'm curious what people think.

Regards,

	Hans
