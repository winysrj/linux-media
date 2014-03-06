Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39389 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbaCFNE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Mar 2014 08:04:56 -0500
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 20F76208E1
	for <linux-media@vger.kernel.org>; Thu,  6 Mar 2014 08:04:52 -0500 (EST)
Message-ID: <53187272.6000901@williammanley.net>
Date: Thu, 06 Mar 2014 13:04:50 +0000
From: William Manley <will@williammanley.net>
MIME-Version: 1.0
To: Paulo Assis <pj.assis@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: uvcvideo: logitech C920 resets controls during VIDIOC_STREAMON
References: <5317ACAC.8000008@williammanley.net> <CAPueXH7UaScMA2S1r77oR+5p=MCxQEx3P0c2bhxS+8weqdVUBQ@mail.gmail.com>
In-Reply-To: <CAPueXH7UaScMA2S1r77oR+5p=MCxQEx3P0c2bhxS+8weqdVUBQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/14 12:09, Paulo Assis wrote:
> Hi,
> 
> 2014-03-05 23:01 GMT+00:00 William Manley <will@williammanley.net>:
>> Hi All
>>
>> I've been attempting to use the Logitech C920 with the uvcvideo driver.
>>  I set the controls with v4l2-ctl but some of them change during
>> VIDIOC_STREAMON.  My understanding is that the values of controls should
>> be preserved.
>>

[snip]

>> The camera does
>> have a mode where it would change by itself but that is disabled
>> (exposure_auto=1).
> 
> This alone doesn't guarantee that exposure absolute is untouched.
> To do so you need to set V4L2_CID_EXPOSURE_AUTO_PRIORITY to 0 and
> V4L2_CID_EXPOSURE_AUTO to V4L2_EXPOSURE_MANUAL

The behaviour is the same whether exposure_auto_priority is set to 1 or
0.  I don't think I've explained myself clearly - the exposure time does
not change by itself, apart from during VIDIOC_STREAMON:

* When I'm streaming video from the camera it's constant.
* When no data is coming from the camera it's constant

It's only modified during STREAMON and when I explicitly set it with
v4l2-ctl.

This doesn't seem like correct behaviour as it breaks the use-case of
setting the controls as you want before starting streaming.  My
workaround is to reset all the controls after calling VIDIOC_STREAMON
but this is ugly and you get a few frames at the beginning of the video
stream where the settings are set correctly.

Thanks

Will
