Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:41791 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2D3Lcd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 07:32:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Ambiguous specification regarding valid audmode value for radio tuners
Date: Mon, 30 Apr 2012 13:32:19 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301332.19937.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

While working on the v4l2-compliance tool I came across an ambiguous 
specification.

The question is whether VIDIOC_S_TUNER should accept audmode values other
then MONO and STEREO for FM radio devices.

On the one hand the description of VIDIOC_S_TUNER says:

"Drivers may choose a different audio mode if the requested mode is invalid or 
unsupported."

On the other hand the clearly mention that the non-MONO and -STEREO modes are 
for analog TV only.

The return code description says that -EINVAL is only returned in case of an 
invalid index value.

I'm inclined to say that for radio devices any audmodes other than MONO and 
STEREO should cause a -EINVAL error.

Alternatively we could define that any other audmodes are accepted but map to 
STEREO instead.

Comments?

	Hans
