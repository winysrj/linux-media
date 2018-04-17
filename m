Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39050 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750831AbeDQGMK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 02:12:10 -0400
Subject: Re: [RFCv11 PATCH 00/29] Request API
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <CAPBb6MVLpV6gbUWBnQpYiNoWmjqdhYOhicrsetT0S5p_w28HDw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <95c7bf3a-06f0-46d6-d51f-47e851180681@xs4all.nl>
Date: Tue, 17 Apr 2018 08:12:04 +0200
MIME-Version: 1.0
In-Reply-To: <CAPBb6MVLpV6gbUWBnQpYiNoWmjqdhYOhicrsetT0S5p_w28HDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2018 06:33 AM, Alexandre Courbot wrote:
> On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> Hi all,
> 
>> This is a cleaned up version of the v10 series (never posted to
>> the list since it was messy).
> 
> Hi Hans,
> 
> It took me a while to test and review this, but finally have been able to
> do it.
> 
> First the result of the test: I have tried porting my dummy vim2m test
> program
> (https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42 for
> reference),
> and am getting a hang when trying to queue the second OUTPUT buffer (right
> after
> queuing the first request). If I move the calls the VIDIOC_STREAMON after
> the
> requests are queued, the hang seems to happen at that moment. Probably a
> deadlock, haven't looked in detail yet.
> 
> I have a few other comments, will follow up per-patch.
> 

I had a similar/same (?) report about this from Paul:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg129177.html

I hope to resume my Request API work on Thursday.

Regards,

	Hans
