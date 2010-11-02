Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:56648 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0KBQSf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 12:18:35 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PDJZA-0003UU-H7
	for linux-media@vger.kernel.org; Tue, 02 Nov 2010 17:18:32 +0100
Received: from 92.103.125.220 ([92.103.125.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 17:18:32 +0100
Received: from ticapix by 92.103.125.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 17:18:32 +0100
To: linux-media@vger.kernel.org
From: "pierre.gronlier" <ticapix@gmail.com>
Subject: Re: [libdvben50221] stack leaks resources on non-MMI session reconnect.
Date: Tue, 02 Nov 2010 17:18:09 +0100
Message-ID: <iapdk6$se6$1@dough.gmane.org>
References: <1279200014.14890.33.camel@stephan-laptop>	 <4C5F2747.1010806@crans.ens-cachan.fr>	 <4CCFE4DE.8070706@crans.ens-cachan.fr> <1288694309.3365.11604.camel@stephan-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: <1288694309.3365.11604.camel@stephan-laptop>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Stephan Trebels wrote, On 11/02/2010 11:38 AM:
> Hi Brice,
> 
> I did not find more things to be changed, and it works fine for me now.
> Given, that the responsiveness on this list is a bit underwhelming, I
> wonder whether we can find someone with commit privileges, to push this
> change.
> 

Hi,

I've tested this patch too and it solves problems with two different
cams. (powercam v4 and cryptoworks by philips)

Commiting it would be great.

-- 
Pierre

> Stephan
> 
> On Tue, 2010-11-02 at 11:15 +0100, DUBOST Brice wrote: 
>> On 08/08/2010 23:53, DUBOST Brice wrote:
>>> On 15/07/2010 15:20, Stephan Trebels wrote:
>>>>
>>>> The issue was, that LIBDVBEN50221 did not allow a CAM to re-establish
>>>> the session holding non-MMI resources if using the lowlevel interface.
>>>> The session_number was recorded on open, but not freed on close (which
>>>> IMO is an bug in the code, I attach the scaled down hg changeset). With
>>>> this change, the SMIT CAM with a showtime card works fine according to
>>>> tests so far.
>>>>
>>>> The effect was, that the CAM tried to constantly close and re-open the
>>>> session and the LIBDVBEN50221 kept telling it, that the resource is
>>>> already allocated to a different session. Additionally this caused the
>>>> library to use the _old_ session number in communications with the CAM,
>>>> which did not even exist anymore, so caused all writes of CA PMTs to
>>>> fail with EINTR.
>>>>
>>>> Stephan
>>>>
>>>
>>> Hello
>>>
>>> Just to inform that this patch solves problems with CAM PowerCAM v4.3,
>>> so I think it can interest more people.
>>>
>>> Before gnutv -cammenu (and other applications using libdvben50221) was
>>> returning ti;eout (-3) errors constantly after the display of the system
>>> IDs.
>>>
>>> Now, the menu is working flawlessly
>>>
>>> I cannot test the descrambling for the moment but it improved quite a
>>> lot the situation (communication with th CAM is now possible).
>>>
>>> One note concerning the patch itself, the last "else if (resource_id ==
>>> EN50221_APP_MMI_RESOURCEID)" is useless.
>>>
>>> Best regards
>>>
>>>
>>
>>
>> Hello
>>
>>
>> After more testing this Patches allow several CAM models to work and 
>> don't seem to make any regression.
>>
>> Is there anything to be improved/tested for having it included upstream ?
>>
>> Thank you
>>
>> Regards
>>
> 


