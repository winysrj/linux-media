Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:43816 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSDub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 22:50:31 -0500
Received: by mail-ob0-f182.google.com with SMTP id wo20so10745834obc.13
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 19:50:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5485B636.4080509@collabora.com>
References: <CANC6fRFHYsTrUmAMYBWy9u=7ahCqYqOZLGUqrUDCwQm=FnmUbQ@mail.gmail.com>
	<5485B5CC.6040101@collabora.com>
	<5485B636.4080509@collabora.com>
Date: Fri, 19 Dec 2014 11:50:30 +0800
Message-ID: <CANC6fRGYhbiGi3_ob+FH8hhKkiTaNEM0wTTay+YTmgTOXNsDAw@mail.gmail.com>
Subject: Re: V4l2 state transition
From: Bin Chen <bin.chen@linaro.org>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nicolas,

On 8 December 2014 at 22:31, Nicolas Dufresne
<nicolas.dufresne@collabora.com> wrote:
>
> Le 2014-12-08 09:29, Nicolas Dufresne a écrit :
>
>>
>> Le 2014-12-08 00:19, Bin Chen a écrit :
>>>
>>> Can anyone comment is following state transition diagram for V4l2 user
>>> space program make sense? Do you see any issues if we were to enforce
>>> this constraint?
>>
>> I think you should request some buffers before streamon. If in capture,
>> you should also queue the minimum amount of buffers.
> I forgot, setting input and format isn't strictly required. Driver should
> have decent default configured.
>

Thanks for all the explaining.

> Nicolas



-- 
Regards,
Bin
