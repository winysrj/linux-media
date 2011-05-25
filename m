Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55542 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1EYJ4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 05:56:24 -0400
Received: by pvg12 with SMTP id 12so3330011pvg.19
        for <linux-media@vger.kernel.org>; Wed, 25 May 2011 02:56:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 May 2011 17:56:23 +0800
Message-ID: <BANLkTikPGEgWH-ExjnSuH8-n0f2q54EJGQ@mail.gmail.com>
Subject: v4l2_mbus_framefmt and v4l2_pix_format
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans and Laurent,

I got fmt info from a video data source subdev, I thought there should
be a helper function to convert these two format enums.
However, v4l2_fill_pix_format didn't do this, why? Should I do this in
bridge driver one by one?
I think these codes are common use, I prefer adding them in
v4l2_fill_pix_format.

Thanks,
Scott
