Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41413 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbeDKQV6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 12:21:58 -0400
Subject: Re: a 4.16 kernel with Debian 9.4 "stretch" causes a log explosion
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Edgar Thier <info@edgarthier.net>
References: <alpine.DEB.2.20.1804110911021.18053@axis700.grange>
 <e79738af-8d6d-a6b1-2539-d2dbdb07bb53@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <b33d611d-99ea-b350-9351-f5b8986e3fe9@ideasonboard.com>
Date: Wed, 11 Apr 2018 17:21:54 +0100
MIME-Version: 1.0
In-Reply-To: <e79738af-8d6d-a6b1-2539-d2dbdb07bb53@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 11/04/18 17:17, Kieran Bingham wrote:
> Hi Guennadi,
> 
> On 11/04/18 10:56, Guennadi Liakhovetski wrote:
>> Hi Laurent,
>>
>> Not sure whether that's a kernel or a user-space problem, but UVC related 
>> anyway. I've got a UVC 1.5 (!) Logitech camera, that used to work fine 
>> with earlier kernels. I now installed "media 4.16" and saw, that the 
>> kernel log was filling with messages like
>>
>> uvcvideo: Failed to query (GET_MIN) UVC control 2 on unit 1: -32 (exp. 1).
>>
>> The expected /dev/video[01] nodes were not created correctly, and the 
>> hard-drive was getting full very quickly. The latter was happening because 
>> the the /var/log/uvcdynctrl-udev.log file was growing. A truncated sample 
>> is attached. At its bottom you see messages
>>
>> [libwebcam] Warning: The driver behind device video0 has a slightly buggy implementation
>>   of the V4L2_CTRL_FLAG_NEXT_CTRL flag. It does not return the next higher
>>   control ID if a control query fails. A workaround has been enabled.
>>
>> repeating, which continues even if the camera is unplugged. The kernel is 
>> the head of the master branch of git://linuxtv.org/media_tree.git
>>
>> Just figured out this commit
>>
>> From: Edgar Thier <info@edgarthier.net>
>> Date: Thu, 12 Oct 2017 03:54:17 -0400
>> Subject: [PATCH] media: uvcvideo: Apply flags from device to actual properties
>>
>> as the culprit. Without it everything is back to normal.
> 
> I've already investigated and fixed this:
> 
> Please apply:
> 	https://patchwork.kernel.org/patch/10299735/
> 
> You stated that this is showing up on a v4.16 kernel ... but as far as I'm aware
> - this feature shouldn't make it in until v4.17. Are you using linux-next or a
> media/master or such ?

Aha - never mind - I just re-read your message.

I expect the fix to make it into the media mainline when Mauro pulls from
Laurent? So I'm sure it will find its way soon.

--
Cheers

Kieran


> 
> Regards
> 
> Kieran
> 
>> Thanks
>> Guennadi
>>
