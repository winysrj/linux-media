Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:36395 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932274AbcKNOQL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 09:16:11 -0500
Received: by mail-yw0-f179.google.com with SMTP id a10so59555312ywa.3
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2016 06:16:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8ff2fc76-2290-d353-08cd-2aa31c31a19c@xs4all.nl>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
 <1470247430-11168-8-git-send-email-steve_longerbeam@mentor.com> <8ff2fc76-2290-d353-08cd-2aa31c31a19c@xs4all.nl>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Mon, 14 Nov 2016 09:16:08 -0500
Message-ID: <CAGoCfiyu+iGmy4pu8UQE8YrN=RUBAda4HD0PDjboq8QJTh0dnw@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] v4l: Add signal lock status to source change events
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, mchehab@kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> OK, but what can the application do with that event? If the glitch didn't
> affect the video, then it is pointless.
>
> If the lock is lost, then normally you loose video as well. If not, then
> applications are not interested in the event.

What about free running mode (where some decoders delivers blue or
black video with no signal present)?  In that case it might still be
useful to inform the application so it can show a message that says
something like "No Signal".

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
