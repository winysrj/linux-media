Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:34546 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751972AbdI2Pr0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 11:47:26 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20170929122931.2d9781ea@recife.lan>
Date: Fri, 29 Sep 2017 17:47:14 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Transfer-Encoding: 8BIT
Message-Id: <38FF55CB-FFFC-4538-ADB5-5B0E593EA4FF@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
 <cover.1506546492.git.mchehab@s-opensource.com>
 <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
 <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
 <20170929122931.2d9781ea@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 29.09.2017 um 17:29 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> Em Thu, 28 Sep 2017 18:28:32 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> Hi Mauro,
>> 
>>> Am 27.09.2017 um 23:10 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
>>> +It is possible to document nested structs unions, like::
>>> +
>>> +      /**
>>> +       * struct nested_foobar - a struct with nested unions and structs
>>> +       * @arg1: - first argument of anonymous union/anonymous struct
>>> +       * @arg2: - second argument of anonymous union/anonymous struct
>>> +       * @arg3: - third argument of anonymous union/anonymous struct
>>> +       * @arg4: - fourth argument of anonymous union/anonymous struct
>>> +       * @bar.st1.arg1 - first argument of struct st1 on union bar
>>> +       * @bar.st1.arg2 - second argument of struct st1 on union bar
>>> +       * @bar.st2.arg1 - first argument of struct st2 on union bar
>>> +       * @bar.st2.arg2 - second argument of struct st2 on union bar

With totally broken I mean "broken in sense of kernel-doc markup".
E.g. the missing ":" at the end of "@bar.st2.arg2:"  instead, there
is a minus "-". And in the first example you gave, there also missed
a ";" at the end of some of the elements. Anyway, the example
above is obsolete.

>>>  
>> 
>> Sorry, this example is totally broken --> below I attached a more
>> elaborate example. 
>> 
>> /* parse-SNIP: my_struct */
>> /**
>> * struct my_struct - a struct with nested unions and structs
>> * @arg1: first argument of anonymous union/anonymous struct
>> * @arg2: second argument of anonymous union/anonymous struct
>> * @arg3: third argument of anonymous union/anonymous struct
>> * @arg4: fourth argument of anonymous union/anonymous struct
>> * @bar.st1.arg1: first argument of struct st1 on union bar
>> * @bar.st1.arg2: second argument of struct st1 on union bar
>> * @bar.st2.arg1: first argument of struct st2 on union bar
>> * @bar.st2.arg2: second argument of struct st2 on union bar
>> * @bar.st3.arg2: second argument of struct st3 on union bar
>> */
>> struct my_struct {
>>   /* Anonymous union/struct*/
>>   union {
>> 	struct {
>> 	    __u8 arg1 : 1;
>> 	    __u8 arg2 : 3;
>> 	};
>>       struct {
>>           int arg1;
>>           int arg2;
>>       };
> 
> I added a:
> 
> 	#define __u8 char
> 
> In order to compile the above. As reported by gcc 7, this is broken:
> 
> test2.h:22:16: error: duplicate member ‘arg1’
>            int arg1;
>                ^~~~
> test2.h:23:16: error: duplicate member ‘arg2’
>            int arg2;
>                ^~~~
> 
> You can't have two symbols with the same name on different anonymous
> structs.

Ah, ok lets fix the example.

 -- Markus --
