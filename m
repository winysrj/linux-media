Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42573 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaAHTD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 14:03:58 -0500
Received: by mail-ob0-f179.google.com with SMTP id wm4so2155461obc.38
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 11:03:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfizK7ZFgHTcLgaJRaP-Bvjriv7+fu+=yw+btMEC+GvoU7w@mail.gmail.com>
References: <CABMudhTFmbv-PrNiGcW2yoGPiXuJ13fCmoqDFFBJfEjLk=gSgw@mail.gmail.com>
	<CAGoCfizK7ZFgHTcLgaJRaP-Bvjriv7+fu+=yw+btMEC+GvoU7w@mail.gmail.com>
Date: Wed, 8 Jan 2014 11:03:57 -0800
Message-ID: <CABMudhQ16ZhvFcwoTdHnU4B9cjVScV4Ohh81izoQDstWsV8X_A@mail.gmail.com>
Subject: Re: How can I find out what is the driver for device node '/dev/video11'
From: m silverstri <michael.j.silverstri@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks. I don't have the a running hardware.
If I can only search within the code space, how can I find out which
driver is for '/dev/video11'?

Is there a config file which I can look it up?

Thank you.

On Wed, Jan 8, 2014 at 10:56 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Wed, Jan 8, 2014 at 1:50 PM, m silverstri
> <michael.j.silverstri@gmail.com> wrote:
>> In linux kernel, a device (e.g. codec) can register as a file (e.g.
>> /dev/video11).
>>
>> How can I find out from the code which driver is registered as
>> '/dev/video11'. i.e. what is the driver will be invoked when I
>> open('/dev/video11', O_RDWR,0) in my user space code?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> The QUERYCAP ioctl() will tell you the driver name.
>
> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
