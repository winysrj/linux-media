Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0AKIhw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 03:37:52 -0500
Message-ID: <4B4AE349.4000707@redhat.com>
Date: Mon, 11 Jan 2010 09:37:29 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Subject: Re: Problem with gspca and zc3xx
References: <201001090015.31357.jareguero@telefonica.net> <20100110093730.14be3d7c@tele>
In-Reply-To: <20100110093730.14be3d7c@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/10/2010 09:37 AM, Jean-Francois Moine wrote:
> On Sat, 9 Jan 2010 00:15:31 +0100
> Jose Alberto Reguero<jareguero@telefonica.net>  wrote:
>
>> When capturing with mplayer I have this erros and the bottom of the
>> image is black.
>>
>> [mjpeg @ 0xd2f300]error y=29 x=0
>> [mjpeg @ 0xd2f300]mjpeg_decode_dc: bad vlc: 0:0 (0x2c565b0)
> 	[snip]
>>
>> gspca: main v2.8.0 registered
>> gspca: probing 046d:08dd
>> zc3xx: Sensor MC501CB
>> gspca: video0 created
>> gspca: probing 046d:08dd
>> gspca: intf != 0
>> gspca: probing 046d:08dd
>> gspca: intf != 0
>> usbcore: registered new interface driver zc3xx
>> zc3xx: registered
>
> Hello Jose Alberto,
>
> May you send me a raw image done by my program svv? (look in my web page
> below - run it by 'svv -rg' and send me the generated image.dat)
>

JF,

This is the infamous zc3xx bottom of the image is missing in 320x240 problem,
with several sensors the register settings we took from the windows driver
will only give you 320x232 (iirc), we tried changing them to get 320x240,
but then the camera would not stream. Most likely some timing issue between
bridge and sensor.

I once had a patch fixing this by actually reporting the broken modes as
320x232, but that never got applied as it breaks app which are hardcoded
to ask for 320x240. libv4l has had the ability to extend the 320x232 image
to 320x240 for a while now (by adding a few black lines at the top + bottom),
fixing the hardcoded apps problem.

So I think such a patch can and should be applied now. This will get rid
of the jpeg decompression errors reported by libv4l and in case if yuv mode
the ugly green bar with some random noise in it at the bottom.

I'm afraid my patch is most likely lost, but I can create a new one if you want,
I have access to quite a few zc3xx camera's, and more over what resolution
they are actually streaming at can be deducted from the register settings
in the driver.

Regards,

Hans
