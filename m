Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1577 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBI21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 04:28:27 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s528SNPH054158
	for <linux-media@vger.kernel.org>; Mon, 2 Jun 2014 10:28:25 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0FD902A1B59
	for <linux-media@vger.kernel.org>; Mon,  2 Jun 2014 10:28:18 +0200 (CEST)
Message-ID: <538C35A2.8030307@xs4all.nl>
Date: Mon, 02 Jun 2014 10:28:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC ATTN] Cropping, composing, scaling and S_FMT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the media mini-summit I went through all 8 combinations of cropping,
composing and scaling (i.e. none of these features is present, or only cropping,
only composing, etc.).

In particular I showed what I thought should happen if you change a crop rectangle,
compose rectangle or the format rectangle (VIDIOC_S_FMT).

In my proposal the format rectangle would increase in size if you attempt to set
the compose rectangle wholly or partially outside the current format rectangle.
Most (all?) of the developers present didn't like that and I was asked to take
another look at that.

After looking at this some more I realized that there was no need for this and
it is OK to constrain a compose rectangle to the current format rectangle. All
you need to do if you want to place the compose rectangle outside of the format
rectangle is to just change the format rectangle first. If the driver supports
composition then increasing the format rectangle will not change anything else,
so that is a safe operation without side-effects.

However, changing the crop rectangle *can* change the format rectangle. In the
simple case of hardware that just supports cropping this is obvious, since
the crop and format rectangles must always be of the same size, so changing
one will change the other. But if you throw in a scaler as well, you usually
still have such constraints based on the scaler capabilities.

So assuming a scaler that can only scale 4 times (or less) up or down in each
direction, then setting a crop rectangle of 240x160 will require that the
format rectangle has a width in the range of 240/4 - 240*4 (60-960) and a
height in the range of 160/4 - 160*4 (40-640). Anything outside of that will
have to be corrected.

In my opinion this is valid behavior, and the specification also clearly
specifies in the VIDIOC_S_CROP and VIDIOC_S_SELECTION documentation that the
format may change after changing the crop rectangle.

Note that for output streams the role of crop and compose is swapped. So for
output streams it is the crop rectangle that will always be constrained by
the format rectangle, and it is the compose rectangle that might change the
format rectangle based on scaler constraints.

I think this makes sense and unless there are comments this is what I plan
to implement in my vivi rewrite which supports all these crop/compose/scale
combinations.

Regards,

	Hans
