Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48224 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1IZC4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 22:56:48 -0400
Received: by wwf22 with SMTP id 22so6105872wwf.1
        for <linux-media@vger.kernel.org>; Sun, 25 Sep 2011 19:56:46 -0700 (PDT)
Message-ID: <4E7FE9E8.3010404@gmail.com>
Date: Sun, 25 Sep 2011 23:56:40 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Problems cloning the git repostories
References: <4E7F1FB5.5030803@gmail.com> <20110925180340.GB23820@linuxtv.org>
In-Reply-To: <20110925180340.GB23820@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-09-2011 15:03, Johannes Stezenbach escreveu:
> On Sun, Sep 25, 2011 at 07:33:57AM -0500, Patrick Dickey wrote:
>>
>> I tried to follow the steps for cloning both the "media_tree.git" and
>> "media_build.git" repositories, and received errors for both.  The
>> media_tree repository failed on the first line
>>
>>> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb 
>>
>> which I'm assuming is because kernel.org is down.
>>
>> The media_build.git repository fails on the first line also
>>
>>> git clone git://linuxtv.org/media_build.git 
>>
>> with a fatal: read error: Connection reset by peer.
> 
> The git error should be fixed now.
> 
> But please don't clone from linuxtv.org, intead use
> git clone git://github.com/torvalds/linux.git
> and then add linuxtv to your repo like described on
> http://git.linuxtv.org/media_tree.git

I've updated the instructions together with the git tree to point to the
github tree.

Btw, the media_build had an issue due to the move of tm6000 and altera-stapl
out of staging. I've fixed it. At least here with 3.0 kernel, everything
is compiling fine.

Cheers,
Mauro
> 
> 
> Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

