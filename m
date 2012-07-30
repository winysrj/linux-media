Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48331 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2G3TYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 15:24:21 -0400
Received: by bkwj10 with SMTP id j10so2977468bkw.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2012 12:24:20 -0700 (PDT)
Message-ID: <5016DF61.2010002@gmail.com>
Date: Mon, 30 Jul 2012 21:24:17 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	LMML <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v7 1/2] media: add new mediabus format enums for dm365
References: <1343386505-8695-1-git-send-email-prabhakar.lad@ti.com> <20120727220124.GC26642@valkosipuli.retiisi.org.uk> <201207302036.36180.hverkuil@xs4all.nl> <1527741.DUREJZiXMg@avalon>
In-Reply-To: <1527741.DUREJZiXMg@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/30/2012 09:06 PM, Laurent Pinchart wrote:
>>>> -	bus. Possible values are YUYV, UYVY, YVYU and VYUY.</para></listitem>
>>>> +	bus. Possible values are YUYV, UYVY, YVYU and VYUY for formats with
> no
>>>> +	dummy bit, and YDYUYDYV, YDYVYDYU, YUYDYVYD and YVYDYUYD for YDYC
>>>> formats. +	</para></listitem>
>>>>
>>>>   	<listitem><para>The number of bits per pixel component. All
> components
>>>>   	are
>>>>   	transferred on the same number of bits. Common values are 8, 10 and
>>>>   	12.</para>  </listitem>
>>>
>>> I dicussed dummy vs. padding (zeros) with Laurent and we concluded we
>>> should use zero padding instead. The difference is that when processing
>>> the pixels no extra operations are necessary to get rid of the dummy data
>>> when the dummy bits are actually zero --- which in practice always is the
>>> case.
>>>
>>> I'm not aware of hardware that would assign padding bits (in this very
>>> purpose) that are a part of writes the width of bus width something else
>>> than zeros. It wouldn't make much sense either.
>>>
>>> So I suggest that dummy is replaced by padding which is defined to be
>>> zero.
>>>
>>> The letter in the format name could be 'Z', for example.
>>>
>>> Hans: what do you think?
>>
>> Bad idea. First of all, some hardware or FPGA can insert different values
>> there. It's something that Cisco uses in some cases: it makes it easier to
>> identify the dummy values if they have a non-zero fixed value.
>>
>> Another reason for not doing this is when such formats are used to display
>> video: you don't want to force the software to fill in the dummy values
>> with a specific value for no good reason. That would only cost extra CPU
>> cycles.
> 
> On the other hand, when you process data that includes dummy bits stored in
> memory, knowing that the dummy bits are zero can save a mask operation.
> 
> I don't have a strong opinion whether we should use zero or dummy bits for
> media bus formats. For memory formats I'd be inclined to use zero bits (at
> least when capturing).

Perhaps it would make sense to assume those dummy bits have undefined
value and add some other API for retrieving/setting them where possible,
e.g. a v4l2 control ?

It just feels like an unnecessary API limitation to assume those dummy
bits are always zero.

--

Regards,
Sylwester
