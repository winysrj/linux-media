Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbbBJI3i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2015 03:29:38 -0500
Message-ID: <54D9C14A.1080906@redhat.com>
Date: Tue, 10 Feb 2015 09:28:58 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Luis de Bethencourt <luis@debethencourt.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: divide error: 0000 in the gspca_topro
References: <54D7E0B8.30503@reflexion.tv>	<CA+55aFxB4Wq-Bob_+q0c3oS1hUf_BLGqqyoepGRDvm9-X2Y+og@mail.gmail.com>	<20150209102348.GB28420@biggie> <20150209135656.11cc85e6@recife.lan>
In-Reply-To: <20150209135656.11cc85e6@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09-02-15 16:56, Mauro Carvalho Chehab wrote:
> Em Mon, 09 Feb 2015 10:23:48 +0000
> Luis de Bethencourt <luis@debethencourt.com> escreveu:
>
>> On Sun, Feb 08, 2015 at 06:07:45PM -0800, Linus Torvalds wrote:
>>> I got this, and it certainly seems relevant,.
>>>
>>> It would seem that that whole 'quality' thing needs some range
>>> checking, it should presumably be in the range [1..100] in order to
>>> avoid negative 'sc' values or the divide-by-zero.
>>>
>>> Hans, Mauro?
>>>
>>>                        Linus
>>
>> Hello Linus,
>>
>> The case of quality being set to 0 is correctly handled in
>> drivers/media/usb/gspca/jpeg.h [0], so I have sent a patch to do the same
>> in topro.c.
>
> Patch looks good to me.
>
> I'll double check if some other driver has the same bad handling for
> quality set and give a couple days for Hans to take a look.
>
> If he's fine with this approach, I'll add it on a separate pull request.

Luis' patch for this looks good to me and is:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Mauro, thanks for picking this one up.

Regards,

Hans
