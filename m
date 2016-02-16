Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34315 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcBPA54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 19:57:56 -0500
Received: by mail-wm0-f52.google.com with SMTP id b205so88485007wmb.1
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2016 16:57:55 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 16 Feb 2016 02:57:55 +0200
Message-ID: <CA+S3egC3v7GeOtaKt6iNa=TvnLnL=iC472xYFFX-Lm6WYccHrg@mail.gmail.com>
Subject: SAA7134 card stop working
From: grigore calugar <zradu1100@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After this series of patches
http://www.spinics.net/lists/linux-media/msg97115.html
my tv card V-Stream Studio TV Terminator has no signal in tvtime until
exchange audio standard from tvtime menu.

tvtime start with blue screen "no signal"
When exchange audio standard from PAL-BG to PAL-DK , PAL-I and back to
PAL-BG, the image appears on screen.
It seems that the tuner is uninitialized until I change audio norm.
