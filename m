Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60102 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1E0JIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 05:08:40 -0400
Received: by eyx24 with SMTP id 24so577541eyx.19
        for <linux-media@vger.kernel.org>; Fri, 27 May 2011 02:08:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105251143.52302.laurent.pinchart@ideasonboard.com>
References: <1306247443-2191-1-git-send-email-javier.martin@vista-silicon.com>
	<201105251005.28691.laurent.pinchart@ideasonboard.com>
	<BANLkTikvLEG55vqpLmNJJsvsvz1eLsGoHw@mail.gmail.com>
	<201105251143.52302.laurent.pinchart@ideasonboard.com>
Date: Fri, 27 May 2011 11:08:39 +0200
Message-ID: <BANLkTi=O91DiPM3uMP=OqOs4XpPzUAmhJA@mail.gmail.com>
Subject: Re: [PATCH][RFC] Add mt9p031 sensor support.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 25 May 2011 11:43, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> On Wednesday 25 May 2011 11:41:42 javier Martin wrote:
>> Hi,
>> thank you for the review, I agree with you on all the suggested
>> changes except on this one:
>>
>> On 25 May 2011 10:05, Laurent Pinchart wrote:
>> > On Tuesday 24 May 2011 16:30:43 Javier Martin wrote:
>> >> This RFC includes a power management implementation that causes
>> >> the sensor to show images with horizontal artifacts (usually
>> >> monochrome lines that appear on the image randomly).
>> >>
>> >> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> >
>> > [snip]
>> >
>> >> diff --git a/drivers/media/video/mt9p031.c
>> >> b/drivers/media/video/mt9p031.c new file mode 100644
>> >> index 0000000..04d8812
>> >> --- /dev/null
>> >> +++ b/drivers/media/video/mt9p031.c
>> >
>> > [snip]
>> >
>> >> +#define MT9P031_WINDOW_HEIGHT_MAX            1944
>> >> +#define MT9P031_WINDOW_WIDTH_MAX             2592
>> >> +#define MT9P031_WINDOW_HEIGHT_MIN            2
>> >> +#define MT9P031_WINDOW_WIDTH_MIN             18
>> >
>> > Can you move those 4 constants right below MT9P031_WINDOW_HEIGHT and
>> > MT9P031_WINDOW_WIDTH ? The max values are not correct, according to the
>> > datasheet they should be 2005 and 2751.
>>
>> In figure 4, it says active image size is 2592 x 1944
>> Why should I include active boundary and dark pixels?
>
> Users might want to get the dark pixels for black level compensation purpose.
> As the chip allows for that, it should be supported. The default should of
> course be the active area of 2592 x 1944 pixels.
>

OK, that sounds reasonable. However, that would include black pixels
that are located at the beginning of the array (0,0) to (16, 54),
which means that users would have to specify a crop value of (15,54)
to eliminate those initial black level pixels. Which seems quite
unnatural to me.
Another option could be setting (16,54) as default values and allowing
to introduce negative cropping values. Is this possible?
And finally, the most sensible idea IMHO could be not letting the user
to see pixels from (0,0) to (15,54) (setting 15,54 as minimum and
default )and, for black level compensation, ending pixels could be
used (2608,1998) to (2751, 2003).

What do you think?


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
