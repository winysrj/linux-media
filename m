Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:39991 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbeCFDDD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2018 22:03:03 -0500
Received: by mail-ua0-f176.google.com with SMTP id c14so12066427uak.7
        for <linux-media@vger.kernel.org>; Mon, 05 Mar 2018 19:03:03 -0800 (PST)
Received: from mail-ua0-f176.google.com (mail-ua0-f176.google.com. [209.85.217.176])
        by smtp.gmail.com with ESMTPSA id k17sm422889uaf.44.2018.03.05.19.03.01
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Mar 2018 19:03:01 -0800 (PST)
Received: by mail-ua0-f176.google.com with SMTP id q12so2476658uae.4
        for <linux-media@vger.kernel.org>; Mon, 05 Mar 2018 19:03:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d91922a4-656a-1998-6176-592f343aee5a@rock-chips.com>
References: <1519893856-4738-1-git-send-email-zhengsq@rock-chips.com>
 <CAAFQd5AteVDQgHaov2Jqjbx5bAjmJJiXv-7R0HG+AcE3GH-JTw@mail.gmail.com> <d91922a4-656a-1998-6176-592f343aee5a@rock-chips.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 6 Mar 2018 12:02:40 +0900
Message-ID: <CAAFQd5BFthOWqg4Bidhn2qK+cKvva2yrDeZEYvnWukWN=FhRDg@mail.gmail.com>
Subject: Re: [PATCH] media: ov2685: Not delay latch for gain
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 1, 2018 at 7:14 PM, Shunqian Zheng <zhengsq@rock-chips.com> wro=
te:
> Hi Tomasz,
>
>
> On 2018=E5=B9=B403=E6=9C=8801=E6=97=A5 16:53, Tomasz Figa wrote:
>>
>> Hi Shunqian,
>>
>> On Thu, Mar 1, 2018 at 5:44 PM, Shunqian Zheng <zhengsq@rock-chips.com>
>> wrote:
>>>
>>> Update the register 0x3503 to use 'no delay latch' for gain.
>>> This makes sensor to output the first frame as normal rather
>>> than a very dark one.
>>
>> I'm not 100% sure on how this setting works, but wouldn't it mean that
>> setting the gain mid-frame would result in half of the frame having
>> old gain and another half new? Depending how this works, perhaps we
>> should set this during initial register settings, but reset after
>> streaming starts?
>
> Thank you.
>
> I'm not quite sure too. Then I try to change gain during capture by:
>    capture_10_frames.sh & while sleep .01; do v4l2-ctl -d /dev/video4
> --set-ctrl=3Danalogue_gain=3D54; sleep .01; v4l2-ctl -d /dev/video4
> --set-ctrl=3Danalogue_gain=3D1024; done
>
> The gain setting takes effect for every single frame, not in mid-frame fr=
om
> my test.

Alright. I wasn't able to confirm the exact meaning of this bit myself
unfortunately, but if that's the behavior you're seeing, we should be
fine.

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
