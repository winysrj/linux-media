Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58323 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbaKFL5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Nov 2014 06:57:36 -0500
Message-ID: <545B621C.7080601@xs4all.nl>
Date: Thu, 06 Nov 2014 12:57:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>,
	hans.verkuil@cisco.com, Gregor Jasny <gjasny@googlemail.com>
Subject: Re: v4l2-ctl bug(?) printing ctrl payload array
References: <CANZNk82AqfbSkUd_xONtjAxLePA0TMhS_5wuWERObyGSZ5QYoA@mail.gmail.com> <CANZNk81oAbQ+t3gNqMH6b=ieGfyxEJu7oT=oFY9xABv=t7+f=w@mail.gmail.com> <545B4006.1010401@xs4all.nl>
In-Reply-To: <545B4006.1010401@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/14 10:31, Hans Verkuil wrote:
> On 11/05/14 20:52, Andrey Utkin wrote:
>> More on the same topic.
>> I believe there's another bug on displaying of payload.
>> Let's say we have the same [45][45] array, and this is what is posted to it:
>> uint16_t buf[45 * 45] = {0, };
>>         buf[0] = 1;
>>         buf[1] = 2;
>>         buf[45] = 3;
>>         buf[45 * 45 - 1] = 0xff;
>>
>> What is shown by v4l2-ctl you can see here:
>> https://dl.dropboxusercontent.com/u/43104344/v4l2-ctl_payload_bug.png
>>
> 
> I'll look at this Friday or Monday.
> 
> I want to add some test array controls to the vivid driver as well to make
> it easier to test such controls, so that will be a good test case.

OK, I had some time and I made several fixes. Please pull from v4l-utils.git
and verify that it is now working correctly.

Thanks for reporting this!

Regards,

	Hans
