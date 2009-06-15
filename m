Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4949 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZFOLZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 07:25:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: remove video_register_device_index, add video_register_device_range
Date: Mon, 15 Jun 2009 13:25:28 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151325.29079.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

While looking at the video_register_device changes that broke ov511 I realized
that the video_register_device_index function is never called from drivers. It
will always assign a default index number. I also don't see a good use-case
for giving it an explicit index. My proposal is to remove this API. Since it
is never called, nothing will change effectively. I'm never happy with unused
functions.

However, I think we do need a new video_register_device_range function. This
would be identical to video_register_device, but with an additional count
argument: this allows drivers to select a kernel number in the range of
nr to nr + count - 1. If cnt == -1, then the maximum is the compiled-in
maximum.

So video_register_device would call video_register_device_range(...nr, 1),
thus restoring the original behavior, while ivtv and cx18 can call
video_register_device_range(...nr, -1), thus keeping the current behavior.

Comments?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
