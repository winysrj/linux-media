Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60326 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbaAHS4g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 13:56:36 -0500
Received: by mail-wg0-f42.google.com with SMTP id l18so814500wgh.5
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 10:56:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABMudhTFmbv-PrNiGcW2yoGPiXuJ13fCmoqDFFBJfEjLk=gSgw@mail.gmail.com>
References: <CABMudhTFmbv-PrNiGcW2yoGPiXuJ13fCmoqDFFBJfEjLk=gSgw@mail.gmail.com>
Date: Wed, 8 Jan 2014 13:56:34 -0500
Message-ID: <CAGoCfizK7ZFgHTcLgaJRaP-Bvjriv7+fu+=yw+btMEC+GvoU7w@mail.gmail.com>
Subject: Re: How can I find out what is the driver for device node '/dev/video11'
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: m silverstri <michael.j.silverstri@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 8, 2014 at 1:50 PM, m silverstri
<michael.j.silverstri@gmail.com> wrote:
> In linux kernel, a device (e.g. codec) can register as a file (e.g.
> /dev/video11).
>
> How can I find out from the code which driver is registered as
> '/dev/video11'. i.e. what is the driver will be invoked when I
> open('/dev/video11', O_RDWR,0) in my user space code?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The QUERYCAP ioctl() will tell you the driver name.

http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
