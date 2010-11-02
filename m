Return-path: <mchehab@gaivota>
Received: from rouge.crans.org ([138.231.136.3]:36994 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab0KBKWF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 06:22:05 -0400
Message-ID: <4CCFE4DE.8070706@crans.ens-cachan.fr>
Date: Tue, 02 Nov 2010 11:15:58 +0100
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: Stephan Trebels <stephan@trebels.com>
CC: linux-media@vger.kernel.org, adq_dvb@lidskialf.net
Subject: Re: [libdvben50221] stack leaks resources on non-MMI session reconnect.
References: <1279200014.14890.33.camel@stephan-laptop> <4C5F2747.1010806@crans.ens-cachan.fr>
In-Reply-To: <4C5F2747.1010806@crans.ens-cachan.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 08/08/2010 23:53, DUBOST Brice wrote:
> On 15/07/2010 15:20, Stephan Trebels wrote:
>>
>> The issue was, that LIBDVBEN50221 did not allow a CAM to re-establish
>> the session holding non-MMI resources if using the lowlevel interface.
>> The session_number was recorded on open, but not freed on close (which
>> IMO is an bug in the code, I attach the scaled down hg changeset). With
>> this change, the SMIT CAM with a showtime card works fine according to
>> tests so far.
>>
>> The effect was, that the CAM tried to constantly close and re-open the
>> session and the LIBDVBEN50221 kept telling it, that the resource is
>> already allocated to a different session. Additionally this caused the
>> library to use the _old_ session number in communications with the CAM,
>> which did not even exist anymore, so caused all writes of CA PMTs to
>> fail with EINTR.
>>
>> Stephan
>>
>
> Hello
>
> Just to inform that this patch solves problems with CAM PowerCAM v4.3,
> so I think it can interest more people.
>
> Before gnutv -cammenu (and other applications using libdvben50221) was
> returning ti;eout (-3) errors constantly after the display of the system
> IDs.
>
> Now, the menu is working flawlessly
>
> I cannot test the descrambling for the moment but it improved quite a
> lot the situation (communication with th CAM is now possible).
>
> One note concerning the patch itself, the last "else if (resource_id ==
> EN50221_APP_MMI_RESOURCEID)" is useless.
>
> Best regards
>
>


Hello


After more testing this Patches allow several CAM models to work and 
don't seem to make any regression.

Is there anything to be improved/tested for having it included upstream ?

Thank you

Regards

-- 
Brice

A: Yes.
 >Q: Are you sure?
 >>A: Because it reverses the logical flow of conversation.
 >>>Q: Why is top posting annoying in email?
