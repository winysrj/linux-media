Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab1AJKqX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 05:46:23 -0500
Message-ID: <4D2AE37B.2020105@redhat.com>
Date: Mon, 10 Jan 2011 08:46:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: RFC: Move the deprecated et61x251 and sn9c102 to staging
References: <201101012053.00372.hverkuil@xs4all.nl> <4D20A908.9020705@redhat.com> <4D20C4FB.9060906@redhat.com> <201101022113.01133.hverkuil@xs4all.nl> <4D29A3D6.6060307@redhat.com> <4D2A61D9.1090807@redhat.com> <4D2ADF4C.4020709@redhat.com>
In-Reply-To: <4D2ADF4C.4020709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-01-2011 08:28, Hans de Goede escreveu:
> Hi,
> 
> On 01/10/2011 02:33 AM, Mauro Carvalho Chehab wrote:
>> Em 09-01-2011 10:02, Hans de Goede escreveu:
> 
> <snip>
> 
>>> I've managed to make some time to also sort out the sn9c1xx usb ids
>>> situation.  I've just send a pull request which includes patches cleaning
>>> things up. After this there are only 5 usb-ids left which will default to
>>> sn9c102 when both are compiled in, and only 3 of those are not supported
>>> by gspca.
>>
>> Good!
>>>
>>> So if we move the sn9c102 driver to staging we will loose support for
>>> only 3 usb-ids. IOW I think it is time to move it to staging :)
>>
>> This would be a regression.
>>
> 
> Yes, although I wonder if anyone will notice. Fedora has had the sn9c102
> driver disabled for 3 releases now and I've received (and fixed) a single
> bug in all that time about a cam not supported by gspca_sonixb which
> was supported by sn9c102
> 
>>> Note I can write a patch to add untested support for these 3 to the
>>> sonixb driver, given my experience with adding support for the hv7131d
>>> based on the sn9c102 code, that should be doable. But it will be
>>> completely untested :(
>>
>> I think that the better would be to add support for it at gspca, but wait for
>> some feedback before considering it working.
> 
> Well I've never seen these cams in the wild. sonixb cams with vga sensors
> are quite rare because they cannot do more then 7.5-10 fps. So most cam
> makers did the smart thing and went with a sonixj bridge for vga sensors.
> 
> Anyways I'll do a gspca patch for adding support for the missing 3 models
> (as time permits). And then we can ship that (and make it the default
> if both are compiled in) for 1 or 2 cycles before moving the sn9c102 driver
> to staging. Assuming we don't receive any negative feedback in those
> 2 cycles (or manage to fix found bugs).

It seems perfect to me.
> 
> Regards,
> 
> Hans

