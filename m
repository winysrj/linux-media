Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab0HJMOM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 08:14:12 -0400
Message-ID: <4C614294.7080101@redhat.com>
Date: Tue, 10 Aug 2010 09:14:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: ext Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: [PATCH v7 1/5] V4L2: Add seek spacing and FM RX class.
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>	 <201008091838.13247.hverkuil@xs4all.nl>	 <1281425501.14489.7.camel@masi.mnp.nokia.com>	 <b141c1c6bfc03ce320b94add5bb5f9fc.squirrel@webmail.xs4all.nl> <1281441830.14489.27.camel@masi.mnp.nokia.com>
In-Reply-To: <1281441830.14489.27.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 10-08-2010 09:03, Matti J. Aaltonen escreveu:
> On Tue, 2010-08-10 at 10:04 +0200, ext Hans Verkuil wrote:
>>> On Mon, 2010-08-09 at 18:38 +0200, ext Hans Verkuil wrote:
>>>> On Monday 02 August 2010 16:06:39 Matti J. Aaltonen wrote:
>>>>> Add spacing field to v4l2_hw_freq_seek and also add FM RX class to
>>>>> control classes.
>>>>
>>>> This will no longer apply now that the control framework has been
>>>> merged.
>>>>
>>>> I strongly recommend converting the driver to use that framework. If
>>>> nothing else, you get support for the g/s/try_ext_ctrls ioctls for free.
>>>>
>>>> See the file Documentation/video4linux/v4l2-controls.txt.
>>>
>>> I can't find that file.  Should it be in some branch of the development
>>> tree?
>>
>> It's in the new development tree, branch staging/v2.6.36:
>>
>> http://git.linuxtv.org/media_tree.git
>>
>> This replaced the v4l-dvb.git tree.
>>
>> Regards,
> 
> This mainly FYI:
> 
> I can read the v4l2-controls.txt file through your git web system... but
> after cloning etc. I can't see it...

You're probably at the wrong branch. you'll need to do something like:
	$ git checkout -b my_working_branch remotes/staging/v2.6.36

in order to create a new branch based on it.

Cheers,
Mauro
