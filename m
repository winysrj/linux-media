Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36059 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbcAIJ6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2016 04:58:04 -0500
Received: by mail-ig0-f173.google.com with SMTP id z14so72964575igp.1
        for <linux-media@vger.kernel.org>; Sat, 09 Jan 2016 01:58:03 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 9 Jan 2016 11:58:03 +0200
Message-ID: <CAJ2oMhJVjKrfXEKx6xnGQkEpcSWBywabrDwy9biJkhjmnZ7Kbg@mail.gmail.com>
Subject: vivid - add support for YUV420
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've been doing some tests with capturing video from virtual driver (vivid).
I've tried to force it to YUV420, but it ignores that, becuase it does
not support this format.
I would please like to ask if there is some way I can output YUV420
format with vivi.

Best Regards,
Ran
