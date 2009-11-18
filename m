Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43593 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023AbZKRSTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 13:19:19 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 18 Nov 2009 12:19:16 -0600
Subject: RE: Help in adding documentation
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C60B9@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com>
 <20091117142820.1e62a362@pedra.chehab.org>
 <A69FA2915331DC488A831521EAE36FE401559C5A38@dlee06.ent.ti.com>
 <4B02E444.3020707@infradead.org>
In-Reply-To: <4B02E444.3020707@infradead.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Is there specific way to create patch for this documentation?

Can I just do following commands and send one patch?

Baseline tree - v4l-dvb-base (original)
Changed tree -  v4l-dvb-change

diff -uNr v4l-dvb-base v4l-dvb-change >media-doc.patch

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
>Sent: Tuesday, November 17, 2009 12:58 PM
>To: Karicheri, Muralidharan
>Cc: Hans Verkuil; linux-media@vger.kernel.org
>Subject: Re: Help in adding documentation
>
>Karicheri, Muralidharan escreveu:
>> Mauro,
>>
>> Thanks for your reply. I made progress after my email. My new file
>> is being processed by Makefile now. I have some issues with some
>> tags.
>>
>>> This probably means that videodev2.h has it defined, while you didn't
>have
>>
>> Do you mean videodev2.h.xml? I see there videodev2.h under linux/include.
>Do I need to copy my latest videodev2.h to that directory?
>
>videodev2.h.xml is generated automatically by Makefile, from videodev2.h.
>
>Basically, Makefile scripts will parse it, search for certain
>structs/enums/ioctls and
>generate videodev2.h.xml.
>
>What happens is that you likely declared the presets enum on videodev2.h,
>and the
>enum got detected, producing a <linkend> tag. However, as you didn't define
>the
>reference ID for that tag on your xml file, you got an error.
>>
>>> the
>>> link id created at the xml file you've created.
>>>
>>> You probably need a tag like:
>>>
>>> <table pgwide="1" frame="none" id="v4l2-dv-enum-presets">
>>> <!-- your enum table -->
>>> </table>
>>>
>>>
>>> Cheers,
>>> Mauro
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

