Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:32770 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726450AbeHUAA5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 20:00:57 -0400
Subject: Re: [PATCH (repost) 3/5] drm_dp_mst_topology: fix broken
 drm_dp_sideband_parse_remote_dpcd_read()
To: lyude@redhat.com, linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
 <20180817141122.9541-4-hverkuil@xs4all.nl>
 <85407132acc51cf749f8087128d4ebe326db6af2.camel@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9c789fd1-94fa-af2f-237d-1eb95903b701@xs4all.nl>
Date: Mon, 20 Aug 2018 22:43:45 +0200
MIME-Version: 1.0
In-Reply-To: <85407132acc51cf749f8087128d4ebe326db6af2.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/20/2018 08:59 PM, Lyude Paul wrote:
> Reviewed-by: Lyude Paul <lyude@redhat.com>
> 
> We really need to add support for using this into the MST helpers. A good way to
> test this would probably be to hook up an aux device to the DP AUX adapters we
> create for each MST topology

If you are interested, I have code for that in my MST test branch:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=cec-nv-amd-mst

It's the "drm_dp_mst_topology: use correct AUX channel" patch.

I don't have plans to post this patch since CEC for MST isn't working
(still trying to figure out why not), but you are free to pick it up
if you want.

Regards,

	Hans

> 
> On Fri, 2018-08-17 at 16:11 +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> When parsing the reply of a DP_REMOTE_DPCD_READ DPCD command the
>> result is wrong due to a missing idx increment.
>>
>> This was never noticed since DP_REMOTE_DPCD_READ is currently not
>> used, but if you enable it, then it is all wrong.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/gpu/drm/drm_dp_mst_topology.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
>> b/drivers/gpu/drm/drm_dp_mst_topology.c
>> index 7780567aa669..5ff1d79b86c4 100644
>> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
>> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
>> @@ -439,6 +439,7 @@ static bool drm_dp_sideband_parse_remote_dpcd_read(struct
>> drm_dp_sideband_msg_rx
>>  	if (idx > raw->curlen)
>>  		goto fail_len;
>>  	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
>> +	idx++;
>>  	if (idx > raw->curlen)
>>  		goto fail_len;
>>  
> 
