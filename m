Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41718 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728920AbeI1T7E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 15:59:04 -0400
Subject: Re: [RFC,1/3] cpia2: move to staging in preparation for removal
To: Andrea Merello <andrea.merello@gmail.com>,
        linux-media@vger.kernel.org
References: <20180513110525.20062-2-hverkuil@xs4all.nl>
 <20180928130358.15470-1-andrea.merello@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0fc07f4a-ba06-28fa-962a-947f630c55dc@xs4all.nl>
Date: Fri, 28 Sep 2018 15:35:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180928130358.15470-1-andrea.merello@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrea,

On 09/28/2018 03:03 PM, Andrea Merello wrote:
> I do often use this driver, and I'm interested in working on it for preventing it from being removed.
> 
> I can perform functional test with my HW (usb microscope) on a kernel from current media tree (anyway currently it works on my box with a pretty recent kernel).
> 
> How much effort is expected to be required to port it to vb2? I'm currently hacking on another (recent) v4l2 subdev driver, but my wknowledge of the v4l2/media framework is far from good.. If someone give me some directions then I can try to do that..
> 

cpia2 has its own streaming I/O implementation. This should be completely replaced
by vb2. Easiest is to look at a fairly recent usb driver like usbtv to see how
it is done there.

The vb2 API is fairly clean (see include/media/videobuf2-core.h), but switching to
vb2 is a big-bang action, you can't switch a little bit, it is all or nothing.
So that makes this a big unreadable patch in the end. The v4l2-compliance utility
is your friend when testing this.

If you would be willing to work on this, then it's easiest if you use the #v4l channel
on freenode irc to ask questions (which I am sure you'll have).

It's a fair amount of work, I'm afraid. It would probably take me 1-2 days to convert
depending on how nice the rest of the cpia2 driver is.

Regards,

	Hans
