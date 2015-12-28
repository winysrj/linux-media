Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60452 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbL1QFg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 11:05:36 -0500
Subject: Re: [PATCH RFC] [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY
To: Greg KH <gregkh@linuxfoundation.org>
References: <d029047c76d6d3e5e6a531080ede83f6e063f7db.1451311244.git.mchehab@osg.samsung.com>
 <5681572F.601@osg.samsung.com> <20151228154429.GA27560@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56815DCE.6040304@osg.samsung.com>
Date: Mon, 28 Dec 2015 09:05:34 -0700
MIME-Version: 1.0
In-Reply-To: <20151228154429.GA27560@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/28/2015 08:44 AM, Greg KH wrote:
> On Mon, Dec 28, 2015 at 08:37:19AM -0700, Shuah Khan wrote:
>> On 12/28/2015 07:03 AM, Mauro Carvalho Chehab wrote:
>>> There are a few discussions left with regards to this ioctl:
>>>
>>> 1) the name of the new structs will contain _v2_ on it?
>>> 2) what's the best alternative to avoid compat32 issues?
>>>
>>> Due to that, let's postpone the addition of this new ioctl to
>>> the next Kernel version, to give people more time to discuss it.
>>
>> I thought we discussed this in our irc meeting and
>> arrived at a good solution for compat32 issue
>>
>> My recommendation is getting this ioctl into 4.5 with
>> a warning that it could change. The reason for that is
>> that this ioctl helps with testing the media controller
>> v2 api. Without this API, we won't see much testing from
>> userspace in 4.5
> 
> People will ignore the warning, that never works :(
> 

Yeah. If people do ignore warnings, it could become a
problem if we have to make changes.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
