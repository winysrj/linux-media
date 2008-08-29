Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KZ9Rh-0001p0-Dw
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 21:15:46 +0200
Received: from [212.12.32.49] (helo=smtp.work.de)
	by mail.work.de with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KZ9Rd-0006Rs-Ga
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 21:15:41 +0200
Received: from [217.164.61.201] (helo=[192.168.1.10])
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KZ9Rd-0005bt-1E
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 21:15:41 +0200
Message-ID: <48B84AD0.8010209@gmail.com>
Date: Fri, 29 Aug 2008 23:15:28 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080821173909.114260@gmx.net>	<37219a840808290852k4cafb891tbf35162d3add6d60@mail.gmail.com>	<20080829164352.74800@gmx.net>
	<200808292052.51219@orion.escape-edv.de>
In-Reply-To: <200808292052.51219@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] Future of DVB-S2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Oliver Endriss wrote:
> Hans Werner wrote:
>>>> Now, to show how simple I think all this could be, here is a PATCH
>>> implementing what
>>>> I think is the *minimal* API required to support DVB-S2.
>>>>
>>>> Notes:
>>>>
>>>> * same API structure, I just added some new enums and variables, nothing
>>> removed
>>>> * no changes required to any existing drivers (v4l-dvb still compiles)
>>>> * no changes required to existing applications (just need to be
>>> recompiled)
>>>> * no drivers, but I think the HVR4000 MFE patch could be easily adapted
>>>>
>>>> I added the fe_caps2 enum because we're running out of bits in the
>>> capabilities bitfield.
>>>> More elegant would be to have separate bitfields for FEC capabilities
>>> and modulation
>>>> capabilities but that would require (easy) changes to (a lot of) drivers
>>> and applications.
>>>> Why should we not merge something simple like this immediately? This
>>> could have been done
>>>> years ago. If it takes several rounds of API upgrades to reach all the
>>> feature people want then
>>>> so be it, but a long journey begins with one step.
>>> This will break binary compatibility with existing apps.  You're right
>>> -- those apps will work with a recompile, but I believe that as a
>>> whole, the linux-dvb kernel and userspace developers alike are looking
>>> to avoid breaking binary compatibility.
>> Michael,
>> thank you for your comment.
>>
>> I understand, but I think binary compatibility *should* be broken in this case. It makes
>> everything else simpler.
> 
> No way. Breaking binary compatibility is a no-go.
> 
>> I know that not breaking binary compatibility *can* be done (as in the HVR4000 SFE and
>> MFE patches) but at what cost?  The resulting code is very odd. Look at multiproto which 
>> bizarrely implements both the 3.2 and the 3.3 API and a compatibility layer as well, at huge cost
>> in terms of development time and complexity of understanding. The wrappers used in the MFE
>> patches are a neat and simple trick, but not something you would release in the kernel.
> 
> The only way to support DVB-S2 in a reasonable way is adding a new API.
> Multiproto does this.
> 
>> If you take the position the binary interface cannot *ever* change then you are severely
>> restricting the changes that can be made and you doom yourself to an API that is no longer
>> suited to the job. And the complexity kills. As we have seen, it makes the whole process grind to a
>> halt. 
>>
>> Recompilation is not a big deal. All distros recompile every application for each release (in fact much more frequently -- updates too), so most users will never even notice.  It is much better to make the right, elegant changes to the API and require a recompilation. It's better for the application developers because they get a sane evolution of the API and can more easily add new features. Anyone who
>> really cannot recompile existing userspace binaries will also have plenty of other restrictions and
>> should not be trying to drop a new kernel into a fixed userspace.
> 
> The linux distribution maintainers would kill you.
> Applications must continue to run after a kernel update.
> 
>> I would be interested to hear your opinion on how we can move forward rapidly.
> 
> Multiproto should be merged asap.


True. Sorry about the long delay, just got back after quite a long
journey. Will do so these following days.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
