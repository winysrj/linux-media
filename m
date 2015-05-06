Return-path: <linux-media-owner@vger.kernel.org>
Received: from heidi.turbocat.net ([88.198.202.214]:33444 "EHLO
	mail.turbocat.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbbEFF4o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 01:56:44 -0400
Message-ID: <5549AB70.6010203@selasky.org>
Date: Wed, 06 May 2015 07:49:36 +0200
From: Hans Petter Selasky <hps@selasky.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Time for a v4l-utils 1.8.0 release
References: <55491541.1040709@googlemail.com> <20150505172235.4bef50eb@recife.lan> <1597461.hFCejjGnu0@avalon>
In-Reply-To: <1597461.hFCejjGnu0@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/15 04:07, Laurent Pinchart wrote:
> Hi Mauro,
>
> On Tuesday 05 May 2015 17:22:35 Mauro Carvalho Chehab wrote:
>> Em Tue, 05 May 2015 21:08:49 +0200 Gregor Jasny escreveu:
>>> Hello,
>>>
>>> It's already more than half a year since the last v4l-utils release. Do
>>> you have any pending commits or objections? If no one vetos I'd like to
>>> release this weekend.
>>
>> There is are a additions I'd like to add to v4l-utils:
>>
>> 1) on DVB, ioctls may fail with -EAGAIN. Some parts of the libdvbv5 don't
>> handle it well. I made one quick hack for it, but didn't have time to
>> add a timeout to avoid an endless loop. The patch is simple. I just need
>> some time to do that;
>>
>> 2) The Media Controller control util (media-ctl) doesn't support DVB.
>>
>> The patchset adding DVB support on media-ctl is ready, and I'm merging
>> right now, and matches what's there at Kernel version 4.1-rc1 and upper.
>>
>> Yet, Laurent and Sakari want to do some changes at the Kernel API, before
>> setting it into a stone at Kernel v 4.1 release.
>
> I think Hans wants changes too.
>
>> This has to happen on the next 4 weeks.
>
> We'll try to, but depending on how review goes this might take more time.
>
> In the meantime I suggest moving the media-ctl changes to a separate branch
> and go with the v1.8.0 release as planned.
>
>> So, I suggest to postpone the release of 1.8.0 until the end of this month.
>

Hi,

Maybe someone would like to give the v4l-utils a spin on FreeBSD before 
release? Or is this the latest code in the .git ?

--HPS
