Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:50444 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0A2RMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 12:12:44 -0500
Message-ID: <4B631702.3040608@freemail.hu>
Date: Fri, 29 Jan 2010 18:12:34 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvcvideo: check minimum border of control
References: <4B5F60B0.7090709@freemail.hu> <4B63083C.5020909@redhat.com> <4B6314C6.80503@freemail.hu> <4B63159D.9090708@redhat.com>
In-Reply-To: <4B63159D.9090708@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Németh Márton wrote:
>> Mauro Carvalho Chehab wrote:
>>> Németh Márton wrote:
>>>> Check also the minimum border of a value before setting it
>>>> to a control value.
>>>>
>>>> See also http://bugzilla.kernel.org/show_bug.cgi?id=12824 .
>>> Patch didn't apply. Had you generated against our -git tree?
>>> 	http://git.linuxtv.org/v4l-dvb.git
>> No, this is against http://git.linuxtv.org/pinchartl/uvcvideo.git .
>> The latest patch which tried to fix http://bugzilla.kernel.org/show_bug.cgi?id=12824
>> missed to check the minimum border.
> 
> Ah, ok. Please specify on the subject when you're writing patches against
> a different tree. This helps me to tag accordingly at Patchwork, 

Could you please give me an example what do you mean? For example in
this case.

Regards,

	Márton Németh
