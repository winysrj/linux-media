Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43710 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbeADKZP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 05:25:15 -0500
Subject: Re: [RFC/RFT PATCH 0/6] Asynchronous UVC
To: Troy Kisky <troy.kisky@boundarydevices.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
 <b18d0633-cb04-639b-4ade-55b6839da0b3@boundarydevices.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <98e9fe58-b2d1-9a0c-df3a-e8e3ea7c25ca@ideasonboard.com>
Date: Thu, 4 Jan 2018 10:25:10 +0000
MIME-Version: 1.0
In-Reply-To: <b18d0633-cb04-639b-4ade-55b6839da0b3@boundarydevices.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Troy,

On 03/01/18 21:13, Troy Kisky wrote:
> On 1/3/2018 12:32 PM, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
>>
>> The Linux UVC driver has long provided adequate performance capabilities for
>> web-cams and low data rate video devices in Linux while resolutions were low.
>>
>> Modern USB cameras are now capable of high data rates thanks to USB3 with
>> 1080p, and even 4k capture resolutions supported.
>>
>> Cameras such as the Stereolabs ZED or the Logitech Brio can generate more data
>> than an embedded ARM core is able to process on a single core, resulting in
>> frame loss.
>>
>> A large part of this performance impact is from the requirement to
>> ‘memcpy’ frames out from URB packets to destination frames. This unfortunate
>> requirement is due to the UVC protocol allowing a variable length header, and
>> thus it is not possible to provide the target frame buffers directly.
> 
> I have a rather large patch that does provide frame buffers directly for bulk
> cameras. It cannot be used with ISOC cameras.  But it is currently for 4.1.
> I'll be porting it to 4.9 in a few days if you'd like to see it.

That does indeed sound interesting!

Having direct frame buffers for bulk would certainly be a benefit.
This series could then only be relevant to the ISOC cameras.

Let me know if there's anything I can do to help with porting to mainline, (as
opposed to 4.9) and feel free to send me patches to test and review.

If you're able to test these patches along side yours then that could also be
useful, although I suspect there may be a lot of cross-over - so it will likely
be more effort than just applying the patches :)

--
Regards

Kieran



> BR
> Troy
> 
> 
>>
>> Extra throughput is possible by moving the actual memcpy actions to a work
>> queue, and moving the memcpy out of interrupt context and allowing work tasks
>> to be scheduled across multiple cores.
>>
>> This series has been tested on both the ZED and Brio cameras on arm64
>> platforms, however due to the intrinsic changes in the driver I would like to
>> see it tested with other devices and other platforms, so I'd appreciate if
>> anyone can test this on a range of USB cameras.
>>
>> Kieran Bingham (6):
>>   uvcvideo: Refactor URB descriptors
>>   uvcvideo: Convert decode functions to use new context structure
>>   uvcvideo: Protect queue internals with helper
>>   uvcvideo: queue: Simplify spin-lock usage
>>   uvcvideo: queue: Support asynchronous buffer handling
>>   uvcvideo: Move decode processing to process context
>>
>>  drivers/media/usb/uvc/uvc_isight.c |   4 +-
>>  drivers/media/usb/uvc/uvc_queue.c  | 115 ++++++++++++++----
>>  drivers/media/usb/uvc/uvc_video.c  | 191 ++++++++++++++++++++++--------
>>  drivers/media/usb/uvc/uvcvideo.h   |  56 +++++++--
>>  4 files changed, 289 insertions(+), 77 deletions(-)
>>
>> base-commit: 6f0e5fd39143a59c22d60e7befc4f33f22aeed2f
>>
> 
