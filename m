Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8A1C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 16:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 488F6218D3
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 16:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfBGQfn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:35:43 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52216 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbfBGQfn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 11:35:43 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rmeKgNXmERO5ZrmeLgtJ0o; Thu, 07 Feb 2019 17:35:41 +0100
Subject: Re: [PATCH 3/6] uvc: fix smatch warning
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-4-hverkuil-cisco@xs4all.nl>
 <694295a0-48c0-f35a-47c1-ab89f5c5a866@ideasonboard.com>
 <20190207154131.GE5378@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <895e186b-4958-114d-dfaf-e45220c5bd95@xs4all.nl>
Date:   Thu, 7 Feb 2019 17:35:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190207154131.GE5378@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNvyl5NfBTp8STo3WaeU1Q4WErlHN4WdYaafrdHeihNt/S1vQ7VZ45HQKDu2WFMrm8CTGLnCK4mMfaFxUOGXn6iccp6d6QGpEnkFZlAT6dEui+zCWy98
 2PKGdMSFbUEHgxR6NLsngBdY/mv+eiJD+bpmxCvV9j5XgpnIk1TtJWrFN1rsPCot6IAanzLGqWzohcSRdRtuX6vb2xS7tkMPHg7H3nu1Z6BUdd69fBfyLmBi
 Kxy7BAjuwy56xrLDT1MshNFW7CkSu40IGarxjCsZjZS4kqVKYTD+LsONplBwF/17BcA3RUpmPFUE+CobT4HvZ46lGIwNTuLlD/MM5zGKw1kB1p11WFt8vI5O
 UE1MxfbbqCzSW6b03+YqtNTcx1DL/NaOMh5BU9mXuwoXhrW91LNEop2Fxb7QV4QNr4SDVVac
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/7/19 4:41 PM, Laurent Pinchart wrote:
> Hello,
> 
> On Thu, Feb 07, 2019 at 03:57:26PM +0100, Kieran Bingham wrote:
>> On 07/02/2019 10:13, Hans Overkill wrote:
>>> drivers/media/usb/uvc/uvc_video.c: drivers/media/usb/uvc/uvc_video.c:1893 uvc_video_start_transfer() warn: argument 2 to %u specifier is cast from pointer
>>>
>>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> This look fine to me.
>>
>> Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> Even though I believe we should fix tooling instead of code to handle
> these issues, the patch for uvcvideo doesn't adversely affect the code,
> so
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Should I take this in my tree ?

Yes, go ahead.

Regards,

	Hans

> 
>>> ---
>>>  drivers/media/usb/uvc/uvcvideo.h | 6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
>>> index 9b41b14ce076..c7c1baa90dea 100644
>>> --- a/drivers/media/usb/uvc/uvcvideo.h
>>> +++ b/drivers/media/usb/uvc/uvcvideo.h
>>> @@ -620,8 +620,10 @@ struct uvc_streaming {
>>>  	     (uvc_urb) < &(uvc_streaming)->uvc_urb[UVC_URBS]; \
>>>  	     ++(uvc_urb))
>>>  
>>> -#define uvc_urb_index(uvc_urb) \
>>> -	(unsigned int)((uvc_urb) - (&(uvc_urb)->stream->uvc_urb[0]))
>>> +static inline u32 uvc_urb_index(const struct uvc_urb *uvc_urb)
>>> +{
>>> +	return uvc_urb - &uvc_urb->stream->uvc_urb[0];
>>> +}
>>>
>>>  struct uvc_device_info {
>>>  	u32	quirks;
>>>
> 

