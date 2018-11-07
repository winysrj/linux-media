Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbeKHGfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 01:35:14 -0500
Subject: Re: [RFC] Create test script(s?) for regression testing
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>, sean@mess.org,
        Shuah Khan <shuah@kernel.org>
References: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl>
 <2115308.QQYpHGbrpd@avalon> <b1bdffdb-9667-6c2a-b1be-b7bf2022817a@xs4all.nl>
 <4049608.APCVuh3Y7C@avalon> <20181107171035.0cc0360b@coco.lan>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <542253c4-cb09-ba7d-a0af-a9789c56e1af@kernel.org>
Date: Wed, 7 Nov 2018 14:03:03 -0700
MIME-Version: 1.0
In-Reply-To: <20181107171035.0cc0360b@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/2018 12:10 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 07 Nov 2018 12:06:55 +0200
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
>> Hi Hans,
>>
>> On Wednesday, 7 November 2018 10:05:12 EET Hans Verkuil wrote:
>>> On 11/06/2018 08:58 PM, Laurent Pinchart wrote:  
>>>> On Tuesday, 6 November 2018 15:56:34 EET Hans Verkuil wrote:  
>>>>> On 11/06/18 14:12, Laurent Pinchart wrote:  
>>>>>> On Tuesday, 6 November 2018 13:36:55 EET Sakari Ailus wrote:  
>>>>>>> On Tue, Nov 06, 2018 at 09:37:07AM +0100, Hans Verkuil wrote:  
>>>>>>>> Hi all,
>>>>>>>>
>>>>>>>> After the media summit (heavy on test discussions) and the V4L2 event
>>>>>>>> regression we just found it is clear we need to do a better job with
>>>>>>>> testing.
>>>>>>>>
>>>>>>>> All the pieces are in place, so what is needed is to combine it and
>>>>>>>> create a script that anyone of us as core developers can run to check
>>>>>>>> for regressions. The same script can be run as part of the kernelci
>>>>>>>> regression testing.  
>>>>>>>
>>>>>>> I'd say that *some* pieces are in place. Of course, the more there is,
>>>>>>> the better.
>>>>>>>
>>>>>>> The more there are tests, the more important it would be they're
>>>>>>> automated, preferrably without the developer having to run them on his/
>>>>>>> her own machine.  
>>>>>>
>>>>>> From my experience with testing, it's important to have both a core set
>>>>>> of tests (a.k.a. smoke tests) that can easily be run on developers'
>>>>>> machines, and extended tests that can be offloaded to a shared testing
>>>>>> infrastructure (but possibly also run locally if desired).  
>>>>>
>>>>> That was my idea as well for the longer term. First step is to do the
>>>>> basic smoke tests (i.e. run compliance tests, do some (limited) streaming
>>>>> test).
>>>>>
>>>>> There are more extensive (and longer running) tests that can be done, but
>>>>> that's something to look at later.
>>>>>   
>>>>>>>> We have four virtual drivers: vivid, vim2m, vimc and vicodec. The last
>>>>>>>> one is IMHO not quite good enough yet for testing: it is not fully
>>>>>>>> compliant to the upcoming stateful codec spec. Work for that is
>>>>>>>> planned as part of an Outreachy project.
>>>>>>>>
>>>>>>>> My idea is to create a script that is maintained as part of v4l-utils
>>>>>>>> that loads the drivers and runs v4l2-compliance and possibly other
>>>>>>>> tests against the virtual drivers.  
> 
> (adding Shuah)
> 
> IMO, the best would be to have something like that as part of Kernel
> self test, as this could give a broader covering than just Kernel CI.
> 

I agree with the broader coverage benefit that comes with adding tests to kselftest.
It makes it easier for making changes to tests/tools coupled with kernel/driver
changes. Common TAP13 reporting can be taken advantage of without doing any additional
work in the tests if author chooses to do so.

Tests can be added such that they don't get run by default if there is a reason do so
and Kernel CI and other rings can invoke it as a special case if necessary.

There are very clear advantages to making these tests part of the kernel source tree.
We can discuss at the Kernel Summit next week if you are interested.

thanks,
-- Shuah
