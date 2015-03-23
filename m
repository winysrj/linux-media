Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34163 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbbCWOhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 10:37:15 -0400
Received: by iedfl3 with SMTP id fl3so42678081ied.1
        for <linux-media@vger.kernel.org>; Mon, 23 Mar 2015 07:37:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150322210218.499f83e3@concha.lan>
References: <5506BDA8.3000700@xs4all.nl>
	<20150322210218.499f83e3@concha.lan>
Date: Mon, 23 Mar 2015 08:37:14 -0600
Message-ID: <CAKocOOPq9S=4kjyAiuTHu-qttmAk2XEuUXP+5wefdSyEp9C2ag@mail.gmail.com>
Subject: Re: [media-workshop] [ANN] Media Mini-Summit Draft Agenda for March 26th
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 22, 2015 at 10:02 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Mon, 16 Mar 2015 12:25:28 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>> This is the draft agenda for the media mini-summit in San Jose on March 26th.
>>
>> Time: 9 AM to 5 PM (approximately)
>> Room: TBC (Mauro, do you know this?)
>
> I'll check on this Monday with LF and wiĺl give you a feedback.
>
>>
>> Attendees:
>>
>> Mauro Carvalho Chehab - mchehab@osg.samsung.com               - Samsung
>> Laurent Pinchart      - laurent.pinchart@ideasonboard.com     - Ideas on board
>> Hans Verkuil          - hverkuil@xs4all.nl                    - Cisco
>>
>> Mauro, do you have a better overview of who else will attend?
>
> This time, we'll be using ELC registration site to track. I'll see how
> we can get this info with LF as well, but, as people can join it
> dynamically, the best is to get the list with them on Thursday evening,
> and double-check during the Summit to track last-minute changes.
>
>>
>> Agenda:
>>
>> Times are approximate and will likely change.
>>
>> 9:00-9:15   Get everyone installed, laptops hooked up, etc.
>> 9:15-9:30   Introduction
>> 9:30-10:30  Media Controller support for DVB (Mauro):
>>               1) dynamic creation/removal of pipelines
>>               2) change media_entity_pipeline_start to also define
>>                  the final entity
>>               3) how to setup pipelines that also envolve audio and DRM
>>               4) how to lock the media controller pipeline between enabling a
>>                  pipeline and starting it, in order to avoid race conditions
>>

I am attending as well. Could you please add discussion on Media Tokens.
I will send out a 5 patch RFC series. We can discuss to see if it is worth while
continuing this work.

thanks,
-- Shuah
