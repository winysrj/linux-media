Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab0AWUqA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 15:46:00 -0500
Message-ID: <4B5B30E4.7030909@redhat.com>
Date: Sat, 23 Jan 2010 18:24:52 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Brandon Philips <brandon@ifup.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl>
In-Reply-To: <201001210834.28112.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On 01/21/2010 08:34 AM, Hans Verkuil wrote:
> On Thursday 21 January 2010 03:46:05 Brandon Philips wrote:
>> On 00:07 Thu 21 Jan 2010, Mauro Carvalho Chehab wrote:
>>> Brandon Philips wrote:
>>>> On 19:50 Wed 20 Jan 2010, Hans de Goede wrote:
>>>>> On 01/20/2010 04:41 PM, Mauro Carvalho Chehab wrote:
>>>>>> As we're discussing about having a separate tree for v4l2-apps,
>>>>>> maybe the better is to port it to -git (in a way that we can
>>>>>> preserve the log history).
>>>>
>>>> I have a small script I used to convert the history of libv4l to
>>>> git. Let me know when we are ready to drop them from the hg tree
>>>> and I can do the conversion and post the result for review.
>>>>
>>>> This is the result from the script for just libv4l:
>>>>   http://ifup.org/git/?p=libv4l.git;a=summary
>>>
>>> Seems fine, but we need to import the entire v4l2-apps.
>>
>> Yes, I know. I will run the script over v4l2-apps to generate a git
>> repo once v4l2-apps is ready to be dropped from v4l-dvb mercurial and
>> we figure out the directory layout.
>>
>> Doing it before is just a waste of time since they will get out of
>> sync.
>>
>>>> Also, I suggest we call the repo v4lutils? In the spirit of
>>>> usbutils, pciutils, etc.
>>>
>>> Hmm... as dvb package is called as dvb-utils, it seems more logical to call it
>>> v4l2-utils, but v4l2utils would equally work.
>>
>> Yes, that is fine.
>>
>>> IMO, the better is to use v4l2 instead of just v4l, to avoid causing
>>> any mess with the old v4l applications provided with xawtv.
>>
>> The problem I saw was that libv4l1 will be in v4l2-utils. I don't care
>> either way though.
>>
>> So here is how I see v4l-utils.git being laid out based on what others
>> have said:
>>
>>   libv4l1/
>>   libv4l2/
>>   libv4lconvert/
>>   test/
>>   v4l2-dbg/
>>   contrib/
>>    qv4l2-qt3/
>>    qv4l2-qt4/
>>    cx25821/
>>    etc... everything else
>
> Hmm. I think I would prefer to have a structure like this:
>
> lib/
> 	libv4l1/
> 	libv4l2/
> 	libv4lconvert/
> utils/
> 	v4l2-dbg
> 	v4l2-ctl
> 	cx18-ctl
> 	ivtv-ctl
> contrib/
> 	test/
> 	everything else
>
> And everything in lib and utils can be packaged by distros, while contrib
> is not packaged.
>

+1 for this directory layout.

Regards,

Hans
