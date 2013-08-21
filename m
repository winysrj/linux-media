Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57752 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3HUKOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 06:14:51 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so87914bkh.11
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 03:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2205654.JNC8mWJ5su@avalon>
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com>
	<CALxrGmWgpHtmBTSwz0+P18VtZOcYO=3E0m6npa_1mR8ownNtcQ@mail.gmail.com>
	<CALxrGmUW3AQts3kDHJ79K82qL4huGp0QceTL3ZtnUPW2VzNfeA@mail.gmail.com>
	<2205654.JNC8mWJ5su@avalon>
Date: Wed, 21 Aug 2013 18:14:50 +0800
Message-ID: <CALxrGmVHS2BnmyLd4EDEHJ-CB44e-AfdFqj0pVFTa_hbBhgWAA@mail.gmail.com>
Subject: Re: How to express planar formats with mediabus format code?
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the replay, I've removed earlier mail content and only keep
you question:

On Tue, Aug 20, 2013 at 8:53 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Jiaquan,
>
> I'm not sure if that's needed here. Vendor-specific formats still need to be
> documented, so we could just create a custom YUV format for your case. Let's
> start with the beginning, could you describe what gets transmitted on the bus
> when that special format is selected ?
>
> --
> Regards,
>
> Laurent Pinchart
>

For YUV420P format, the data format sent from IPC is similar to
V4L2_MBUS_FMT_YUYV8_1_5X8, but the content for each line is different:
For odd line, it's YYU YYU YYU... For even line, it's YYV YYV YYV...
then DMA engine send them to RAM in planar format.

For YUV420SP format, the data format sent from IPC is YYUV YYUV
YYUV(maybe called V4L2_MBUS_FMT_YYUV8_2X8?), but DMA engine drop UV
every other line, then send them to RAM as semi-planar.

Well, the first data format is too odd, I don't have a clue how to
call it, do you have suggestion?

Thanks a lot!

Jiaquan
