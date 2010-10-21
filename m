Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab0JUVYX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 17:24:23 -0400
Message-ID: <4CC0AF83.7010300@redhat.com>
Date: Thu, 21 Oct 2010 19:24:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] [media] mceusb: Fix parser for Polaris
References: <cover.1287669886.git.mchehab@redhat.com> <20101021120748.47828273@pedra> <21DE3D7F-2805-4A11-AE29-9713FA58F66D@wilsonet.com> <4CC0A4BA.4080105@redhat.com> <0D654DD3-FC88-41F2-B8BD-04ED85FDC830@wilsonet.com>
In-Reply-To: <0D654DD3-FC88-41F2-B8BD-04ED85FDC830@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-10-2010 19:06, Jarod Wilson escreveu:
> On Oct 21, 2010, at 4:38 PM, Mauro Carvalho Chehab wrote:
> 
>> Em 21-10-2010 18:06, Jarod Wilson escreveu:

>>>> @@ -265,6 +265,7 @@ struct mceusb_dev {
>>>> 		u32 connected:1;
>>>> 		u32 tx_mask_inverted:1;
>>>> 		u32 microsoft_gen1:1;
>>>> +		u32 is_polaris:1;
>>>> 		u32 reserved:29;
>>>
>>> reserved should be decremented by 1 here if adding another flag.
>>
>> Ok. By curiosity, why are you reserving space on a bit array like that?
> 
> Legacy, mostly, I guess. Its been that way going back ages. I suppose we could just convert them all to bools and/or leave them as is and drop the reserved part entirely...

Agreed. If this is not part of any kabi (and it isn't, as far as I see), we can just
drop the reserved, as gcc will pad it accordingly.

> Yeah, this sorta grew from merging the old lirc_mceusb and lirc_mceusb2 drivers into one, and believe it or not, its actually cleaner than it used to be... :)
> 
> You've got a test patch in your inbox that attempts to merge the logic in this patch into the existing loop, and I'll see if I can beat on it with all three generations of stand-alone mceusb devices tonight...
> 

I'll do some tests and send you a feedback.

Cheers,
Mauro
