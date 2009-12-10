Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:62221 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZLJRWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 12:22:32 -0500
Message-ID: <4B212E5A.7080502@freemail.hu>
Date: Thu, 10 Dec 2009 18:22:34 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC,PATCH] VIDIOC_G_EXT_CTRLS does not handle NULL pointer correctly
References: <200905251317.02633.laurent.pinchart@skynet.be> <20090610105357.14aad29f@pedra.chehab.org> <200906102358.31879.laurent.pinchart@skynet.be> <200912101214.22154.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200912101214.22154.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Wednesday 10 June 2009 23:58:31 Laurent Pinchart wrote:
>> On Wednesday 10 June 2009 15:53:57 Mauro Carvalho Chehab wrote:
>>> Em Wed, 10 Jun 2009 10:52:28 -0300
>>>
>>> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
>>>> Em Mon, 25 May 2009 11:16:34 -0300
>>>>
>>>> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
>>>>> Em Mon, 25 May 2009 13:17:02 +0200
>>>>>
>>>>> Laurent Pinchart <laurent.pinchart@skynet.be> escreveu:
>>>>>> Hi everybody,
>>>>>>
>>>>>> Márton Németh found an integer overflow bug in the extended control
>>>>>> ioctl handling code. This affects both video_usercopy and
>>>>>> video_ioctl2. See http://bugzilla.kernel.org/show_bug.cgi?id=13357
>>>>>> for a detailed description of the problem.
>>>>>>
>>>>>>
>>>>>> Restricting v4l2_ext_controls::count to values smaller than
>>>>>> KMALLOC_MAX_SIZE / sizeof(struct v4l2_ext_control) should be
>>>>>> enough, but we might want to restrict the value even further. I'd
>>>>>> like opinions on this.
>>>>> Seems fine to my eyes, but being so close to kmalloc size doesn't
>>>>> seem to be a good idea. It seems better to choose an arbitrary size
>>>>> big enough to handle all current needs.
>>>> I'll apply the current version, but I still think we should restrict it
>>>> to a lower value.
>>> Hmm... SOB is missing. Márton and Laurent, could you please sign it
>> Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
> 
> Márton reminded me that the patch has still not been applied.
> 
> Please replace the above SOB line with
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Tested-by: Márton Németh <nm127@freemail.hu>
