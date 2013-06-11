Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40296 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3FKKDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 06:03:42 -0400
Received: by mail-ie0-f177.google.com with SMTP id aq17so1499905iec.8
        for <linux-media@vger.kernel.org>; Tue, 11 Jun 2013 03:03:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPueXH4+MyXszcfwSMB2rS+WdrJ5z0=98puS1WwyEQzb_E87bQ@mail.gmail.com>
References: <1370938465.85106.YahooMailNeo@web125204.mail.ne1.yahoo.com> <CAPueXH4+MyXszcfwSMB2rS+WdrJ5z0=98puS1WwyEQzb_E87bQ@mail.gmail.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Tue, 11 Jun 2013 11:03:22 +0100
Message-ID: <CAPueXH4es+ddf+EW3_NXTV3Q63TqW_WYd2RjUT+e-7xDi4Wp6g@mail.gmail.com>
Subject: Fwd:
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the list (again)

---------- Forwarded message ----------
From: Paulo Assis <pj.assis@gmail.com>
Date: 2013/6/11
Subject: Re:
To: phil rosenberg <philip_rosenberg@yahoo.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>


Hi,
make sure you are streaming in YUYV format and not in MJPG or any of
the libv4l formats since these are decoded from MJPG.

If you are using guvcview for the stream preview you should also set
the bayer pattern accordindly since it will depend on whathever
resolution you are using.

Regards,
Paulo


2013/6/11 phil rosenberg <philip_rosenberg@yahoo.com>
>
> Hi this is my first email to the list, I'm hoping someone can help
> I have a logitech C300 webcam with the option of raw/bayer output. This works fine on windows where the RGB output consists of zeros in the r and b bytes and pixel intensitey in the g byte. However on linux when I activate the webcam using uvcdynctrl and/or the options in guvcview the out put seems to be corrupted. I get something that looks like multiple images interlaces and displaced horizontally, generally pink. I've put an example of an extracted avi frame at http://homepages.see.leeds.ac.uk/~earpros/test0.png, which is a close up of one of my daughters hair clips and shows an (upside down) picture of a disney character.
> I'm wondering if the UVC/V4L2 driver is interpretting the data as mjpeg and incorrectly decoding it giving the corruption. When I use guvcview I can choose the input format, but the only one that works in mjpeg, all others cause timeouts and no data. The image also has the tell-tale 8x8 jpeg block effect. Is there any way I can stop this decoding happening and get to the raw data? Presumably if my theory is correct then the decompression is lossy so cannot be undone.
> Any help or suggestions welcome.
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
