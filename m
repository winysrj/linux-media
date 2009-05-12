Return-path: <linux-media-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:3141 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbZELGMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 02:12:35 -0400
Received: by wa-out-1112.google.com with SMTP id j5so1827961wah.21
        for <linux-media@vger.kernel.org>; Mon, 11 May 2009 23:12:35 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 12 May 2009 15:12:35 +0900
Message-ID: <b64afca20905112312x217e4349pf90d6c0c89f58a42@mail.gmail.com>
Subject: about exact usage of definition - Control Flags in videodev.h
From: "Kim, Heung Jun" <riverful@gmail.com>
To: hverkuil@xs4all.nl
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, jongse.won@samsung.com,
	dongsoo45.kim@samsung.com, "Kim, Heung Jun" <riverful@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Nice to meet u on the mailing-list.
I'm an engineer of camera device driver, and work with Nathaniel(Dongsoo, Kim).
I'm wondering about how to use the Control Flags defined in the videodev2.h.
The Control Flags defined in the videodev2.h is the following as you know,

/*  Control flags  */
#define V4L2_CTRL_FLAG_DISABLED		0x0001
#define V4L2_CTRL_FLAG_GRABBED		0x0002
#define V4L2_CTRL_FLAG_READ_ONLY 	0x0004
#define V4L2_CTRL_FLAG_UPDATE 		0x0008
#define V4L2_CTRL_FLAG_INACTIVE 	0x0010
#define V4L2_CTRL_FLAG_SLIDER 		0x0020

I tryed to find the usage of this definitions in the directories of
drivers/media/video
& include/, but I didn't. Actually, I need to use this definitions for
checking of ISP status.
So, I wanna know exact usage of this definitions to make the generic
driver code.

i'll appreciate your answer beforehand.
Thanks to read.

Regard,
riverful (HeungJun, Kim)
