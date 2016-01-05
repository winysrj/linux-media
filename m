Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35409 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbcAEVSY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 16:18:24 -0500
Received: by mail-io0-f174.google.com with SMTP id 77so168848067ioc.2
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2016 13:18:24 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 5 Jan 2016 23:18:23 +0200
Message-ID: <CAJ2oMhJGt8gL9MBWoHq9X9LcrR0bwPVk20jvqnWRWrAuSa2T-Q@mail.gmail.com>
Subject: Multiple open and read of vivi device
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Does anyone knows why vivi is limited to one open ?
Is there some way to patch it for multiple opens and reading ?

Regards,
Ran
