Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36247 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbcABVX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jan 2016 16:23:56 -0500
Received: by mail-io0-f178.google.com with SMTP id o67so407445757iof.3
        for <linux-media@vger.kernel.org>; Sat, 02 Jan 2016 13:23:56 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 2 Jan 2016 23:23:55 +0200
Message-ID: <CAJ2oMhK7f4kLYaTw874g4w2vjd5nw_FBET1JsjX9Us30Eve5GQ@mail.gmail.com>
Subject: CMA usage in driver
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I made some reading on CMA usage with device driver, nut not quite sure yet.
Do we need to call dma_declare_contiguous or does it get called from
within videobuf2 ?

Is there any example how to use CMA memory in v4l2 driver ?

Best Regards,
Ran
