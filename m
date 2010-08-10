Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1524 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0HJIEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 04:04:23 -0400
Message-ID: <b141c1c6bfc03ce320b94add5bb5f9fc.squirrel@webmail.xs4all.nl>
In-Reply-To: <1281425501.14489.7.camel@masi.mnp.nokia.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
    <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
    <201008091838.13247.hverkuil@xs4all.nl>
    <1281425501.14489.7.camel@masi.mnp.nokia.com>
Date: Tue, 10 Aug 2010 10:04:03 +0200
Subject: Re: [PATCH v7 1/5] V4L2: Add seek spacing and FM RX class.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: matti.j.aaltonen@nokia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


> On Mon, 2010-08-09 at 18:38 +0200, ext Hans Verkuil wrote:
>> On Monday 02 August 2010 16:06:39 Matti J. Aaltonen wrote:
>> > Add spacing field to v4l2_hw_freq_seek and also add FM RX class to
>> > control classes.
>>
>> This will no longer apply now that the control framework has been
>> merged.
>>
>> I strongly recommend converting the driver to use that framework. If
>> nothing else, you get support for the g/s/try_ext_ctrls ioctls for free.
>>
>> See the file Documentation/video4linux/v4l2-controls.txt.
>
> I can't find that file.  Should it be in some branch of the development
> tree?

It's in the new development tree, branch staging/v2.6.36:

http://git.linuxtv.org/media_tree.git

This replaced the v4l-dvb.git tree.

Regards,

         Hans

>
> I've updated my tree....:
>
> [remote "origin"]
>         url =
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>         fetch = +refs/heads/*:refs/remotes/origin/*
> [remote "linuxtv"]
>         url = http://linuxtv.org/git/v4l-dvb.git
>         fetch = +refs/heads/*:refs/remotes/linuxtv/*
>
> The closest file I have name-wise is
> Documentation/video4linux/v4l2-framework.txt
>
> Thanks,
> Matti A.
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

