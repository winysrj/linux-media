Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56265 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0J2KCj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 06:02:39 -0400
Received: by gwj21 with SMTP id 21so1831818gwj.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 03:02:39 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 29 Oct 2010 18:02:38 +0800
Message-ID: <AANLkTikJNdcnRbNwv4j8zfv4TfSqOgB2K=UD4UFfL=q4@mail.gmail.com>
Subject: V4L2 and framebuffer for the same controller
From: Jun Nie <niej0001@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,
    I find that your idea of "provide a generic framebuffer driver
that could sit on top of a v4l output driver", which may be a good
solution of our LCD controller driver, or maybe much more other SOC
LCD drivers. V4L2 interface support many features than framebuffer for
video playback usage, such as buffer queue/dequeue, quality control,
etc. However, framebuffer is common for UI display. Implement two
drivers for one controller is a challenge for current architecture.
    I am interested in your idea. Could you elaborate it? Or do you
think multifunction driver is the right solution for this the
scenario?

Jun
