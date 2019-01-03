Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98836C43612
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 10:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7048F20815
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 10:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfACKPX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 05:15:23 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54008 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbfACKPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 05:15:23 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id f01zgJbPOIx4Wf023gcDv8; Thu, 03 Jan 2019 11:15:20 +0100
Subject: Re: [PATCH v3.16 2/2] v4l: event: Add subscription to list before
 calling "add" operation
To:     Yi Qingliang <niqingliang2003@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        "for 4.14 and up" <stable@vger.kernel.org>
References: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
 <20181108120350.17266-3-sakari.ailus@linux.intel.com>
 <ae0bc57fad9bf7db15b9b3943dd5bb093a9d386d.camel@decadent.org.uk>
 <CADwFkYeFDgKvC5r6X4x-A73R1KwmPr6SLmiaavti_kdJ3UHiZw@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <326afce1-5b40-cff6-be63-8c64be3f8dbd@xs4all.nl>
Date:   Thu, 3 Jan 2019 11:15:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CADwFkYeFDgKvC5r6X4x-A73R1KwmPr6SLmiaavti_kdJ3UHiZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfInBwu6p93R89CFFDGLYc3AyIo6TqvQvARxvnaK48jMjPfkDaimLTI9L9rYHqvuT9DidUBQ425ZodsQyFQcBCA3rHPQDW4CrLf1ABtuTGjO1EQWfgn5F
 aR+V/kpFTTSpOr9teIMXX4Kmc7cdjnUZDL4jlIKVSALZUL7eY7+P26E70Ox0YkaDUu/piZzwn7PQZLhAxXN5vJbTWDIBmUeKGpNELY2BOkJd18ZvXahXSLuw
 g5mp1/T9PpwEuMiTzw/SaPolWdTvsCx87RZQJp/4h4xuRMf4hZPhXnFpNvN0o6vrkDOuqffk+CSjOIZCwcMQPdrTf6s+OnQYk4dolatPBi3a8A2cUQH3JRec
 RUYiwtVSmSpVjxRdn7VpLGOLcDegiW4f0E9ArVeNdh7zZKQvGpJI0QivzIR09eZ5UIXrzAWIkcTKcg5TRIVFNsfas2tWiA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/03/2019 01:58 AM, Yi Qingliang wrote:
> hello, I sent a email about 'can't wake problem' 4 days ago.
> 
> Is this problem related with mine?

No, it's unrelated.

I'll take a look at vb2_poll next week.

Regards,

	Hans

> 
>> epoll and vb2_poll: can't wake_up
> 
>> Sun, Dec 30, 2018, 6:17 PM (4 days ago)
>> to linux-kernel
>> Hello, I encountered a "can't wake_up" problem when use camera on imx6.
>>
>> if delay some time after 'streamon' the /dev/video0, then add fd
>> through epoll_ctl, then the process can't be waken_up after some time.
>>
>> I checked both the epoll / vb2_poll(videobuf2_core.c) code.
>>
>> epoll will pass 'poll_table' structure to vb2_poll, but it only
>> contain valid function pointer when inserting fd.
>>
>> in vb2_poll, if found new data in done list, it will not call 'poll_wait'.
>> after that, every call to vb2_poll will not contain valid poll_table,
>> which will result in all calling to poll_wait will not work.
>>
>> so if app can process frames quickly, and found frame data when
>> inserting fd (i.e. poll_wait will not be called or not contain valid
>> function pointer), it will not found valid frame in 'vb2_poll' finally
>> at some time, then call 'poll_wait' to expect be waken up at following
>> vb2_buffer_done, but no good luck.
>>
>> I also checked the 'videobuf-core.c', there is no this problem.
>>
>> of course, both epoll and vb2_poll are right by itself side, but the
>> result is we can't get new frames.
>>
>> I think by epoll's implementation, the user should always call poll_wait.
>>
>> and it's better to split the two actions: 'wait' and 'poll' both for
>> epoll framework and all epoll users, for example, v4l2.
>>
>> am I right?
> 
> On Thu, Jan 3, 2019 at 4:17 AM Ben Hutchings <ben@decadent.org.uk> wrote:
>>
>> On Thu, 2018-11-08 at 14:03 +0200, Sakari Ailus wrote:
>>> [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
>>>
>>> Patch ad608fbcf166 changed how events were subscribed to address an issue
>>> elsewhere. As a side effect of that change, the "add" callback was called
>>> before the event subscription was added to the list of subscribed events,
>>> causing the first event queued by the add callback (and possibly other
>>> events arriving soon afterwards) to be lost.
>>>
>>> Fix this by adding the subscription to the list before calling the "add"
>>> callback, and clean up afterwards if that fails.
>> [...]
>>
>> I've queued this up for the next update, thanks.
>>
>> Ben.
>>
>> --
>> Ben Hutchings
>> Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer
>>
>>

