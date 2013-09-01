Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48727 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753273Ab3IAOb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Sep 2013 10:31:58 -0400
Message-ID: <5223515F.8030002@iki.fi>
Date: Sun, 01 Sep 2013 17:38:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Su Jiaquan <jiaquan.lnx@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Subject: Re: How to express planar formats with mediabus format code?
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com>	<2205654.JNC8mWJ5su@avalon>	<CALxrGmVHS2BnmyLd4EDEHJ-CB44e-AfdFqj0pVFTa_hbBhgWAA@mail.gmail.com>	<2368703.nsGl321KOP@avalon> <CALxrGmWreOkjKuBrR4Y2i=V2EvwHxeP69vsziAZrYQWQvZWfGw@mail.gmail.com>
In-Reply-To: <CALxrGmWreOkjKuBrR4Y2i=V2EvwHxeP69vsziAZrYQWQvZWfGw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jiaquan and Laurent,

Apologies for my delayed reply.

Su Jiaquan wrote:
> Hi Sakari,
>
> On Thu, Aug 22, 2013 at 7:29 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Jiaquan,
>>
>> On Wednesday 21 August 2013 18:14:50 Su Jiaquan wrote:
>>> On Tue, Aug 20, 2013 at 8:53 PM, Laurent Pinchart wrote:
>>>> Hi Jiaquan,
>>>>
>>>> I'm not sure if that's needed here. Vendor-specific formats still need to
>>>> be documented, so we could just create a custom YUV format for your case.
>>>> Let's start with the beginning, could you describe what gets transmitted
>>>> on the bus when that special format is selected ?
>>>
>>> For YUV420P format, the data format sent from IPC is similar to
>>> V4L2_MBUS_FMT_YUYV8_1_5X8, but the content for each line is different:
>>> For odd line, it's YYU YYU YYU... For even line, it's YYV YYV YYV...
>>> then DMA engine send them to RAM in planar format.
>>>
>>> For YUV420SP format, the data format sent from IPC is YYUV YYUV
>>> YYUV(maybe called V4L2_MBUS_FMT_YYUV8_2X8?), but DMA engine drop UV
>>> every other line, then send them to RAM as semi-planar.
>>
>> V4L2_MBUS_FMT_YYUV8_2X8 looks good to me.
>>
>>> Well, the first data format is too odd, I don't have a clue how to
>>> call it, do you have suggestion?
>>
>> Maybe V4L2_MBUS_FMT_YU8_YV8_1_5X8 ? I've CC'ed Sakari Ailus, he's often pretty
>> creative for these issues.
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
>
> Does the format V4L2_MBUS_FMT_YU8_YV8_1_5X8 sounds good to you? Do you
> have better idea how we should describe this format?

If bus (or DMA) transfers 8 bits at a time, then yes. Otherwise perhaps
...1X12.

The documentation should be extended to cover different components on 
alternating lines; I don't think we've had such cases before. I think 
just a note telling to do exactly as above should suffice.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
