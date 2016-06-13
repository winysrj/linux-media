Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55324 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbcFMTKk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 15:10:40 -0400
Subject: Re: LinuxTv doesn't build anymore after upgrading Ubuntu to 3.13.0-88
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <575EE9D9.3030502@gmx.net> <575EF39A.4010609@xs4all.nl>
 <575F00DA.2020009@gmx.net> <575F02F4.2000501@xs4all.nl>
From: Andreas Matthies <a.matthies@gmx.net>
Message-ID: <575F052A.5080502@gmx.net>
Date: Mon, 13 Jun 2016 21:10:34 +0200
MIME-Version: 1.0
In-Reply-To: <575F02F4.2000501@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 13.06.2016 um 21:01 schrieb Hans Verkuil:
> On 06/13/2016 08:52 PM, Andreas Matthies wrote:
>> But now I get
>> ...
>>     CC [M]  /home/andreas/Downloads/media_build/v4l/uvc_v4l2.o
>>     CC [M]  /home/andreas/Downloads/media_build/v4l/uvc_video.o
>> /home/andreas/Downloads/media_build/v4l/uvc_video.c: In function
>> 'uvc_endpoint_max_bpi':
>> /home/andreas/Downloads/media_build/v4l/uvc_video.c:1473:7: error:
>> 'USB_SPEED_SUPER_PLUS' undeclared (first use in this function)
>>     case USB_SPEED_SUPER_PLUS:
>>          ^
> When building for 4.6? I know this fails for older kernels but it should be fine
> for the 4.6 kernel.
>
> I'll make a patch fixing this some time this week though.
>
No, I'm running and (hopefully) building for 3.11:
andreas@andreas-xubuntu:~$ uname -a
Linux andreas-xubuntu 3.13.0-88-generic #135-Ubuntu SMP Wed Jun 8 
21:10:42 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

I have worked around that bug just by deleting the line using 
USB_SPEED_SUPER_PLUS for now but a clean patch for that would be better.

. Andreas


