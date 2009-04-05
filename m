Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:45550 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZDESxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 14:53:24 -0400
Received: by fg-out-1718.google.com with SMTP id 16so149092fgg.17
        for <linux-media@vger.kernel.org>; Sun, 05 Apr 2009 11:53:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090405195219.08e63cea@free.fr>
References: <49D7C17B.80708@gmail.com> <20090405195219.08e63cea@free.fr>
Date: Sun, 5 Apr 2009 20:53:21 +0200
Message-ID: <62e5edd40904051153h2ae9fd71t41aa239d5ebc650a@mail.gmail.com>
Subject: Re: libv4l: Possibility of changing the current pixelformat on the
	fly
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/4/5 Jean-Francois Moine <moinejf@free.fr>:
> On Sat, 04 Apr 2009 22:22:19 +0200
> Erik Andrén <erik.andren@gmail.com> wrote:
>        [snip]
>> When flipping the image horizontally, vertically or both, the sensor
>> pixel ordering changes. In the m5602 driver I was able to compensate
>> for this in the bridge code. In the stv06xx I don't have this
>> option. One way of solving this problem is by changing the
>> pixelformat on the fly, i. e V4L2_PIX_FMT_SGRB8 is the normal
>> format. When a vertical flip is required, change the format to
>> V4L2_SBGGR8.
>>
>> My current understanding of libv4l is that it probes the pixelformat
>>   upon device open. In order for this to work we would need either
>> poll the current pixelformat regularly or implement some kind of
>> notification mechanism upon a flipping request.
>>
>> What do you think is this the right way to go or is there another
>> alternative.
>
> Hi Erik,
>
> I saw such a problem in some other webcams. When doing a flip, the
> sensor scans the pixels in the reverse order. So,
>        R G R G
>        G B G B
> becomes
>        B G B G
>        G R G R
>
> The solution is to start the scan one line lower or higher for VFLIP
> and one pixel on the left or on the right for HFLIP.
>

As I wrote in my original email I haven't found out a way to adjust
this when using the vv6410 sensor.

> May you do this with all the sensors of the stv06xx?

This issue is vv6410 specific.

Best regards,
Erik Andrén

>
> Cheers.
>
> --
> Ken ar c'hentan |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>
