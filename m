Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41866 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751915AbdHaPo0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 11:44:26 -0400
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
 <20170830152314.0486fafb@lwn.net>
 <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org>
 <20170831064941.1fb18d20@vento.lan>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5e451631-e92d-5300-0b0c-ee9f3c1bbb30@infradead.org>
Date: Thu, 31 Aug 2017 08:44:23 -0700
MIME-Version: 1.0
In-Reply-To: <20170831064941.1fb18d20@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/17 02:49, Mauro Carvalho Chehab wrote:
> Em Wed, 30 Aug 2017 15:02:59 -0700
> Randy Dunlap <rdunlap@infradead.org> escreveu:
> 
>> On 08/30/17 14:23, Jonathan Corbet wrote:
>>> On Mon, 28 Aug 2017 16:10:09 -0700
>>> Randy Dunlap <rdunlap@infradead.org> wrote:
>>>   
>>>> kernel-doc parsing uses as ASCII codec, so let people know that
>>>> kernel-doc comments should be in ASCII characters only.
>>>>
>>>> WARNING: kernel-doc '../scripts/kernel-doc -rst -enable-lineno ../drivers/media/dvb-core/demux.h' processing failed with: 'ascii' codec can't decode byte 0xe2 in position 6368: ordinal not in range(128)  
>>>
>>> So I don't get this error.  What kind of system are you running the docs
>>> build on?  I would really rather that the docs system could handle modern
>>> text if possible, so it would be better to figure out what's going on
>>> here...  
>>
>> I'm OK with that. Source files in general don't need to be ASCII (0-127).
>>
>> I did this patch based on this (private) comment:
>>
>>> Yes, using ASCII should fix the problem.  
>>
>> what kind of system?  HP laptop.
>>
>> Linux midway.site 4.4.79-18.26-default #1 SMP Thu Aug 10 20:30:05 UTC 2017 (fa5a935) x86_64 x86_64 x86_64 GNU/Linux
>>
>>> sphinx-build --version  
>> Sphinx (sphinx-build) 1.3.1
> 
> I tried hard to reproduce the error here... I even added some Chinese
> chars on a kernel-doc markup and changed the language on my system
> to LANG=en_US.iso885915.
> 
> No luck. 
> 
> As Documentation/conf.py has:
> 
> 	# -*- coding: utf-8 -*-
> 
> on its first line, I suspect that the error you're getting is likely
> due to the usage of a python version that doesn't recognize this.
> 
> It seems that such dialect was introduced on python version 2.3:
> 
> 	https://docs.python.org/2.3/whatsnew/section-encodings.html
> 
> Yet, the documentation there seems to require a line before it,
> e. g.:
> 
> 	#!/usr/bin/env python
> 	# -*- coding: UTF-8 -*-
> 
> I suspect, however, that, if such line is added, on some systems it
> may not work, e. g. if both python 2 and 3 are installed, it could
> use the python version that doesn't have Sphinx installed.
> 
> So, I suspect that the safest way to fix it is with something like the
> enclosed patch. Still, it could be useful to know what's happening,
> just in case we get other reports.
> 
> Randy,
> 
> What's your python version?

> python --version
Python 2.7.13



-- 
~Randy
