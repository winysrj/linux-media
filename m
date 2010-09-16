Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:53922 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab0IPPli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 11:41:38 -0400
Message-ID: <4C92397D.9040707@maxwell.research.nokia.com>
Date: Thu, 16 Sep 2010 18:36:29 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH v4 07/11] media: Entities, pads and links enumeration
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <201009011605.12172.laurent.pinchart@ideasonboard.com> <201009061851.59844.hverkuil@xs4all.nl> <201009161120.27327.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201009161120.27327.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent and Hans,

Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 06 September 2010 18:51:59 Hans Verkuil wrote:
>> On Wednesday, September 01, 2010 16:05:10 Laurent Pinchart wrote:
>>> On Saturday 28 August 2010 13:02:22 Hans Verkuil wrote:
>>>> On Friday, August 20, 2010 17:29:09 Laurent Pinchart wrote:

...

>>>>> +};
>>>>
>>>> Should this be a packed struct?
>>>
>>> Why ? :-) Packed struct are most useful when they need to match hardware
>>> structures or network protocols. Packing a structure can generate
>>> unaligned fields, which are bad performance-wise.
>>
>> I'm thinking about preventing a compat32 mess as we have for v4l.
>>
>> It is my understanding that the only way to prevent different struct sizes
>> between 32 and 64 bit is to use packed.
> 
> I don't think that's correct. Different struct sizes between 32bit and 64bit 
> are caused by variable-size fields, such as 'long' (32bit on 32bit 
> architectures, 64bit on 64bit architectures). I might be wrong though.

As far as I understand that's another reason for the structures not
being exactly the same. Alignment of different data types in structures
depends on ABI. I don't know the exact rules for all the architectures
Linux supports if there are cases where the alignment would be different
for 32-bit and 64-bit and smaller than the data type. On ARM there have
been different alignments depending on ABI (EABI vs. GNU ABI) which is
now practically history though.

I couldn't find a better reference than this:

<URL:http://developers.sun.com/solaris/articles/about_amd64_abi.html>

64-bit integers are aligned differently on 32-bit and 64-bit x86 but the
alignment is still smaller or equal to the size of the data type.

I'd also pack them to be sure. The structures should be constructed so
that the alignment is sane even if they are packed. In that case there's
no harm done by packing. It just prevents a failure (32-bit vs. 64-bit)
if there's a problem with the definition.

Just my 2 cents worth. :)

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
