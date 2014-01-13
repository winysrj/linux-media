Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62808 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaAMTP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 14:15:28 -0500
Received: by mail-oa0-f51.google.com with SMTP id m1so8429247oag.24
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 11:15:28 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 13 Jan 2014 11:15:27 -0800
Message-ID: <CABMudhSNJdxWZpZjmG-GYObUeMyBSOZs3_HSm8Vok9ecXf1Dnw@mail.gmail.com>
Subject: When do I need to call 'v4l2_m2m_get_next_job()' in stop_streaming
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Can you please tell me when do I need to call 'v4l2_m2m_get_next_job()
in stop streaming/job_abort?

I find 2 examples of v4l2 m2m driver, they implement
stop_streaming/job_abort differently.

One call v4l2_m2m_get_next_job() in stop streaming/job_abort?

https://android.googlesource.com/kernel/exynos.git/+/6ced4b8c77c2be4f6e4c9d1216fd8b99f636569f/drivers/media/video/exynos/gsc/gsc-m2m.c

but the one one does not:

http://lxr.free-electrons.com/source/drivers/media/platform/s5p-jpeg/jpeg-core.c

Can you please tell me how can I determine if I need to call
v4l2_m2m_get_next_job() or not?

Thank you.
