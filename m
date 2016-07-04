Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50801 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbcGDNVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:21:15 -0400
Subject: Re: Stepping down as gspca and pwc maintainer
To: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <0b81648e-90ab-e9b2-4192-a7a387e86fc0@redhat.com>
 <069af446-e341-71a4-fb96-62c4d8f96b0a@xs4all.nl>
 <acdcd418-436b-394a-e456-346479d338d6@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <689c4c86-83bd-a7b9-14df-f9ae79919dae@xs4all.nl>
Date: Mon, 4 Jul 2016 15:21:10 +0200
MIME-Version: 1.0
In-Reply-To: <acdcd418-436b-394a-e456-346479d338d6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/2016 03:00 PM, Hans de Goede wrote:
> Hi,
> 
> On 04-07-16 09:36, Hans Verkuil wrote:
>> Hi Hans,
>>
>> On 07/03/2016 11:31 PM, Hans de Goede wrote:
>>> Hi All,
>>>
>>> Admittedly I've not been all that active as gspca and pwc
>>> maintainer lately, but officially I'm still the maintainer
>>> for both.
>>>
>>> Between my $dayjob, other foss projects and last but not
>>> least spending time with my wife and children I'm way too busy
>>> lately.
>>>
>>> So I'm hereby officially stepping down as gspca and pwc maintainer,
>>> I know this means MAINTAINERS needs updating, but I'm hoping to
>>> find a volunteer to take them over who can then directly replace my
>>> name in MAINTAINERS.
>>
>> I can take over as "Odd Fixes" maintainer. I have a pwc webcam and several
>> gspca webcams, so I can at least test some webcams if needed.
> 
> Cool, thanks!
> 
>>> Both are currently in descent shape, one thing which needs
>>> doing (for a long time now) is converting gspca to videobuf2.
>>>
>>> Other then that the following patches are pending in
>>> patchwork (and are all ready to be merged I just never
>>> got around to it):
>>>
>>> 1 actual bug-fix which should really be merged asap
>>
>> Merged for 4.7-rcX or 4.8?
> 
> I guess not many people have 10 Gbps usb-3.1 ports
> yet, and even fewer will plug an old webcam into such
> a port, so 4.8 is fine I think.

OK.

> 
>>> (Mauro can you pick this one up directly ?):
>>>
>>> https://patchwork.linuxtv.org/patch/34155/
>>>
>>> 1 compiler warning:
>>> https://patchwork.linuxtv.org/patch/32726/
>>>
>>> A couple of v4l-compliance fixes:
>>> https://patchwork.linuxtv.org/patch/33408/
>>> https://patchwork.linuxtv.org/patch/33412/
>>> https://patchwork.linuxtv.org/patch/33411/
>>> https://patchwork.linuxtv.org/patch/33410/
>>> https://patchwork.linuxtv.org/patch/33409/
>>
>> I'll make a pull request for these today.
>>
>>>
>>> And last there is this patch which need someone to review it:
>>> https://patchwork.linuxtv.org/patch/34986/
>>
>> I can take care of that.
> 
> Thanks.
> 
> On 04-07-16 09:38, Hans Verkuil wrote:
>  >
>  > What about the two radio-shark drivers?
> 
> Ah yes, if you could take over those 2 too that would be
> great. Can you send a patch to update MAINTAINERS ?

Done. Please Ack!

Regards,

	Hans

> 
> Regards,
> 
> Hans
> 
