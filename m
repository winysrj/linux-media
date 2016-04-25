Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33117 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889AbcDYUxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 16:53:08 -0400
Received: by mail-wm0-f65.google.com with SMTP id r12so24867929wme.0
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 13:53:07 -0700 (PDT)
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Pavel Machek <pavel@ucw.cz>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425165848.GA10443@amd> <571E5134.10607@gmail.com>
 <20160425184016.GC10443@amd> <571E6D38.9050009@gmail.com>
 <20160425204110.GA2689@amd>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <571E83B0.8020208@gmail.com>
Date: Mon, 25 Apr 2016 23:53:04 +0300
MIME-Version: 1.0
In-Reply-To: <20160425204110.GA2689@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 25.04.2016 23:41, Pavel Machek wrote:
> Hi!
>
>> All my testing so far was performed using modules, though it shouldn't make
>> difference.
>>
>>> https://lkml.org/lkml/2016/4/16/14
>>> https://lkml.org/lkml/2016/4/16/33
>>>
>>
>> More stuff is needed, all those twl4030 regulator patches (already in
>> linux-next) + DTS initial-mode patch
>> (https://lkml.org/lkml/2016/4/17/78).
>
> Aha, that explains a lot. Dealing with -next would be tricky, I guess;
> can I just pull from your camera branch?
>
> https://github.com/freemangordon/linux-n900/tree/camera

I guess yes, though I am not sure all the patches there are compatible 
with userland different from maemo, so be careful. Also, the correct 
branch is v4.6-rc4-n900-camera.

Ivo
