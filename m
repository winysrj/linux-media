Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:32851 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbbJZLqf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 07:46:35 -0400
Received: by qgeo38 with SMTP id o38so117072117qge.0
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2015 04:46:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <562D5DE2.5020406@xs4all.nl>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
	<5625DDCA.2040203@xs4all.nl>
	<CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
	<562B5178.5040303@xs4all.nl>
	<CAJ2oMhJ1FhMqm_P0h+dzmTUJuvfK=DawPAO-R3duS6-XncsrMQ@mail.gmail.com>
	<562D5DE2.5020406@xs4all.nl>
Date: Mon, 26 Oct 2015 07:46:34 -0400
Message-ID: <CALzAhNUwq3p8OSG32VfffMbwSnpF_tGyUMmLgk+L-0XOTHZJjQ@mail.gmail.com>
Subject: Re: PCIe capture driver
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> No, use V4L2. What you do with the frame after it has been captured
> into memory has no relevance to the API you use to capture into memory.

Ran, I've built many open and closed source Linux drivers over the
last 10 years - so I can speak with authority on this.

Hans is absolutely correct, don't make the mistake of going
proprietary with your API. Take advantage of the massive amount of
video related frameworks the kernel has to offer. It will get you to
market faster, assuming your goal is to build a driver that is open
source. If your licensing prohibits an open source driver solution,
you'll have no choice but to build your own proprietary API.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
