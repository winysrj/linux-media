Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-xsmtp3.externet.hu ([212.40.96.154]:37138 "EHLO
	mail-xsmtp3.externet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab2AXOmK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 09:42:10 -0500
Message-ID: <4F1EC340.6080505@gmail.com>
Date: Tue, 24 Jan 2012 15:42:08 +0100
From: Csillag Kristof <csillag.kristof@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: 720p webcam providing VDPAU-compatible video stream?
References: <4F1C0921.1060109@gmail.com> <201201231541.32049.laurent.pinchart@ideasonboard.com> <4F1D8B51.4020507@gmail.com> <201201241516.21919.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201241516.21919.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At 2012-01-24 15:16, Laurent Pinchart wrote:
> Hi Kristof,
>
> On Monday 23 January 2012 17:31:13 Csillag Kristof wrote:
>> At 2012-01-23 15:41, Laurent Pinchart wrote:
>>> I think your best bet is still UVC + H.264, as that's what the market is
>>> moving to. Any other compressed format (except for MJPEG) will likely be
>>> proprietary.
>>>
>>> As you correctly mention, H.264 support isn't available yet in the UVC
>>> driver. Patches are welcome ;-)
>> So... do I understand it correctly that with the current hw/sw stack, my
>> original requirements can not be satisfied?
> Not that I'm aware of.
OK, thank you for confirming that. In this case, I will just give this 
up, for now.

>> In that case, let's try with reduced requirements. What if I give up HD
>> resolution and H264?
>>
>> Is there a camera that can provide a HW-compressed 480p video stream, in
>> MPEG-2 or something like that?
> I don't think so. Once again, unless you can work with MJPEG, your best bet is
> UVC and H.264. But you will need to write the code (or find someone who can
> write it).
>
I could definitely write the code, but I wish to spend my (severely 
limited) time and resources on other projects.

Thank you for your help anyway:

     Kristof

