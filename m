Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51540 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab1IZKPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 06:15:08 -0400
Received: by qyk30 with SMTP id 30so9712277qyk.19
        for <linux-media@vger.kernel.org>; Mon, 26 Sep 2011 03:15:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7FE9E8.3010404@gmail.com>
References: <4E7F1FB5.5030803@gmail.com>
	<20110925180340.GB23820@linuxtv.org>
	<4E7FE9E8.3010404@gmail.com>
Date: Mon, 26 Sep 2011 18:15:07 +0800
Message-ID: <CAHG8p1Dk=wtM7vpZNhYyw7GUvWpB3jK_6pghxpDHpjMWk6W56w@mail.gmail.com>
Subject: Re: Problems cloning the git repostories
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/9/26 Mauro Carvalho Chehab <maurochehab@gmail.com>:
> Em 25-09-2011 15:03, Johannes Stezenbach escreveu:
>> On Sun, Sep 25, 2011 at 07:33:57AM -0500, Patrick Dickey wrote:
>>>
>>> I tried to follow the steps for cloning both the "media_tree.git" and
>>> "media_build.git" repositories, and received errors for both.  The
>>> media_tree repository failed on the first line
>>>
>>>> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb
>>>
>>> which I'm assuming is because kernel.org is down.
>>>
>>> The media_build.git repository fails on the first line also
>>>
>>>> git clone git://linuxtv.org/media_build.git
>>>
>>> with a fatal: read error: Connection reset by peer.
>>
>> The git error should be fixed now.
>>
>> But please don't clone from linuxtv.org, intead use
>> git clone git://github.com/torvalds/linux.git
>> and then add linuxtv to your repo like described on
>> http://git.linuxtv.org/media_tree.git
>
> I've updated the instructions together with the git tree to point to the
> github tree.
>
I followed your instructions using http instead, but I found it's not
up to date.

scott@scott-desktop:~/Projects/git-kernel/v4l-dvb$ git log
commit 69d232ae8e95a229e7544989d6014e875deeb121
Author: Sakari Ailus <sakari.ailus@iki.fi>
Date:   Wed Jun 15 15:58:48 2011 -0300

    [media] omap3isp: ccdc: Use generic frame sync event instead of
private HS_VS event

scott@scott-desktop:~/Projects/git-kernel/v4l-dvb$ git remote -v
linuxtv http://linuxtv.org/git/media_tree.git (fetch)
linuxtv http://linuxtv.org/git/media_tree.git (push)
origin  http://github.com/torvalds/linux.git (fetch)
origin  http://github.com/torvalds/linux.git (push)

Can anybody tell me why?
