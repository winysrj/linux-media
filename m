Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab1GQBIA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2011 21:08:00 -0400
Message-ID: <4E2235DE.2070107@redhat.com>
Date: Sat, 16 Jul 2011 22:07:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <4E1F8E1F.3000008@redhat.com> <4E1FBA6F.10509@redhat.com> <201107150717.08944@orion.escape-edv.de> <19999.63914.990114.26990@morden.metzler> <4E203FD0.4030503@redhat.com> <4E207252.5050506@linuxtv.org> <4E20D042.3000302@iki.fi> <4E21832A.20600@redhat.com> <4E219D49.1070709@iki.fi> <4E21A63A.8040008@redhat.com> <4E21B0DE.2020902@linuxtv.org> <4E21B1E6.4090302@iki.fi>
In-Reply-To: <4E21B1E6.4090302@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-07-2011 12:44, Antti Palosaari escreveu:
> On 07/16/2011 06:40 PM, Andreas Oberritter wrote:
>> On 16.07.2011 16:54, Mauro Carvalho Chehab wrote:
>>> Em 16-07-2011 11:16, Antti Palosaari escreveu:

>>> Approach 4) fe0 is a frontend "superset"
>>>
>>> *adapter0
>>> *frontend0 (DVB-S/DVB-S2/DVB-T/DVB-T2/DVB-C/ISDB-T) - aka: FE superset
>>> *frontend1 (DVB-S/DVB-S2)
>>> *frontend2 (DVB-T/DVB-T2)
>>> *frontend3 (DVB-C)
>>> *frontend4 (ISDB-T)
>>>
>>> fe0 will need some special logic to allow redirecting a FE call to the right fe, if
>>> there are more than one physical frontend bound into the FE API.
>>>
>>> I'm starting to think that (4) is the better approach, as it won't break legacy
>>> applications, and it will provide an easier way for new applications to control
>>> the frontend with just one frontend.
>>
>> Approach 4 would break existing applications, because suddenly they'd
>> have to cope with an additional device. It would be impossible for an
>> existing application to tell whether frontend0 (from your example) was a
>> real device or not.

(not sure who commented this... somehow, I didn't receive the original email - well,
I'll just reply on Antti's answer)

Yes, an existing application will not know how to handle such fe, but, as the other
fe's are still provided, they can swill switch the delivery system by replacing the
frontend they're using. There are some alternatives for this approach, like:

Approach 5) fe0 is a frontend "superset", initialized to handle the first registered
delivery system

>>> *adapter0
>>> *frontend0 (DVB-S/DVB-S2), but allows changing to DVB-T/DVB-T2/DVB-C/ISDB-T
>>> *frontend1 (DVB-T/DVB-T2)
>>> *frontend2 (DVB-C)
>>> *frontend3 (ISDB-T)

(so, it is something between approach 1 and 4)

Being frankly, I think that this would be messy.

In any case, I think that, if we decide for something like approach 4 or 5, we 
should deprecate the support for the extra frontends, after kernel + 2 versions,
so, falling back into approach 2 (e. g. just one frontend for all delivery systems).

I also think that we should get a decision about that for 3.1, and port DRX-K to
the agreed approach before the release of 3.1, as it will be one less driver that
we'll need to concern about migrating.

Cheers,
Mauro
