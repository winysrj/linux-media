Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbZKRTs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 14:48:28 -0500
Message-ID: <4B044F6E.8010008@infradead.org>
Date: Wed, 18 Nov 2009 17:47:58 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Help in adding documentation
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com> <20091117142820.1e62a362@pedra.chehab.org> <A69FA2915331DC488A831521EAE36FE401559C5A38@dlee06.ent.ti.com> <4B02E444.3020707@infradead.org> <A69FA2915331DC488A831521EAE36FE401559C60B9@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401559C60B9@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karicheri, Muralidharan wrote:
> Mauro,
> 
> Is there specific way to create patch for this documentation?
> 
> Can I just do following commands and send one patch?
> 
> Baseline tree - v4l-dvb-base (original)
> Changed tree -  v4l-dvb-change
> 
> diff -uNr v4l-dvb-base v4l-dvb-change >media-doc.patch

Well, this should work, however the better way is to clone the
tree with hg, modify it and do 
	hg diff >media-doc.patch

Mercurial is not that different from cvs, svn or git, so you can
also commit patches there and later export them for sending via email.

> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
> 
>> -----Original Message-----
>> From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
>> Sent: Tuesday, November 17, 2009 12:58 PM
>> To: Karicheri, Muralidharan
>> Cc: Hans Verkuil; linux-media@vger.kernel.org
>> Subject: Re: Help in adding documentation
>>
>> Karicheri, Muralidharan escreveu:
>>> Mauro,
>>>
>>> Thanks for your reply. I made progress after my email. My new file
>>> is being processed by Makefile now. I have some issues with some
>>> tags.
>>>
>>>> This probably means that videodev2.h has it defined, while you didn't
>> have
>>> Do you mean videodev2.h.xml? I see there videodev2.h under linux/include.
>> Do I need to copy my latest videodev2.h to that directory?
>>
>> videodev2.h.xml is generated automatically by Makefile, from videodev2.h.
>>
>> Basically, Makefile scripts will parse it, search for certain
>> structs/enums/ioctls and
>> generate videodev2.h.xml.
>>
>> What happens is that you likely declared the presets enum on videodev2.h,
>> and the
>> enum got detected, producing a <linkend> tag. However, as you didn't define
>> the
>> reference ID for that tag on your xml file, you got an error.
>>>> the
>>>> link id created at the xml file you've created.
>>>>
>>>> You probably need a tag like:
>>>>
>>>> <table pgwide="1" frame="none" id="v4l2-dv-enum-presets">
>>>> <!-- your enum table -->
>>>> </table>
>>>>
>>>>
>>>> Cheers,
>>>> Mauro
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

