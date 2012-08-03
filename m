Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46211 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2HCLVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 07:21:04 -0400
Received: by wibhr14 with SMTP id hr14so545551wib.1
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 04:21:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120803090329.GA15809@b20223-02.ap.freescale.net>
References: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com>
	<20120803082442.GE29944@b20223-02.ap.freescale.net>
	<201208031047.01174.hverkuil@xs4all.nl>
	<20120803090329.GA15809@b20223-02.ap.freescale.net>
Date: Fri, 3 Aug 2012 13:21:02 +0200
Message-ID: <CACKLOr2XRz5edR0ZEE3UFD5enbUEMi+OkfRsn1JvOmh=NBqt8A@mail.gmail.com>
Subject: Re: [v7] media: coda: Add driver for Coda video codec.
From: javier Martin <javier.martin@vista-silicon.com>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de,
	p.zabel@pengutronix.de, linuxzsc@gmail.com, shawn.guo@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,
thank you for your review.

This patch has been reviewed and acked by several people:

    Reviewed-by: Philipp Zabel<p.zabel@pengutronix.de>
    Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

For this reason a pull request has already been sent to Mauro recently:

http://patchwork.linuxtv.org/patch/13483/


>> In this case I personally don't think it will be easier to read if this line is split up.
> My point here is checkpatch.
> total: 2 errors, 30 warnings, 2086 lines checked

Thank you for noticing this. I have solved it in my tree so that Mauro
can pull for 3.7.

You can find it here:

https://github.com/jmartinc/video_visstrim.git  for_3.6

Regarding your i.MX6 question, maybe Philippe will be able to help you
since I am only interested on i.MX27. However, the driver was
developed considering much of his suggestions so that adding support
for different chips later is as straightforward as possible.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
