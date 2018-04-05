Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54230 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeDEIqV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 04:46:21 -0400
Subject: Re: [PATCH 11/15] v4l: vsp1: Add per-display list completion
 notification support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-12-laurent.pinchart+renesas@ideasonboard.com>
 <cebc5274-09f7-b352-122d-debee39218fd@ideasonboard.com>
 <12800662.MfxixVfYp4@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <276b2c88-08c0-f720-0215-73b4cf6a1826@ideasonboard.com>
Date: Thu, 5 Apr 2018 09:46:17 +0100
MIME-Version: 1.0
In-Reply-To: <12800662.MfxixVfYp4@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 04/04/18 22:43, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Wednesday, 4 April 2018 19:16:46 EEST Kieran Bingham wrote:
>> On 26/02/18 21:45, Laurent Pinchart wrote:

<snip>

>>>
>>> -void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
>>> +void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool notify)
>>
>> Rather than changing the vsp1_dl_list_commit() function - would it be nicer
>> to have an API to request or set the notify property? :
>>
>> @@..@@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>> ...
>> +	/* The BRx will be released, without sending an update to DRM */
>> +	if (drm_pipe->force_bru_release)
>> +		vsp1_dl_list_request_internal_notify(dl);
>>
>> 	vsp1_dl_list_commit(dl);
>> ...
> 
> That's not a bad idea, but I wonder if it's worth it as we'll have to call an 
> extra function for what is essentially an internal API. On the other hand this 
> isn't a common case, so it's not a hot code path. We could also argue equally 
> that it is the commit that is internal or that it is the display list that is 

Aha, yes - it is more so that the commit is internal ...

> for internal purpose. Do you think an extra function call is better ? If you 
> do I'll change it.

so it could also instead be just a separate commit() function:


void vsp1_dl_list_commit_internal(struct vsp1_dl_list *dl)
{
	dl->internal = true;
	vsp1_dl_list_commit(dl);
}


...


{
	/* The BRx will be released, without sending an update to DRM */
	if (drm_pipe->force_bru_release)
		vsp1_dl_list_commit_internal(dl);
	else
 		vsp1_dl_list_commit(dl);
}

I'll leave the final implementation decision with you - I just thought that
extending the commit call with a notify flag seemed odd.

Of course - that could also have been due to the naming of the 'notify' - if it
was 'internal' as discussed in the other patches, then perhaps a flag on the
function call is still a sensible way. It just affects the other commit usages,
but there's only a total of three calls - so it's really not a big deal. If
there were 12 call locations perhaps the function wrapper would have more merit
- but probably not so much at 3 :D

--
Kieran
