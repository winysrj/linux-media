Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:11880 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZA2CYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 21:24:10 -0500
Received: by rv-out-0506.google.com with SMTP id k40so7259134rvb.1
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2009 18:24:09 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 29 Jan 2009 11:24:09 +0900
Message-ID: <5e9665e10901281824ibccbf00lcbecba5b01fdcbea@mail.gmail.com>
Subject: [V4L2] EV control API for digital camera
From: DongSoo Kim <dongsoo.kim@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Cc: =?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>,
	jongse.won@samsung.com, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

When we take pictures, sometimes we don't get satisfied with the
exposure of picture. Too dark or too bright.

For that reason, we need to bias EV which represents Exposure Value.

So..if I want to control digital camera module with V4L2 API, which
API should I take for EV control?

V4L2 document says that V4L2_CID_BRIGHTNESS is for picture brightness,
but it is for "Image properties" and that "image" means the image
frame of TV or PVR things.Am I right?

If I may, can I use V4L2_CID_BRIGHTNESS for EV control of digital cameras?

or..otherwise I should make a new API for that functionality.

I'm little bit confused, because I think the brightness of picture
could differ from exposure value of digital camera..help me ;(


Regards.
Nate




-- 
========================================================
Dong Soo, Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
           dongsoo45.kim@samsung.com
========================================================
