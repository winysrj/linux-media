Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1AILy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jan 2011 06:54:56 -0500
Message-ID: <4D29A3D6.6060307@redhat.com>
Date: Sun, 09 Jan 2011 13:02:30 +0100
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
Sender: <mchehab@pedra>

Hi,

On 01/02/2011 09:13 PM, Hans Verkuil wrote:
> Hi Hans,
>
> On Sunday, January 02, 2011 19:33:31 Hans de Goede wrote:

<snip>

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

I've managed to make some time to also sort out the sn9c1xx usb ids
situation.  I've just send a pull request which includes patches cleaning
things up. After this there are only 5 usb-ids left which will default to
sn9c102 when both are compiled in, and only 3 of those are not supported
by gspca.

So if we move the sn9c102 driver to staging we will loose support for
only 3 usb-ids. IOW I think it is time to move it to staging :)

Note I can write a patch to add untested support for these 3 to the
sonixb driver, given my experience with adding support for the hv7131d
based on the sn9c102 code, that should be doable. But it will be
completely untested :(

Regards,

Hans
