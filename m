Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39509 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647AbcCCOja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 09:39:30 -0500
Subject: Re: tw686x driver
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
 <56D7E87B.1080505@xs4all.nl> <m3lh5zohsf.fsf@t19.piap.pl>
 <56D83E16.1010907@xs4all.nl> <m3h9gnod3t.fsf@t19.piap.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D84CA7.4050800@xs4all.nl>
Date: Thu, 3 Mar 2016 15:39:35 +0100
MIME-Version: 1.0
In-Reply-To: <m3h9gnod3t.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/16 15:22, Krzysztof Hałasa wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> There is no point whatsoever in committing a driver and then replacing it
>> with another which has a different feature set. I'm not going to do
>> that.
> 
> Sure, that's why I haven't asked you to do it.
> Now there is no another driver, as Ezequiel stated - there is just one
> driver.
> 
> The point is clear, showing who exactly wrote what.
> 
>> One option that might be much more interesting is to add your driver to
>> staging with a TODO stating that the field support should be added to
>> the mainline driver.
> 
> Field mode is one thing. What's a bit more important is that Ezequiel's
> changes take away the SG DMA, and basically all DMA. The chip has to use
> DMA, but his driver then simply memcpy() all the data to userspace
> buffers. This doesn't work on low-power machines.
> 
> Staging is meant for completely different situation - for immature,
> incomplete code. It has nothing to do with the case.

It can be for anything that prevents it from being mainlined. It was (still is?)
used for mature android drivers, for example.

> 
>> I'm not sure if Mauro would go for it, but I think this is a fair option.
> 
> I don't expect the situation to be fair to me, anymore.
> 
> I also don't want to pursue the legal stuff, copyright laws etc.,
> but a quick glance at the COPYING file at the root of the kernel sources
> may be helpful:
> 
>> 2. You may modify your copy or copies of the Program or any portion
>> of it, thus forming a work based on the Program, and copy and
>> distribute such modifications or work under the terms of Section 1
>> above, provided that you also meet all of these conditions:
>>
>>     a) You must cause the modified files to carry prominent notices
>>     stating that you changed the files and the date of any change.
> 
> I don't even ask for that much - I only ask that the single set of
> changes from Ezequiel has this very information. This is BTW one of the
> reasons we switched to git.

Ezequiel, can you make a v4 and add a link to the original patch posted by
Krzysztof that you based your code on?

I think that takes care of the provenance.

Regards,

	Hans
