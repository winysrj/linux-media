Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:63790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab1ACQOD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 11:14:03 -0500
Message-ID: <4D21F76B.9000604@redhat.com>
Date: Mon, 03 Jan 2011 17:20:59 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: RFC: Move the deprecated et61x251 and sn9c102 to staging
References: <201101012053.00372.hverkuil@xs4all.nl> <4D20A908.9020705@redhat.com> <4D20C4FB.9060906@redhat.com> <201101022113.01133.hverkuil@xs4all.nl>
In-Reply-To: <201101022113.01133.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 01/02/2011 09:13 PM, Hans Verkuil wrote:
> Hi Hans,
>
> On Sunday, January 02, 2011 19:33:31 Hans de Goede wrote:
>> Hi,
>>
>> One small correction to the sn9c102 sensor table, the
>> mt9v111 sensor is handled by sonixj, so the table of
>> bridge/sensor combi's supported by sn9c102, looks like this:
>>
>> sn9c101/102:
>> hv7131d
>> mi0343 *
>> ov7630
>> pas106b
>> pas202bcb
>> tas5110c1b
>> tas5110d
>> tas5130d1b
>>
>> sn9c103:
>> hv7131r *
>> mi0360 *
>> ov7630
>> pas202bcb
>>
>> sn9c105/120:
>> hv7131r
>> mi0360
>> mt9v111
>> ov7630
>> ov7660
>>
>> So only 3 raw bayer + custom compression models supported by
>> sn9c102 are not supported by gspca_sonixb, and all jpeg models
>> are supported by gspca_sonixj. Porting the 3 remaining models
>> over should be relatively easy, but I (I more or less maintain
>> the sonixb driver) really need hardware access to ensure things
>> stay working.
>>
>> Second correction, I was looking at an old tree and failed to
>> notice that the zc0301 driver has already bitten the dust
>> (good!).
>
> Thank you for your very helpful answer.
>
> Can you make a patch removing all the bogus usb IDs from these drivers?

I've just send a pull request including removal of all the bogus id's
from the et61x251 driver.

The sn9x102 driver is much harder to do, this would require hunting for
windows drivers and then looking inside the .inf files to figure out what
ids which are currently not in gspca could be added. More over the real
gain would be removing support for the jpeg sn9c1xx chips (the 105 and
120 bridge support in sn9c102) as that is completely covered by
gspca_sonixj. But that is not worth the effort given that we want the
entire driver to go away sooner rather then later.

Regards,

Hans
