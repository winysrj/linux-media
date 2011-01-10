Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab1AJBdS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jan 2011 20:33:18 -0500
Message-ID: <4D2A61D9.1090807@redhat.com>
Date: Sun, 09 Jan 2011 23:33:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: RFC: Move the deprecated et61x251 and sn9c102 to staging
References: <201101012053.00372.hverkuil@xs4all.nl> <4D20A908.9020705@redhat.com> <4D20C4FB.9060906@redhat.com> <201101022113.01133.hverkuil@xs4all.nl> <4D29A3D6.6060307@redhat.com>
In-Reply-To: <4D29A3D6.6060307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-01-2011 10:02, Hans de Goede escreveu:
> Hi,
> 
> On 01/02/2011 09:13 PM, Hans Verkuil wrote:
>> Hi Hans,
>>
>> On Sunday, January 02, 2011 19:33:31 Hans de Goede wrote:
> 
> <snip>
> 
>>> So only 3 raw bayer + custom compression models supported by
>>> sn9c102 are not supported by gspca_sonixb, and all jpeg models
>>> are supported by gspca_sonixj. Porting the 3 remaining models
>>> over should be relatively easy, but I (I more or less maintain
>>> the sonixb driver) really need hardware access to ensure things
>>> stay working.
>>>
>>> Second correction, I was looking at an old tree and failed to
>>> notice that the zc0301 driver has already bitten the dust
>>> (good!).
>>
>> Thank you for your very helpful answer.
>>
>> Can you make a patch removing all the bogus usb IDs from these drivers?
> 
> I've managed to make some time to also sort out the sn9c1xx usb ids
> situation.  I've just send a pull request which includes patches cleaning
> things up. After this there are only 5 usb-ids left which will default to
> sn9c102 when both are compiled in, and only 3 of those are not supported
> by gspca.

Good!
> 
> So if we move the sn9c102 driver to staging we will loose support for
> only 3 usb-ids. IOW I think it is time to move it to staging :)

This would be a regression.

> Note I can write a patch to add untested support for these 3 to the
> sonixb driver, given my experience with adding support for the hv7131d
> based on the sn9c102 code, that should be doable. But it will be
> completely untested :(

I think that the better would be to add support for it at gspca, but wait for
some feedback before considering it working.

Cheers,
Mauro
