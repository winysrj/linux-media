Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54541 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3G3Pqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 11:46:32 -0400
Received: by mail-ob0-f182.google.com with SMTP id wo10so12573708obc.13
        for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 08:46:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201307301729.26053.hverkuil@xs4all.nl>
References: <CAPybu_1kw0CjtJxt-ivMheJSeSEi95ppBbDcG1yXOLLRaR4tRg@mail.gmail.com>
 <201307301545.51529.hverkuil@xs4all.nl> <CAPybu_13HCY1i=tH1krdKGOSbJNgek-X4gt1cGmo_oB=AqTxKg@mail.gmail.com>
 <201307301729.26053.hverkuil@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 30 Jul 2013 17:46:11 +0200
Message-ID: <CAPybu_2TivP9Pui2O5N8QofT-07tdxYMnOsC2Nvo7Ods0PuX7w@mail.gmail.com>
Subject: Re: Question about v4l2-compliance: cap->readbuffers
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I have a camera that works on two modes: Mono and colour. On color
mode it has 3 gains, on mono mode it has 1 gain.

When the user sets the output to mono I disable the color controls
(and the other way around).

Also on color mode the hflip and vflip do not work, therefore I dont show them.

I could return -EINVAL, but I rather not show the controls to the user.

What would be the proper way to do this?


Thanks gain.





On Tue, Jul 30, 2013 at 5:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue 30 July 2013 17:18:58 Ricardo Ribalda Delgado wrote:
>> Thanks for the explanation Hans!
>>
>> I finaly manage to pass that one ;)
>>
>> Just one more question. Why the compliance test checks if the DISABLED
>> flag is on on for qctrls?
>>
>> http://git.linuxtv.org/v4l-utils.git/blob/3ae390e54a0ba627c9e74953081560192b996df4:/utils/v4l2-compliance/v4l2-test-controls.cpp#l137
>>
>>  137         if (fl & V4L2_CTRL_FLAG_DISABLED)
>>  138                 return fail("DISABLED flag set\n");
>>
>> Apparently that has been added on:
>> http://git.linuxtv.org/v4l-utils.git/commit/0a4d4accea7266d7b5f54dea7ddf46cce8421fbb
>>
>> But I have failed to find a reason
>
> It shouldn't be used anymore in drivers. With the control framework there is
> no longer any reason to use the DISABLED flag.
>
> If something has a valid use case for it, then I'd like to know what it is.
>
> Regards,
>
>         Hans



-- 
Ricardo Ribalda
