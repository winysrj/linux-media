Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41867 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2HRPPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 11:15:03 -0400
Received: by ialo24 with SMTP id o24so1286077ial.19
        for <linux-media@vger.kernel.org>; Sat, 18 Aug 2012 08:15:02 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 18 Aug 2012 12:15:02 -0300
Message-ID: <CALF0-+WBKGNqamC2__ohKMDqs9bFvBQ9BY0VqrUrHu8rwBgR9w@mail.gmail.com>
Subject: [Q] videbuf2 behavior when start_streaming fails
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I was trying to debug a bug in stk1160, triggered by a low memory situation.
After some struggling I found out that I'm suppose to clear the queued buffers
if start_streaming() fails (which I wasn't doing).

This seems most awkward since I didn't queue the buffers in start_streaming,
but of course in buf_queue. So, it looks like a mixup to me.

Am I missing something? Was this documented anywhere?
Does this look odd to anyone, or is it just me being awfully newbie?

Thanks!
Ezequiel.
