Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:64012 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3H3H5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 03:57:07 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so565827bkb.31
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 00:57:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2368703.nsGl321KOP@avalon>
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com>
	<2205654.JNC8mWJ5su@avalon>
	<CALxrGmVHS2BnmyLd4EDEHJ-CB44e-AfdFqj0pVFTa_hbBhgWAA@mail.gmail.com>
	<2368703.nsGl321KOP@avalon>
Date: Fri, 30 Aug 2013 15:57:04 +0800
Message-ID: <CALxrGmWreOkjKuBrR4Y2i=V2EvwHxeP69vsziAZrYQWQvZWfGw@mail.gmail.com>
Subject: Re: How to express planar formats with mediabus format code?
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: sakari.ailus@iki.fi,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, Aug 22, 2013 at 7:29 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Jiaquan,
>
> On Wednesday 21 August 2013 18:14:50 Su Jiaquan wrote:
>> On Tue, Aug 20, 2013 at 8:53 PM, Laurent Pinchart wrote:
>> > Hi Jiaquan,
>> >
>> > I'm not sure if that's needed here. Vendor-specific formats still need to
>> > be documented, so we could just create a custom YUV format for your case.
>> > Let's start with the beginning, could you describe what gets transmitted
>> > on the bus when that special format is selected ?
>>
>> For YUV420P format, the data format sent from IPC is similar to
>> V4L2_MBUS_FMT_YUYV8_1_5X8, but the content for each line is different:
>> For odd line, it's YYU YYU YYU... For even line, it's YYV YYV YYV...
>> then DMA engine send them to RAM in planar format.
>>
>> For YUV420SP format, the data format sent from IPC is YYUV YYUV
>> YYUV(maybe called V4L2_MBUS_FMT_YYUV8_2X8?), but DMA engine drop UV
>> every other line, then send them to RAM as semi-planar.
>
> V4L2_MBUS_FMT_YYUV8_2X8 looks good to me.
>
>> Well, the first data format is too odd, I don't have a clue how to
>> call it, do you have suggestion?
>
> Maybe V4L2_MBUS_FMT_YU8_YV8_1_5X8 ? I've CC'ed Sakari Ailus, he's often pretty
> creative for these issues.
>
> --
> Regards,
>
> Laurent Pinchart
>

Does the format V4L2_MBUS_FMT_YU8_YV8_1_5X8 sounds good to you? Do you
have better idea how we should describe this format?

If there is no further concern, I'll prepare a patch

Thanks
