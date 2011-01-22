Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44129 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AVMOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 07:14:31 -0500
Received: by fxm20 with SMTP id 20so2639619fxm.19
        for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 04:14:30 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 22 Jan 2011 21:14:30 +0900
Message-ID: <AANLkTindGkZ1NJhaOW35J8PGM1x9GAve8htoj29QwiJN@mail.gmail.com>
Subject: How to re-start m2m device after suspend ?
From: Jonghun Han <jonghun79.han@gmail.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	s.nawrocki@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I don't know whether the way to restart m2m device after suspend is
right or not.
To go to suspend state, I think m2m device should stop the job even if
there are remained jobs in ready queue.
After suspend, driver should restart remained jobs in resume function
without ioctl command like: VIDIOC_QBUF.

According the m2m framework, device_run should be called to restart.
And the device_run is called by v4l2_m2m_try_run called by
v4l2_m2m_try_schedule and v4l2_m2m_job_finish.
And v4l2_m2m_try_schedule is only for m2m framework.

So in my opinion, if driver didn't call the v4l2_m2m_job_finish in
suspend function,
the resume function can start from v4l2_m2m_job_finish to restart the
remained jobs.
Is it right the way or is there anything recommended way ?

Best regards,
