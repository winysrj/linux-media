Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2EARim (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 13:38:42 -0400
Received: by bkcji2 with SMTP id ji2so1083988bkc.19
        for <linux-media@vger.kernel.org>; Tue, 01 May 2012 10:38:41 -0700 (PDT)
Message-ID: <4FA01F9E.9040002@gmail.com>
Date: Tue, 01 May 2012 19:38:38 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v3 09/14] V4L: Add camera 3A lock control
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <1335536611-4298-10-git-send-email-s.nawrocki@samsung.com> <201204301759.46192.hverkuil@xs4all.nl>
In-Reply-To: <201204301759.46192.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2012 05:59 PM, Hans Verkuil wrote:
> On Friday 27 April 2012 16:23:26 Sylwester Nawrocki wrote:
>> The V4L2_CID_3A_LOCK bitmask control allows applications to pause
>> or resume the automatic exposure, focus and wite balance adjustments.
>> It can be used, for example, to lock the 3A adjustments right before
>> a still image is captured, for pre-focus, etc.
>> The applications can control each of the algorithms independently,
>> through a corresponding control bit, if driver allows that.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   Documentation/DocBook/media/v4l/controls.xml |   40 ++++++++++++++++++++++++++
>>   drivers/media/video/v4l2-ctrls.c             |    2 ++
>>   include/linux/videodev2.h                    |    5 ++++
>>   3 files changed, 47 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index bf481d4..51509f4 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -3253,6 +3253,46 @@ lens-distortion correction.</entry>
>>   	</row>
>>   	<row><entry></entry></row>
>>
>> +	<row>
>> +	<entry spanname="id"><constant>V4L2_CID_3A_LOCK</constant></entry>
>> +	<entry>bitmask</entry>
>> +	</row>
>> +	<row>
>> +	<entry spanname="descr">This control locks or unlocks the automatic
>> +exposure, white balance and focus. The automatic adjustments can be paused
>> +independently by setting the coresponding lock bit to 1. The camera then retains
> 
> Small typo: coresponding ->  corresponding

Ok, thanks for pointing out. I've just found a few more by running 
spell checker on everything again.

>> +the corresponding 3A settings, until the lock bit is cleared. The value of this
>> +control may be changed by other, exposure, white balance or focus controls. The
> 
> The sentence 'The value ... focus controls' doesn't parse. I think 'other, ' needs
> to be removed.

Yeah, indeed, I'll correct that. I have already edited this paragraph 
and this sentence is gone. That's a new version:
http://git.infradead.org/users/kmpark/linux-samsung/commitdiff/95444f3180570186a11b9c6d2643d5644f0e8b21

I'm going to leave the sentence though, and remove this one instead:

"The locks have highest priority and must be disabled when automatic 
camera settings are required."

Since a use case with V4L2_CID_3A_LOCK having "top priority" could 
be modelled with the control flags. And it might be hard to predict 
how the controls interact with each other among various cameras.

--

Thanks,
Sylwester
