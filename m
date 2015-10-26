Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34984 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbbJZRW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 13:22:26 -0400
Received: by qgbb65 with SMTP id b65so125030687qgb.2
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2015 10:22:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ2oMh++Ed43esZi3jnO7SZtc6ySmkmxaydEGPU=PY=UCxhGig@mail.gmail.com>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
	<5625DDCA.2040203@xs4all.nl>
	<CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
	<562B5178.5040303@xs4all.nl>
	<CAJ2oMhJ1FhMqm_P0h+dzmTUJuvfK=DawPAO-R3duS6-XncsrMQ@mail.gmail.com>
	<562D5DE2.5020406@xs4all.nl>
	<CALzAhNUwq3p8OSG32VfffMbwSnpF_tGyUMmLgk+L-0XOTHZJjQ@mail.gmail.com>
	<CAJ2oMh++Ed43esZi3jnO7SZtc6ySmkmxaydEGPU=PY=UCxhGig@mail.gmail.com>
Date: Mon, 26 Oct 2015 13:22:25 -0400
Message-ID: <CALzAhNWy+w8Y5X45nXdnOXewg8qpHgqyWE7zP6inzcGejKd=Bw@mail.gmail.com>
Subject: Re: PCIe capture driver
From: Steven Toth <stoth@kernellabs.com>
To: Ran Shalit <ranshalit@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Hans is absolutely correct, don't make the mistake of going
>> proprietary with your API. Take advantage of the massive amount of

> Thank you very much for these valuable comments.
> If I may ask one more on this issue:
> Is there an example in linux tree, for a pci device which is used both
> as a capture and a display device ? (I've made a search but did not
> find any)
> The PCIe device we are using will be both a capture device and output
> video device (for display).

An in-kernel open source PCIe device that you can feed frames (and
presumably audio), have the device render and capture? Not that I'm
aware of.

I've done these kinds of driver projects in the past, on a commercial
basis, for our clients. Contact me off list if you're looking for
help.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
