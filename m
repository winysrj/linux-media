Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2243 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaAHPQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 10:16:07 -0500
Message-ID: <52CD6BAA.8070103@xs4all.nl>
Date: Wed, 08 Jan 2014 16:15:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH 0/4] add radio-raremono driver
References: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl> <CALW4P+KTJOPk5EVZ9cx7fwj=+k5OR1fACNjFtJ8-1eh7ZxOQjQ@mail.gmail.com>
In-Reply-To: <CALW4P+KTJOPk5EVZ9cx7fwj=+k5OR1fACNjFtJ8-1eh7ZxOQjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

On 01/08/2014 03:51 PM, Alexey Klimov wrote:
> On Fri, Dec 13, 2013 at 4:26 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> This patch series adds the new radio-raremono driver for the USB
>> 'Thanko's Raremono' AM/FM/SW receiver.
>>
>> Since it (ab)uses the same USB IDs as the si470x SiLabs Reference
>> Design I had to add additional checks to si470x to tell the two apart.
>>
>> While editing si470x I noticed that it passes USB buffers from the stack
>> instead of using kmalloc, so I fixed that as well.
>>
>> I have tested the si470x checks, and the FM and AM receiver of the
>> Raremono device have been tested as well. I don't have a SW transmitter,
>> nor are there any SW transmitters here in Norway, so I couldn't test it.
>>
>> All I can say is that it is definitely tuning since the white noise
>> changes when I change frequency. I'll try this nexy week in the Netherlands,
>> as I think there are still a few SW transmissions there I might receive.
>>
>> The initial reverse engineering for this driver was done by Dinesh Ram
>> as part of his Cisco internship, so many thanks to Dinesh for doing that
>> work.
> 
> Hi Hans,
> 
> this is very nice radio and driver. But where did you buy/get this device?
> Could you please share a link?
> 
> Year ago i tried to find place on internet to buy this device but failed.
> 

I ordered it here in mid-2012, and it seems they still sell it:

http://www.audiocubes.com/product_info.php?products_id=2778

Regards,

	Hans
