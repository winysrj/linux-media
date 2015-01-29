Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53460 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbbA2W3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 17:29:13 -0500
Received: by mail-pa0-f47.google.com with SMTP id lj1so43911040pab.6
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 14:29:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANZNk81X8egiGgnupeRVo9HPStH3rRcPdLYWQifcHKnOLUMivg@mail.gmail.com>
References: <CANZNk81X8egiGgnupeRVo9HPStH3rRcPdLYWQifcHKnOLUMivg@mail.gmail.com>
Date: Fri, 30 Jan 2015 00:29:13 +0200
Message-ID: <CANZNk81pQojKfaydmfwp7EDKyd5p3eE9DhHHJZ_UHmwxeb29qQ@mail.gmail.com>
Subject: Re: solo6x10: all interrupts for all cards handled by CPU0, no
 balancing - why?
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-mentors@selenic.com,
	Linux Media <linux-media@vger.kernel.org>,
	OSUOSL Drivers <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The host was rebooted and got back online.
Without irqbalance daemon, all solo6x10 interrupts are still on CPU0.
See https://gist.github.com/krieger-od/d1686243c67fbe3e14a5
Any ideas are strongly appreciated.


-- 
Andrey Utkin
