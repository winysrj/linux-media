Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0CWLDF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 07:03:05 -0400
Message-ID: <4BA8A027.90702@redhat.com>
Date: Tue, 23 Mar 2010 12:04:07 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
References: <201003200958.49649.hverkuil@xs4all.nl> <201003220117.34790.hverkuil@xs4all.nl> <4BA73865.3070107@redhat.com> <201003221155.45733.hverkuil@xs4all.nl>
In-Reply-To: <201003221155.45733.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/22/2010 11:55 AM, Hans Verkuil wrote:
> On Monday 22 March 2010 10:29:09 Hans de Goede wrote:
>> Hi,
>>
>> On 03/22/2010 01:17 AM, Hans Verkuil wrote:
>>> On Sunday 21 March 2010 23:45:04 Hans Verkuil wrote:
>>>> On Saturday 20 March 2010 09:58:49 Hans Verkuil wrote:
>>>>> These drivers have no hardware to test with: bw-qcam, c-qcam, arv, w9966.
>>>>> However, all four should be easy to convert to v4l2, even without hardware.
>>>>> Volunteers?
>>>>
>>>> I've converted these four drivers to V4L2.
>>>
>>> I've also removed the V4L1 support from cpia2 and pwc and removed some last
>>> V4L1 code remnants from meye and zoran. It's all in the same tree.
>>>
>>> Hans, could you test the pwc driver for me?
>>>
>>
>> Done,
>>
>> And the news is not good I'm afraid, it does not work. I've one interesting
>> observation though. It does work if I first run it once with the "old"
>> version of the driver and then load your version (also replacing videodev.ko,
>> etc with the ones from your tree). But if I plug it in with your driver in
>> place it does not stream (nothing interesting in dmesg). So it seems like
>> an initialization problem.
>
> When you run it with the old version, are you using the V4L1 API or the V4L2
> API? And what program do you use for testing?
>

I was using cheese, which uses the V4l2 api (through gstreamer).

Regards,

Hans
