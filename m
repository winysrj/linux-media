Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37205 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2BOWaQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 17:30:16 -0500
Received: by bkcjm19 with SMTP id jm19so1425654bkc.19
        for <linux-media@vger.kernel.org>; Wed, 15 Feb 2012 14:30:15 -0800 (PST)
Message-ID: <4F3C31F9.8070000@googlemail.com>
Date: Wed, 15 Feb 2012 23:30:17 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: abel@uni-bielefeld.de
CC: linux-media@vger.kernel.org
Subject: Re: [libv4l] Bytes per Line
References: <4F3BD50A.3010608@uni-bielefeld.de>
In-Reply-To: <4F3BD50A.3010608@uni-bielefeld.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2/15/12 4:53 PM, Robert Abel wrote:
> Basically, I found that libv4l and its conversion functions usually
> choose to ignore v4l2_pix_format.bytesperline, which seems to work out
> most of the time.

> I patched the issue for bayer => rgbbgr24 and will possibly fix it for
> bayer => yuv as well.
> 
> Is there a general understanding that v4l media drivers must not pad
> their data, or that libv4l is ignoring padding?
> I've worked with some webcams in the past and they all padded their
> data, so I'm wondering if assuming bytesperline = width was done on
> purpose and by design of out of necessity (speed..?) or if it just
> happened to work for most people?

As far as I understand the V4L2 spec the bytesperline != width is no
optional feature. If post your patches here I'll review them and add
them to the development tree.

Thanks,
Gregor
