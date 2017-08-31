Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42538 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbdHaQYk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 12:24:40 -0400
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
To: Jani Nikula <jani.nikula@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
 <20170830152314.0486fafb@lwn.net>
 <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org>
 <20170831064941.1fb18d20@vento.lan> <87h8wn98bv.fsf@intel.com>
 <20170831105602.5607fe52@vento.lan> <20170831081721.38be05ef@lwn.net>
 <f9e30c84-7ad7-39dd-a39f-f62581f0b893@infradead.org>
 <87d17b90zb.fsf@intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <abb31f2b-c9db-f063-eb8a-0d580226ab23@infradead.org>
Date: Thu, 31 Aug 2017 09:24:37 -0700
MIME-Version: 1.0
In-Reply-To: <87d17b90zb.fsf@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/17 09:05, Jani Nikula wrote:
> On Thu, 31 Aug 2017, Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 08/31/17 07:17, Jonathan Corbet wrote:
>>> On Thu, 31 Aug 2017 10:56:26 -0300
>>> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
>>>
>>>> It should have something to do with python version and/or to some
>>>> locale info at the system, as neither I or Jon can reproduce it.
>>>
>>> I can't reproduce it here, but I have certainly seen situations where
>>> Python 2 wants to run with the ascii codec by default.
>>>
>>> Note that the exception happens in our Sphinx extension, not in Sphinx
>>> itself.  We've had other non-ascii text in our docs, so I think Sphinx is
>>> doing the right thing.  The problem is with our own code.  If I could
>>> reproduce it, it shouldn't be too hard to track down - take out that
>>> massive "except anything" block and see where it explodes.
>>>
>>> Randy, which distribution are you running, and are you using their version
>>> of Sphinx?
>>
>> opensuse LEAP 42.2
>> Yes, their sphinx 1.3.1.
> 
> What's your LANG setting? I think that's what it boils down to, and
> trying to work around non-UTF-8 LANG in both python 2 and 3 compatible
> ways.

(default)
LANG=C

until I add the patch:
+LANG=C.utf-8

> The odd thing is that I can reproduce the issue using a small python
> snippet, but not through Sphinx.



-- 
~Randy
