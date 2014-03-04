Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:36025 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbaCDQPc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Mar 2014 11:15:32 -0500
Message-ID: <5315FC4E.10508@linux.intel.com>
Date: Tue, 04 Mar 2014 17:16:14 +0100
From: Mark Ryan <mark.d.ryan@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Ryan, Mark D" <mark.d.ryan@intel.com>,
	"Sharp, Sarah A" <sarah.a.sharp@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Dell XPS 12 USB camera bulk mode issues
References: <20140225214956.GC4035@xanatos> <4186365.nC1W9O3BqU@avalon> <53105820.9070007@linux.intel.com> <10724598.APfayxWd2e@avalon>
In-Reply-To: <10724598.APfayxWd2e@avalon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks again for your reply.

On 03/04/2014 12:11 PM, Laurent Pinchart wrote:
> Hi Mark,
>
> On Friday 28 February 2014 10:34:24 Mark Ryan wrote:
>> On 02/26/2014 04:40 PM, Laurent Pinchart wrote:
>>
>> [ ... ]
>>
>>> With the information I've given you, could you try to log more information
>>> in the driver to try and find what goes wrong ? You could for instance
>>> log the content of each header at the beginning of the
>>> uvc_video_decode_start() function.
>>
>> So maybe I have something here.  I ran guvcview and set the format to
>> MJPEG running at a high resolution.  I'm using the kernel 3.11.0-17 that
>> comes with Ubuntu 13.10.  In the usbmon logs I see the following.
>>
>> [...]
>>
>>
>> SETUP Host-to-device Class request to Interface
>> bRequest: SET CUR (01)
>> wValue: 0200
>> wIndex: INTF 1 ENTITY 0 (0001)
>> wLength: 001a
>>
>> 26 data bytes
>>
>> bmHint                         0x01
>> bFormatIndex                      2
>> bFrameIndex                      10
>> dwFrameInterval              333333
>> wKeyFrameRate                     0
>> wPFrameRate                       0
>> wCompQuality                      0
>> wCompWindowSize                   0
>> wDelay                           32
>> dwMaxVideoFrameSize         1843200
>> dwMaxPayloadTransferSize      34816
>>
>> Note the dwMaxPayloadTransferSize of 34816
>>
>> [...]
>>
>> Now I have my first payload
>>
>> 16384 data bytes
>>
>> 0c8d863e 8c007d67    .†>Œ.}g
>> 8e00b304 ffd8ffdb    Ž.³.ÿØÿÛ
>> 00430003 02020202    .C......
>> 02030202 02030303    ........
>>
>> 16384 data bytes
>>
>> fbf5aeff 00c25e12    ûõ®ÿ.Â^.
>> 5d1244d5 353b2437    ].DÕ5;$7
>> f92d06e6 24c28475    ù-.æ$Â„u
>> c740c6b3 8bbb29ad    Ç@Æ³‹»)­
>>
>> 16384 data bytes
>>
>> f1a3cc60 b8200c52    ñ£Ì`¸ .R
>> 0108eac3 1cd4610e    ..êÃ.Ôa.
>> ece45032 40c477a8    ìäP2@Äw¨
>> e4f35b81 d05001fc    äó[ÐP.ü
>>
>> 16384 data bytes
>>
>> fb3528d1 bc4fcc56    û5(Ñ¼OÌV
>> fe2d9522 1d04b1e7    þ-•"..±ç
>> 3fa1a9e5 2b9867f6    ?¡©å+˜gö
>> 778e2dd0 7d9b57b5    wŽ-Ð}›Wµ
>>
>> 16384 data bytes
>>
>> c016baf6 99732c9a    À.ºö™s,š
>> 9db39b7b e6b995a4    ³›{æ¹•¤
>> 65751f78 649eb5ed    eu.xdžµí
>> 9e2dfdb1 355fd9fa    ž-ý±5_Ùú
>>
>> 16384 data bytes
>>
>> a73d4053 8fad795c    §=@S­y\
>> c9088170 ec1c1e54    É.pì..T
>> 9ce6a59a d89f5742    œæ¥šØŸWB
>> 82cf3297 26d95b18    ‚Ï2—&Ù[.
>>
>> 16384 data bytes
>>
>> b4d3b21b d4a53595    ´Ó².Ô¥5•
>> 99cac904 2e1bb346    ™ÊÉ...³F
>> 09fe555e 4d2b4b95    .þU^M+K•
>> be6b488a 0e91b0ca    ¾kHŠ.‘°Ê
>>
>> 16384 data bytes
>>
>> 3adb9dbc 6323ad21    :Û¼c#­!
>> 8aa85b9d b934d31e    Š¨[¹4Ó.
>> 465885f6 a00ad25c    FX…ö .Ò\
>> 04fdd44b be43d08a    .ýÔK¾CÐŠ
>>
>> 16384 data bytes
>>
>> 14f1cf4c 0ae43589    .ñÏL.ä5‰
>> 0acdbd0b c8afedc2    .Í½.È¯íÂ
>> f15d4339 8bfb5b2b    ñ]C9‹û[+
>> df39e42d 14ecb849    ß9ä-.ì¸I
>>
>> 10466 data bytes
>>
>> 7fffd1fc af99e466    ÿÑü¯™äf
>> c39cd475 cab500a2    ÃœÔuÊµ.¢
>> ad8ae147 d295ec0c    ­ŠáGÒ•ì.
>> bd639196 3cfa0ad5    ½c‘–<ú.Õ
>>
>> 14 data bytes
>>
>> 0c8f863e 8c000fd7    .†>Œ..×
>> 9300cb04 ffd9        “.Ë.ÿÙ
>>
>> The problem seems to be that the payload sent by the camera is much larger
>> than dwMaxPayloadTransferSize. For this reason the driver assumes that it
>> has found the end of the frame after processing the third URB. This test is
>> performed at the bottom of uvc_video_decode_bulk. It then expects URB 4 to
>> be the start of a new frame, which it isn't, and so it gets out of sync. If
>> I understand correctly, dwMaxPayloadTransferSize is set by the camera, so
>> perhaps the camera is at fault here.
>
> Yes, I believe the camera violates the spec.
>
>> Interestingly, I checked some wireshark logs I took while using the camera
>> with the Dell XPS12 booted into Windows and I see the exact same thing. The
>> dwMaxPayloadTransferSize is set to 34816, but the payloads were much larger,
>> around 140kb.
>
> What bulk URB size did Windows use ?
>
>> As the camera works fine on Windows, I'm guessing Windows is not relying on
>> the dwMaxPayloadTransferSize to detect the end of a payload. Perhaps it just
>> uses the FID. Does this sound plausible? If so, I might see if I can
>> replicate this behaviour locally, to see if it solves the issue.
>
> I don't think it uses the FID, as that requires the presence of a header,
> which is only present at the beginning of payloads, and thus require the
> driver to be able to detect the payload in the first place.
>
> With the three USB traces I've received so far for your camera it seems that
> we could detect the end of a payload by a short URBs. Maybe that's what
> Windows does. This would however probably break if the MJPEG data size +
> header size happens to be a multiple of 16kB.
>
> Have you looked at the YUYV capture traces ? What's the data pattern there ? I
> would expect the last 14 bytes transfer not to be present for YUYV. Does the
> camera use a single payload in that case as well ?
>

I have, and the behaviour seems to differ depending on the frameIndex. 
I haven't tested all of the resolutions yet, but here are the two main 
patterns I see for YVUV.

- For some resolutions, each frame is split up into multiple payloads, 
each of which are equal in size to the dwMaxPayloadTransferSize, apart 
perhaps from the last.  Each payload consists of a single URB ( I hope 
this is the correct terminology ) and has a header.  The total size of 
the payload equals the dwMaxPayloadFrameSize + (Number of URBs * 12).

- For other resolutions, there is a single payload per frame.  The 
payload itself is split over multiple URBs.  The payload is not 
terminated by a URB containing just a header, i.e., a URB of 14 bytes, 
as you guessed.  The size of the entire payload is equal to the 
dwMaxPayloadFrameSize + 12 and is lower than the dwMaxPayloadTransferSize.

I'm going to carry on investigating and will report back here once I 
have a complete picture of the camera's behaviour.






