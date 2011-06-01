Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab1FAVeU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 17:34:20 -0400
Message-ID: <4DE6B059.8080308@redhat.com>
Date: Wed, 01 Jun 2011 18:34:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] DocBook: Add rules to auto-generate some
 media docbook
References: <96c3a1277523b929bd27f5d68d5f40e2a0e5bdf3.1306337174.git.mchehab@redhat.com>	<20110525122642.7b4f381f@pedra>	<20110525201027.57e2acc4.rdunlap@xenotime.net>	<4DE619F1.6020807@redhat.com> <20110601090126.0fe77a14.rdunlap@xenotime.net>
In-Reply-To: <20110601090126.0fe77a14.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-06-2011 13:01, Randy Dunlap escreveu:
> On Wed, 01 Jun 2011 07:52:33 -0300 Mauro Carvalho Chehab wrote:
> 
>> Hi Randy,
>>
>> Em 26-05-2011 00:10, Randy Dunlap escreveu:
>>> On Wed, 25 May 2011 12:26:42 -0300 Mauro Carvalho Chehab wrote:
>>>
>>>> Auto-generate the videodev2.h.xml,frontend.h.xml and the indexes.
>>>>
>>>> Some logic at the Makefile helps us to identify when a symbol is missing,
>>>> like for example:
>>>>
>>>> Error: no ID for constraint linkend: V4L2-PIX-FMT-JPGL.
>>>
>>>
>>> a.  Still get that message..  is that OK?
>>>
>>> b.  In the generated index.html file, "media" is listed first, but it should be
>>> listed in alphabetical order, not first.
>>>
>>> c.  The generated files are (hidden) in .tmpmedia/
>>>
>>> d.  The link from the top-level index.html file to "media" is to
>>> media/index.html, but the file is actually in .tmpmedia/media/index.html
>>>
>>> e.  patches 1/3 and 2/3 are OK.
>>>
>>>
>>> Please build docs with and without using "O=builddir" and test that.
>>>
>>> I'm looking over the generated output now and will let you know if I see
>>> any other problems.
>>
>> Fixed the pointed issues. I also moved the media-specific stuff into another
>> Makefile. I opted to include it into the DocBook Makefile, as otherwise, I would
>> need to duplicate the xml conversion stuff into the media/Makefile.
> 
> Sounds good.  Thanks.
> 
>> Patch is enclosed.
> 
> It will probably be a few days before I test this again,
> so just merge it when you are ready...

Thanks for your review. I'll add it to my to my -next tree today. It is probably
ok to wait for 3.1 merge window before merging it upstream. Just merging it at the
development tree will help us to track troubles at the API changes.

Thanks,
Mauro
