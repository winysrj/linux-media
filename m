Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55274 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0EVOGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 10:06:20 -0400
Received: by wyb29 with SMTP id 29so529049wyb.19
        for <linux-media@vger.kernel.org>; Sat, 22 May 2010 07:06:18 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 22 May 2010 15:06:18 +0100
Message-ID: <AANLkTineD8GCtG1OD4WQahW7zS23IxQDx7XmnAsrVSqs@mail.gmail.com>
Subject: VIDIOC_G_STD, VIDIOC_S_STD, VIDIO_C_ENUMSTD for outputs
From: Andre Draszik <v4l2@andred.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As per the spec, the above ioctl codes are defined for inputs only -
it would be useful if there were similar codes for outputs.

I therefore propose to add the following:

VIDIOC_G_OUTPUT_STD
VIDIOC_S_OUTPUT_STD
VIDIOC_ENUM_OUTPUT_STD

which would behave similar to the above, but for output devices.

Thoughts?


Cheers,
Andre'
