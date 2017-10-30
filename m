Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:43319 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932291AbdJ3Qsz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 12:48:55 -0400
Subject: Re: [patch] libv4l2: SDL test application
To: =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, sre@kernel.org,
        ivo.g.dimitrov.75@gmail.com, linux-media@vger.kernel.org
References: <20171028195742.GB20127@amd>
 <478fd1ae-6f25-5cda-3035-1d5894c8caab@xs4all.nl>
 <20171030164136.jkn2qlzu27krqvdz@pali>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <40975cb7-4622-9072-d756-5b8173d37f93@xs4all.nl>
Date: Mon, 30 Oct 2017 17:48:50 +0100
MIME-Version: 1.0
In-Reply-To: <20171030164136.jkn2qlzu27krqvdz@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/30/2017 05:41 PM, Pali Rohár wrote:
> On Monday 30 October 2017 17:30:53 Hans Verkuil wrote:
>> Hi Pavel,
>>
>> On 10/28/2017 09:57 PM, Pavel Machek wrote:
>>> Add support for simple SDL test application. Allows taking jpeg
>>> snapshots, and is meant to run on phone with touchscreen. Not
>>> particulary useful on PC with webcam, but should work.
>>
>> When I try to build this I get:
>>
>> make[3]: Entering directory '/home/hans/work/src/v4l/v4l-utils/contrib/test'
>>   CCLD     sdlcam
>> /usr/bin/ld: sdlcam-sdlcam.o: undefined reference to symbol 'log2@@GLIBC_2.2.5'
>> //lib/x86_64-linux-gnu/libm.so.6: error adding symbols: DSO missing from command line
>> collect2: error: ld returned 1 exit status
>> Makefile:561: recipe for target 'sdlcam' failed
>> make[3]: *** [sdlcam] Error 1
>> make[3]: Leaving directory '/home/hans/work/src/v4l/v4l-utils/contrib/test'
>> Makefile:475: recipe for target 'all-recursive' failed
>> make[2]: *** [all-recursive] Error 1
>> make[2]: Leaving directory '/home/hans/work/src/v4l/v4l-utils/contrib'
>> Makefile:589: recipe for target 'all-recursive' failed
>> make[1]: *** [all-recursive] Error 1
>> make[1]: Leaving directory '/home/hans/work/src/v4l/v4l-utils'
>> Makefile:516: recipe for target 'all' failed
>> make: *** [all] Error 2
>>
>> I had to add -lm -ldl -lrt to sdlcam_LDFLAGS. Is that correct?
> 
> Is not for <<undefined reference to symbol 'log2@@GLIBC_2.2.5'>> needed
> just -lm? log2 should be in mathematical library.
> 

Sorry, I was unclear: after adding -lm I got an unresolved for dl_open, after
adding -ldl I got an unresolved on shm_open.

Only after using all three did it compile.

Regards,

	Hans
