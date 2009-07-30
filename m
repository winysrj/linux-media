Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:53331 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZG3NZw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 09:25:52 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KNL001ZCJZ4DY20@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 30 Jul 2009 09:25:53 -0400 (EDT)
Date: Thu, 30 Jul 2009 09:25:52 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx23885-417: fix setting tvnorms
In-reply-to: <e3538fbd0907292246k2c75a950u38c2c91d5190f4f7@mail.gmail.com>
To: Joseph Yasi <joe.yasi@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4A719F60.7020205@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <e3538fbd0907292246k2c75a950u38c2c91d5190f4f7@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7/30/09 1:46 AM, Joseph Yasi wrote:
> Currently, the VIDIOC_S_STD ioctl just returns -EINVAL regardless of
> the norm passed.  This patch sets cx23885_mpeg_template.tvnorms and
> cx23885_mpeg_template.current_norm so that the VIDIOC_S_STD will work.
>
> Signed-off-by: Joseph A. Yasi<joe.yasi@gmail.com>

Joseph, thank you for raising this.

We have this change and a few others already stacked up in this tree:

http://www.kernellabs.com/hg/~mkrufky/cx23885-api/rev/0391fb200be2

The end result is to get MythTV using the HVR1800 analog encoder correctly.

The tree itself is considered experimental but during testing we had noticed the 
same issue, so, again, thank you for raising the same issue. Two people 
reporting the same issue is always better than none.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
