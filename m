Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37815 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab0LSPcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 10:32:23 -0500
Received: by iwn9 with SMTP id 9so2375586iwn.19
        for <linux-media@vger.kernel.org>; Sun, 19 Dec 2010 07:32:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012181550500.22984@banach.math.auburn.edu>
References: <alpine.LNX.2.00.1012181550500.22984@banach.math.auburn.edu>
From: Paulo Assis <pj.assis@gmail.com>
Date: Sun, 19 Dec 2010 15:32:02 +0000
Message-ID: <AANLkTinGnhmEg3zbkhmUGH_+bsqdDmkp24_-Of9e3XN1@mail.gmail.com>
Subject: Re: Power frequency detection.
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

2010/12/18 Theodore Kilgore <kilgota@banach.math.auburn.edu>:
>
> Does anyone know whether, somewhere in the kernel, there exists a scheme
> for detecting whether the external power supply of the computer is using
> 50hz or 60hz?
>
> The reason I ask:
>
> A certain camera is marketed with Windows software which requests the user
> to set up the option of 50hz or 60hz power during the setup.
>
> Judging by what exists in videodev2.h, for example, it is evidently
> possible to set up this as a control setting in a Linux driver. I am not
> aware of any streaming app which knows how to access such an option.
>

Most uvc cameras present this as a control, so any v4l2 control app
should let you access it.
If your camera driver also supports this control then this shouldn't
be a problem for any generci v4l2 app.
here are a couple of ones:

v4l2ucp (control panel)
guvcview ("guvcview --control_only" will work along side other apps
just like v4l2ucp)
uvcdynctrl from libwebcam for command line control utility .

Regards,
Paulo

> Information about which streaming app ought to be used which could take
> advantage of a setting for line frequency would be welcome, too, of
> course. As I said, I do not know of a single one and would therefore have
> trouble with testing any such control setting unless I could find the
> software which can actually present the choice to the user.
>
> But my main question is whether the kernel already does detect the line
> frequency anywhere else, for whatever reason. For, it occurs to me that a
> far more elegant solution -- if the camera really does need to have the
> line frequency detected -- would be do do the job automatically and not to
> bother the user about such a thing.
>
> In other news, in case anyone has any children who are in love with Lego,
> the "Lego Bionicle" camera which is currently on sale has an SQ905C type
> chip in it. I just added its Product number to the Gphoto driver last
> night. And it works perfectly in webcam mode if one adds its product
> number in gspca/sq905c.c. I will get around to doing that formally, of
> course, when I get time. But if anyone wants just to add the number and
> re-compile the Vendor:Product number for the new camera is 0x2770:0x9051.
>
> Merry Christmas.
>
> Theodore Kilgore
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
