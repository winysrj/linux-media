Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm24.bullet.mail.ne1.yahoo.com ([98.138.90.87]:42169 "EHLO
	nm24.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756396Ab3FKWVa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 18:21:30 -0400
References: <1370938465.85106.YahooMailNeo@web125204.mail.ne1.yahoo.com>
 <CAPueXH4+MyXszcfwSMB2rS+WdrJ5z0=98puS1WwyEQzb_E87bQ@mail.gmail.com> <1370945293.8544.YahooMailNeo@web125205.mail.ne1.yahoo.com> <CAPueXH4xBtVtUmpq1HkwG-3O7bC4dr6-LEenWf9_HvB8arzvow@mail.gmail.com>
Message-ID: <1370988950.32187.YahooMailNeo@web125203.mail.ne1.yahoo.com>
Date: Tue, 11 Jun 2013 15:15:50 -0700 (PDT)
From: phil rosenberg <philip_rosenberg@yahoo.com>
Reply-To: phil rosenberg <philip_rosenberg@yahoo.com>
Subject: Re: Corrupt Raw webcam data
To: Paulo Assis <pj.assis@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <CAPueXH4xBtVtUmpq1HkwG-3O7bC4dr6-LEenWf9_HvB8arzvow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paulo
Unfortunately I tried setting things up in the order you suggested, but as soon as I select 'Disable video processing I get only a single frame of something that looks a bit like a bayer grid, coloured deep blue. I think the image might be in this data but shifted horizontally and then an error "Could not grab image (select timeout): Resource temporariliy unavailable which is repeated until I unselect 'Disable video processing' and change to any other input type.
 
I've tested this on Ubuntu 12.04 and Raspian Wheezy with the same results.
 
If you have any other ideas I'd be happy to hear them
 
All the best
 
Phil


----- Original Message -----
From: Paulo Assis <pj.assis@gmail.com>
To: phil rosenberg <philip_rosenberg@yahoo.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Sent: Tuesday, 11 June 2013, 11:13
Subject: Re: Corrupt Raw webcam data

Hi,
You should select YUYV before disabling the video processing.

So with video processing still enabled:

set YUYV format
set the desired fps and resolution
set exposure

now disable video processing and set the bayer order

every time you need to change exposure or resolution you need to
enable video processing first.

Regards,
Paulo

2013/6/11 phil rosenberg <philip_rosenberg@yahoo.com>:
> Hello Paulo
> Thank you for your quick response.
> Unfortunately if I select YUYV or any other format that is not MJPG data flow stops and I see timeouts appear in the console.
>
> Does this represent a bug in either the webcam's UVC support or the UVC driver? If so I presume there is no likely quick workaround.
>
> Phil
>
> ________________________________
> From: Paulo Assis <pj.assis@gmail.com>
> To: phil rosenberg <philip_rosenberg@yahoo.com>
> Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
> Sent: Tuesday, 11 June 2013, 10:11
> Subject: Re:
>
>
>
> Hi,
> make sure you are streaming in YUYV format and not in MJPG or any of the libv4l formats since these are decoded from MJPG.
>
> If you are using guvcview for the stream preview you should also set the bayer pattern accordindly since it will depend on whathever resolution you are using.
>
> Regards,
> Paulo
>
>
>
>
> 2013/6/11 phil rosenberg <philip_rosenberg@yahoo.com>
>
> Hi this is my first email to the list, I'm hoping someone can help
>>I have a logitech C300 webcam with the option of raw/bayer output. This works fine on windows where the RGB output consists of zeros in the r and b bytes and pixel intensitey in the g byte. However on linux when I activate the webcam using uvcdynctrl and/or the options in guvcview the out put seems to be corrupted. I get something that looks like multiple images interlaces and displaced horizontally, generally pink. I've put an example of an extracted avi frame at http://homepages.see.leeds.ac.uk/~earpros/test0.png,which is a close up of one of my daughters hair clips and shows an (upside down) picture of a disney character.
>>I'm wondering if the UVC/V4L2 driver is interpretting the data as mjpeg and incorrectly decoding it giving the corruption. When I use guvcview I can choose the input format, but the only one that works in mjpeg, all others cause timeouts and no data. The image also has the tell-tale 8x8 jpeg block effect. Is there any way I can stop this decoding happening and get to the raw data? Presumably if my theory is correct then the decompression is lossy so cannot be undone.
>>Any help or suggestions welcome.
>>
>>Phil
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
