Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:55573 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbZFJPwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 11:52:10 -0400
Message-ID: <4A2FD61A.9030003@freemail.hu>
Date: Wed, 10 Jun 2009 17:49:46 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-media@vger.kernel.org
Subject: Re: [RFC,PATCH] VIDIOC_G_EXT_CTRLS does not handle NULL pointer correctly
References: <200905251317.02633.laurent.pinchart@skynet.be>	<20090525111634.0f9593be@pedra.chehab.org>	<20090610105228.3ca409ba@pedra.chehab.org> <20090610105357.14aad29f@pedra.chehab.org>
In-Reply-To: <20090610105357.14aad29f@pedra.chehab.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Wed, 10 Jun 2009 10:52:28 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> 
>> Em Mon, 25 May 2009 11:16:34 -0300
>> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
>>
>>> Em Mon, 25 May 2009 13:17:02 +0200
>>> Laurent Pinchart <laurent.pinchart@skynet.be> escreveu:
>>>
>>>> Hi everybody,
>>>>
>>>> Márton Németh found an integer overflow bug in the extended control ioctl 
>>>> handling code. This affects both video_usercopy and video_ioctl2. See 
>>>> http://bugzilla.kernel.org/show_bug.cgi?id=13357 for a detailed description of 
>>>> the problem.
>>>>
>>>> Restricting v4l2_ext_controls::count to values smaller than KMALLOC_MAX_SIZE /
>>>> sizeof(struct v4l2_ext_control) should be enough, but we might want to 
>>>> restrict the value even further. I'd like opinions on this.
>>> Seems fine to my eyes, but being so close to kmalloc size doesn't seem to be a
>>> good idea. It seems better to choose an arbitrary size big enough to handle all current needs.
>> I'll apply the current version, but I still think we should restrict it to a lower value.
> 
> 
> Hmm... SOB is missing. Márton and Laurent, could you please sign it

As I wrote at http://bugzilla.kernel.org/show_bug.cgi?id=13357#c6 :

Tested-by: Márton Németh <nm127@freemail.hu>

Regards,

	Márton Németh


