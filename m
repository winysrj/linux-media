Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:42531 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbeA3Bo5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 20:44:57 -0500
Received: by mail-qk0-f173.google.com with SMTP id k201so8203092qke.9
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 17:44:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180128222319.wx2fl6pzzezezv5v@kekkonen.localdomain>
References: <CAGoCfixnHv-b3CbjqXLkFuK0J+_ejFnGRyxNJoywxuqQKBr_=Q@mail.gmail.com>
 <20180128222319.wx2fl6pzzezezv5v@kekkonen.localdomain>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Mon, 29 Jan 2018 20:44:43 -0500
Message-ID: <CAGoCfiwFAPeTMpgKdy99UgXiigot0nwkLKZ2w9COft-nZ8tGkg@mail.gmail.com>
Subject: Re: Regression in VB2 alloc prepare/finish balancing with em28xx/au0828
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

Thanks for taking the time to investigate.  See comments inline.

On Sun, Jan 28, 2018 at 5:23 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Devin,
>
> On Sun, Jan 28, 2018 at 09:12:44AM -0500, Devin Heitmueller wrote:
>> Hello all,
>>
>> I recently updated to the latest kernel, and I am seeing the following
>> dumped to dmesg with both au0828 and em28xx based devices whenever I
>> exit tvtime (my kernel is compiled with CONFIG_VIDEO_ADV_DEBUG=y by
>> default):
>
> Thanks for reporting this. Would you be able to provide the full dmesg,
> with VB2 debug parameter set to 2?

Output can be found at https://pastebin.com/nXS7MTJH

> I can't immediately see how you'd get this, well, without triggering a
> kernel warning or two. The code is pretty complex though.

If this is something I screwed up when I did the VB2 port for em28xx
several years ago, point me in the right direction and I'll see what I
can do.  However given we're seeing it with multiple drivers, this
feels like some subtle issue inside videobuf2.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
