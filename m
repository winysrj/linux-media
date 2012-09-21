Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3483 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2IULHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 07:07:49 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id q8LB7koY042849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 21 Sep 2012 13:07:47 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id E68AA35C0026
	for <linux-media@vger.kernel.org>; Fri, 21 Sep 2012 13:07:44 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: RFC: single+multiplanar API in one driver: possible or not?
Date: Fri, 21 Sep 2012 13:07:45 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211307.45495.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've been looking into multiplanar support recently, and I ran into some API
ambiguities.

In the examples below I stick to the capture case, but the same applies to
output and m2m.

There are two capabilities: V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_CAPTURE_MPLANE.
These caps tell the application whether the single and/or multiplanar API is
implemented by the driver.

If the hardware only supports single planar formats, then only V4L2_CAP_VIDEO_CAPTURE
is present. If the hardware only supports multiplanar formats, then only
V4L2_CAP_VIDEO_CAPTURE_MPLANE is present. The problems occurs when the hardware
supports both single and multiplanar formats.

The first question is if we want to allow drivers to implement both. The
advantages of that are:

- easy to implement: if the hardware supports one or more multiplanar formats,
  then the driver must implement only the multiplanar API. Applications will
  only see V4L2_CAP_VIDEO_CAPTURE or V4L2_CAP_VIDEO_CAPTURE_MPLANE and never
  both.
- no confusion: what should be done if a multiplanar format is set up
  and an application asks for the current single planar format? Return a
  fake format? Some error? This is currently undefined.

The disadvantages are:

- it won't work with most/all existing applications since they only understand
  single planar at the moment. However, all multiplanar drivers are for Samsung
  embedded SoCs, so is this a real problem?

If we would want to allow mixing the two, then we need to solve two problems:

- Determine the behavior when calling G_FMT for a single planar buffer type
  when the current format is a multiplanar format.
- We probably want to make a bunch of helper functions that do the job of
  handling the single planar case without requiring the driver to actually
  implement both.

The first is actually a major problem. Returning an error here is completely
unexpected behavior. The only reasonable solution I see is to remember the last
single planar format and return that. But then G_FMT for a single or a multiplanar
format will return different things.

The second problem is also difficult, in particular when dealing with the
streaming I/O ioctls. It's doable, but a fair amount of work.

A conversion from multiplanar to singleplanar might be something that can be
done in libv4l2. But that too is a substantial amount of work.

I am inclined to disallow mixing of single and multiplanar APIs in a driver.
Let's keep things simple.

Comments?

	Hans
