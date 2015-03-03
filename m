Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:55228 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbCCIPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 03:15:43 -0500
Received: by mail-ob0-f181.google.com with SMTP id uz6so1362421obc.12
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2015 00:15:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALF0-+V4suAzkt_hvwmpN-P5wY-A_2SC8B4UN0GKmdu_+0bz6w@mail.gmail.com>
References: <CANFA8cWxD04myvRgqkopn=seRqxOSX6+Dd7sQU7r=Mbi0GZ0SA@mail.gmail.com>
	<CALF0-+V4suAzkt_hvwmpN-P5wY-A_2SC8B4UN0GKmdu_+0bz6w@mail.gmail.com>
Date: Tue, 3 Mar 2015 16:15:42 +0800
Message-ID: <CANFA8cU75J34cFJ1eZLxinBwLf+Hi9xbqS7_ys-=ok3zVgkMpg@mail.gmail.com>
Subject: Re: STK1160 driver connected to usb hub
From: Yin Ling <birdyin@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel Garcia,

Thanks for your interpretation and as you said, USB host controller
isochronous bandwidth's limitation influences the multiple channels
video transmission. We have tried our best to also use USB Hub to
support multiple channels video transmission, while the bandwidth
problem exist for USB Hub solution as well.
Therefore, we are trying wireless module for multiple camera system now.
Currently, it goes well.

Regards,
Ling Yin

On Mon, Feb 9, 2015 at 12:17 AM, Ezequiel Garcia
<ezequiel@vanguardiasur.com.ar> wrote:
> (Ccing the media ML)
>
> See my reply below.
>
> On Fri, Feb 6, 2015 at 4:36 AM, Yin Ling <birdyin@gmail.com> wrote:
>> Hi Ezequiel Garcia,
>>
>> Sorry for this bother. We are researcher at University and working on
>> STK1160 usb connection related solusion. As our system needs multiple
>> STK1160 to input video data, we plan to use usb Hub to connect
>> multiple STK1160. Nevertheless, currently only one STK1160 with driver
>> can be operated by one usb Hub host from the information below,
>> http://www.linuxtv.org/wiki/index.php/Stk1160_based_USB_2.0_video_and_audio_capture_devices#Known_issues
>> It wrote that "To one root hub port can connect only one device. Can
>> connect multiple, but at the same time only one operate. This not an
>> power supply issue, since the device consumes only 200mA in operation
>> mode. Number of devices that can simultaneously connect to PC depends
>> on the amount root hub ports."
>>
>> If try to operate multiple STK1160 by one usb Hub, is it possible?
>> Could you help to provide any hints or technological ways to achieve
>> this goal?
>>
>
> As far as I can recall, the only constraint is the USB host controller
> isochronous bandwidth.
> Given the stk1160 chip streams raw video, and given I have found no
> way to implement frame size in-chip reduction,
> your USB host must be able to deal with raw full frames. Roughly
> speaking you need as much as 20 MB/s for each stk1160 video input.
>
> Such throughput is more or less close, to USB2.0 maximum throughput.
>
> I hope someone can jump in and correct me if I'm wrong here.
>
>> Additionally, if this way is not feasible, we have to work on
>> capturing 4 channel video data from one STK1160 at the same time. We
>> have to switch channel to capture each specific channel video data. We
>> found that if we switch channel with the frequency as 1s, the quality
>> of images are not well. Do you know how we can capture 4 channel good
>> quality video data, lower switch frequency? How much it could be?
>>
>
> I think this is a hardware limitation. The stk1160 is not able to
> capture from the multiple channels
> simultaneously. I honestly don't recall how it performs when fast
> switching between channels, but I wouldn't expect much.
>
>> As we are very busy with the system, and are confusing with these
>> problems at this period, we are highly looking forward to receiving
>> your information. or else, if anyone may knows the solution, could you
>> help to provide to us as well?
>>
>
> Maybe you can get yourself a video capture device that can stream
> compressed video? That will certainly reduce the USB bandwidth
> requirement.
>
> Hope this helps!
> --
> Ezequiel García, VanguardiaSur
> www.vanguardiasur.com.ar
