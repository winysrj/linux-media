Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40291 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1CCPBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 10:01:32 -0500
Received: by qyg14 with SMTP id 14so1068355qyg.19
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2011 07:01:32 -0800 (PST)
From: Kim HeungJun <riverful@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: using V4L2_CID_BRIGHTNESS or V4L2_CID_EXPOSURE in the camera
Date: Fri, 4 Mar 2011 00:01:24 +0900
Message-Id: <52566539-3662-4153-B111-EC82389102BE@gmail.com>
Cc: VerkuilHans VerkuilHans <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?euc-kr?B?udqw5rnO?= <kyungmin.park@samsung.com>
To: "linux-media@vger.kernel.org Mailing List Media"
	<linux-media@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello everyone,

I have a question about realization the camera brightness control (or exposure, because it's similar effect).
I'm confused this similar two control - V4L2_CID_BRIGHTNESS and V4L2_CID_EXPOSURE.

These control both express the brightness consequently.

The CID can express the brightness - V4L2_CID_EXPOSURE, is prepared in the camera class.
And V4L2_CID_BRIGHTNESS seems be possible to use in the camera driver, although it is defined
in the global(?) class.

So, which CID I can use to express the image's brightness??