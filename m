Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59810 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdEERd1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 13:33:27 -0400
Subject: Re: [PATCH] media: entity: Catch unbalanced media_pipeline_stop calls
To: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org
References: <1483449131-18075-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <2426604.oXt7iAeI8O@avalon>
 <f2029382-de41-3267-d1f2-6b1366bcae27@ideasonboard.com>
 <20170104085746.GO3958@valkosipuli.retiisi.org.uk>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <a89c9fa7-37e9-e857-268e-b4105c6c8e77@ideasonboard.com>
Date: Fri, 5 May 2017 18:33:22 +0100
MIME-Version: 1.0
In-Reply-To: <20170104085746.GO3958@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 04/01/17 08:57, Sakari Ailus wrote:
> Hi Kieran,
> 
> Thanks for the patch!
> 
> On Tue, Jan 03, 2017 at 05:05:58PM +0000, Kieran Bingham wrote:
>> On 03/01/17 13:36, Laurent Pinchart wrote:
>>> Hi Kieran,
>>>
>>> Thank you for the patch.
>>>
>>> On Tuesday 03 Jan 2017 13:12:11 Kieran Bingham wrote:
>>>> Drivers must not perform unbalanced calls to stop the entity pipeline,
>>>> however if they do they will fault in the core media code, as the
>>>> entity->pipe will be set as NULL. We handle this gracefully in the core
>>>> with a WARN for the developer.
>>>>
>>>> Replace the erroneous check on zero streaming counts, with a check on
>>>> NULL pipe elements instead, as this is the symptom of unbalanced
>>>> media_pipeline_stop calls.
>>>>
>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>
>>> This looks good to me,
>>>
>>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>
>>> I'll let Sakari review and merge the patch.
>>
>> Ahh, yes - I forgot to mention, although perhaps it will be obvious for
>> Sakari - but this patch is based on top of Sakari's pending media
>> pipeline and graph walk cleanup series :D
> 
> I've applied this on top of the other patches.
> 
> It's always good to mention dependencies to other patches, that's very
> relevant for reviewers.

I've just been going through my old branches doing some clean up - and I can't
see that this patch [0] made it to integration anywhere.

Did it get lost?
 It looks like the cleanup series it was based on made it through...

Mauro, perhaps you could pick this one up now ?

Regards

Kieran


[0] https://www.spinics.net/lists/linux-media/msg109715.html
