Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36833 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbbLJVq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 16:46:29 -0500
Received: by iofh3 with SMTP id h3so107611772iof.3
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2015 13:46:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449361427.31991.17.camel@collabora.com>
References: <CAJ2oMhKbYfqz1Vy5-ERPTZAkNZt=9+rzr6yNduQiyfAWM_Zfug@mail.gmail.com>
	<1449361427.31991.17.camel@collabora.com>
Date: Thu, 10 Dec 2015 23:46:28 +0200
Message-ID: <CAJ2oMh+MG20jYdNSfXWZN+0vH2BPi_Z+v4OB-VH5ehi7qmfmpw@mail.gmail.com>
Subject: Re: v4l2 kernel module debugging methods
From: Ran Shalit <ranshalit@gmail.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 6, 2015 at 2:23 AM, Nicolas Dufresne
<nicolas.dufresne@collabora.com> wrote:
> Le dimanche 06 décembre 2015 à 00:00 +0200, Ran Shalit a écrit :
>> Hello,
>>
>> I would like to ask a general question regarding methods to debug a
>> v4l2 device driver.
>> Since I assume that the kernel driver will probably won't work in
>> first try after coding everything inside the device driver...
>>
>> 1. Do you think qemu/kgdb debugger is a good method for the device
>> driver debugging , or is it plain printing ?
>>
>> 2. Is there a simple way to display the image of a YUV-like buffer in
>> memory ?
>
> Most Linux distribution ships GStreamer. You can with GStreamer read
> and display a raw YUV images (you need to know the specific format)
> using videoparse element.
>
>   gst-launch-1.0 filesrc location=my.yuv ! videoparse format=yuy2 width=320 height=240 ! imagefreeze ! videoconvert ! autovideosink
>
> You could also encode and store to various formats, replacing the
> imagefreeze ... section with an encoder and a filesink. Note that
> videoparse unfortunatly does not allow passing strides array or
> offsets. So it will work only if you set the width/height to padded
> width/height.
>
> regards,
> Nicolas

Hi Nicolas,

Thank you for the comment.
As someone expreinced with v4l2 device driver, do you recommened using
debugging technique such as qemu (or kgdb) or do you rather use plain
printing ?

Thank you very much,
Ran
