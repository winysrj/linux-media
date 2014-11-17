Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44386 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKQQrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 11:47:05 -0500
Received: by mail-pa0-f52.google.com with SMTP id eu11so1719662pac.25
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 08:47:05 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Nov 2014 20:47:05 +0400
Message-ID: <CANZNk82ny0q9M25KPV7WZ3eg=XeTP2WKTP_3OoWLqEZiOGGFeg@mail.gmail.com>
Subject: patchwork on solo6x10: fix a race in IRQ handler
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?ISO-8859-2?Q?Krzysztof_Ha=B3asa?= <khalasa@piap.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear linux-media maintainers, I fail to do `git am` on mbox-formatted
patch downloadable from https://patchwork.linuxtv.org/patch/26970/
so i worry if the Krzyztof's patch i resubmitted is well-formed, and
whether you are fine with integration of this patch to media_tree and
further to upstream. Please let me know if there you experience any
issues with that.

-- 
Andrey Utkin
