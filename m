Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab1LYKSD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 05:18:03 -0500
Message-ID: <4EF6F84C.3000307@redhat.com>
Date: Sun, 25 Dec 2011 08:17:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Georgi Chorbadzhiyski <gf@unixsol.org>, linux-media@vger.kernel.org
Subject: Re: DVB-S2 multistream support
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi>
In-Reply-To: <4EF6DD91.2030800@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25-12-2011 06:23, Antti Palosaari wrote:
> On 12/25/2011 03:06 AM, Georgi Chorbadzhiyski wrote:
>> Guys are there any news on DVB-S2 multistream support. I have
>> found test patches at http://www.tbsdtv.com/forum/viewtopic.php?f=26&t=1874
>> and judging by report on dvblast-devel ML they seem to work.
>>
>> What is holding them back, perhaps nobody submitted them?

I don't remember seeing any patches submitted for it.

The patch "budget-omicom.patch" seems to be a hack that will likely break support
for other supported devices.

The patch stv090x-mis.patch also seems wrong, as "props->dvbs2_mis_id" is probably
initialized with 0 by the core, so, by default, the MIS filter will be enabled.
That's said, the approach there assumes that just one mis can be filtered. I'm wandering
if it wouldn't be better to use the same approach taken inside dvb-core for PIP filtering.

In any case, the dvb properties cache should be initialized to have the MIS filter
disabled, and only enable it if userspace requests it via FE_SET_PROPERTY.

> Ok, there seems to be now TS IDs for ISDB-S, DVB-T2 and DVB-S2. I wonder who those are 
> defined in our DVB API as own parameter for each standard...

The per-standard parameters were introduced by ISDB-T. It probably makes sense for
the ISDB specific parameters, as no other delivery system looks like that, but we should
avoid propagating it for other delivery systems, expecially DVB-*, as the new parameters
may be used on other delivery systems on that family.

It would be great to fix this as soon as possible, in order to avoid propagating it.
The fix should be simple: just rename the parameter, and create an alias to the
previous name.

Regards,
Mauro

> 
> Antti
> 
> 

