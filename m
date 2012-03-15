Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43677 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab2COOao (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 10:30:44 -0400
Received: by eaaq12 with SMTP id q12so1574169eaa.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 07:30:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <006d01cd02ae$457fc960$d07f5c20$%debski@samsung.com>
References: <CACKLOr3T-w1JdaGgnL+ZEXFX4v_oVd0HY8mqrm5ZzxEziH32jw@mail.gmail.com>
	<20120315110336.GH4220@valkosipuli.localdomain>
	<006d01cd02ae$457fc960$d07f5c20$%debski@samsung.com>
Date: Thu, 15 Mar 2012 15:30:42 +0100
Message-ID: <CACKLOr1igHtcfMBHTdncSzHiBixt03WDJ-QSNvUn3sRe171e+A@mail.gmail.com>
Subject: Re: [Q] media: V4L2 compressed frames and s_fmt.
From: javier Martin <javier.martin@vista-silicon.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil, Sakari,
thank you for your replies.

On 15 March 2012 14:19, Kamil Debski <k.debski@samsung.com> wrote:
> Hi Javier, Sakari,
>
>> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
>> Sent: 15 March 2012 12:04
>>
>> Hi Javier,
>>
>> (Cc Kamil.)
>>
>> On Wed, Mar 14, 2012 at 12:22:43PM +0100, javier Martin wrote:
>> > Hi,
>> > I'm developing a V4L2 mem2mem driver for the codadx6 IP video codec
>> > which is included in the i.MX27 chip.
>> >
>> > The capture interface of this driver can therefore return h.264 or
>> > mpeg4 video frames.
>> >
>> > Provided that the size of each frame varies and is unknown to the
>> > user, how is the driver supposed to react to a S_FMT when it comes to
>> > parameters such as the following?
>> >
>> > pix->width
>> > pix->height
>> > pix->bytesperline
>> > pix->sizeimage
>> >
>> > According to the documentation [1] I understand that the driver can
>> > just ignore 'bytesperline' and should return in 'sizeimage' the
>> > maximum buffer size to store a compressed frame. However, it does not
>> > mention anything special about width and height. Does it make sense
>> > setting width and height for h.264/mpeg4 formats?
>>
>
> Yes, in case of the compressed side (capture) the width, height and
> bytesperline
> is ignored. The MFC driver sets bytesperline to 0 and leaves width and height
> intact
> during S_FMT. I suggest you do the same or set all of them (width, height,
> bytesperline)
> to 0.

I'm not sure about that, according to the code in here [1] it ignores
width and height, as you stated, but it fills bytesperline with the
value in imagesize. This applies to TRY_FMT and S_FMT.
On the other hand, in G_FMT [2], it sets width and height to 0, but
bytesperline and sizeimage are set to ctx->enc_dst_buf_size, which I
deduce it's the encoder buffer size.

If this is the agreed way of doing things I can just implement this
behavior in my driver as well.

Regards.

[1] http://lxr.linux.no/#linux+v3.2.11/drivers/media/video/s5p-mfc/s5p_mfc_enc.c#L880
[2] http://lxr.linux.no/#linux+v3.2.11/drivers/media/video/s5p-mfc/s5p_mfc_enc.c#L844
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
