Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46806 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZINPZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 11:25:45 -0400
Received: by fxm17 with SMTP id 17so916345fxm.37
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 08:25:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL124-W6F59C0DE926F2BC8DA4C288E40@phx.gbl>
References: <COL124-W6F59C0DE926F2BC8DA4C288E40@phx.gbl>
Date: Mon, 14 Sep 2009 11:25:47 -0400
Message-ID: <30353c3d0909140825h266e9988td3dffc88612e182c@mail.gmail.com>
Subject: Re: I can't get all pixels values from my driver. plz help ;0(
From: David Ellingsworth <david@identd.dyndns.org>
To: Guilherme Longo <incorpnet1@hotmail.com>
Cc: video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guilherme,

In the future, please post to the new mailing list:
linux-media@vger.kernel.org That said, your camera won't output a
video format that it does not support. In other words, despite you
specifically asking for a 160x120 pixel RGB image, you may infact get
something else. The formats your camera supports may be obtained by
using VIDIOC_ENUM_FMT. Once you've selected a format you should then
use VIDIOC_ENUM_FRAMESIZES to determine the size of the frames
supported by that format.

To simplify things a little, you might want to consider using libv4l
since will automatically convert the native format supported by your
camera to the one required by your application.

Regards,

David Ellingsworth

On Mon, Sep 14, 2009 at 1:50 AM, Guilherme Longo <incorpnet1@hotmail.com> wrote:
>
> Hi all.
>
> After 3 weeks trying to solve my problem, I am about to give up and find another solution instead of trying to fix this one.
> I have changed few things in the capture.c example available for download at http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/ and
> the altered code can be seen here: http://pastebin.com/m7ef25480
>
> So... what is the problem?
>
> Well, I have set the following configuration for capture:
>
>        fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>        fmt.fmt.pix.width       = 160;
>        fmt.fmt.pix.height      = 120;
>        fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB32;
>        fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;
>
> All the process is implemented in a function called process_image(void * p) where p is a void pointer to the buffer where the frames captures should be stored.
>
> this is the function that reads the buffer:
>
> if (-1 == read (fd, buffers[0].start, buffers[0].length))   (length = 160x120 -> 19200)
>
> then after, I call the process_image function:
> process_image (buffers[0].start);
>
> What I need is read the buffer separation the R, G, B, A storing them in unsigned char variables.
>
> It should have 19.200 pixel (160x120) but instead, look what i have got:
>
> [0]87 [0]110 [0]68 [0]134
> [1]202 [1]73 [1]119 [1]109
> [2]213 [2]36 [2]73 [2]33
> .....
> .....
> [1287]73 [1287]100 [1287]150 [1287]133
> [1288]69 [1288]133 [1288]4 [1288]0
> [1289]0 [1289]0 [1289]0 [1289]0
> [1290]0 [1290]0 [1290]0 [1290]0
> [1291]0 [1291]0 [1291]0 [1291]0
> .....
> [4799]0 [4799]0 [4799]0 [4799]0
> [0]80 [0]105 [0]145 [0]4
> [1]146 [1]18 [1]108 [1]182
> [2]68 [2]136 [2]137 [2]170
>
> As you can see, I get only 1289 pixels with values and all the rest are 0;
> When the function is called again, the same happens over and over.
>
> So... why am I getting only 1289 pixel with values when in fact it should be 160x120 pixel corresponding to 1 frame?
> I am begging help 'cause my arsenal's over.. I am really out of ideas!
>
> Thanks a lot!
>
>
>
> _________________________________________________________________
> Drag n’ drop—Get easy photo sharing with Windows Live™ Photos.
>
> http://www.microsoft.com/windows/windowslive/products/photos.aspx--
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subjectunsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
