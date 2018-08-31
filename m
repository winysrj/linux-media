Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50702 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727202AbeHaMdx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 08:33:53 -0400
Subject: Re: [PATCH (repost) 5/5] drm/amdgpu: add DisplayPort
 CEC-Tunneling-over-AUX support
To: Alex Deucher <alexdeucher@gmail.com>
Cc: "Wentland, Harry" <harry.wentland@amd.com>,
        linux-media <linux-media@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
 <20180817141122.9541-6-hverkuil@xs4all.nl>
 <79366c45-6cd4-6e19-5b5f-73b50b9e995e@amd.com>
 <13f3fa34-29af-b37d-bbde-7fed160efe1d@xs4all.nl>
 <CADnq5_NTeAU-SsKU9-0dgFHRpX331FDCAbw1tQYmsxC_AcXeZg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cb07903f-b966-802f-a04c-5d299d46aa8b@xs4all.nl>
Date: Fri, 31 Aug 2018 10:27:30 +0200
MIME-Version: 1.0
In-Reply-To: <CADnq5_NTeAU-SsKU9-0dgFHRpX331FDCAbw1tQYmsxC_AcXeZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/2018 04:59 PM, Alex Deucher wrote:
> On Fri, Aug 24, 2018 at 3:20 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 08/23/2018 08:38 PM, Harry Wentland wrote:
>>> On 2018-08-17 10:11 AM, Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Add DisplayPort CEC-Tunneling-over-AUX support to amdgpu.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> Acked-by: Alex Deucher <alexander.deucher@amd.com>
>>>> ---
>>>>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   | 13 +++++++++++--
>>>>  .../drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |  2 ++
>>>>  2 files changed, 13 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>> index 34f34823bab5..77898c95bef6 100644
>>>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>> @@ -898,6 +898,7 @@ amdgpu_dm_update_connector_after_detect(struct amdgpu_dm_connector *aconnector)
>>>>              aconnector->dc_sink = sink;
>>>>              if (sink->dc_edid.length == 0) {
>>>>                      aconnector->edid = NULL;
>>>> +                    drm_dp_cec_unset_edid(&aconnector->dm_dp_aux.aux);
>>>>              } else {
>>>>                      aconnector->edid =
>>>>                              (struct edid *) sink->dc_edid.raw_edid;
>>>> @@ -905,10 +906,13 @@ amdgpu_dm_update_connector_after_detect(struct amdgpu_dm_connector *aconnector)
>>>>
>>>>                      drm_connector_update_edid_property(connector,
>>>>                                      aconnector->edid);
>>>> +                    drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
>>>> +                                        aconnector->edid);
>>>>              }
>>>>              amdgpu_dm_add_sink_to_freesync_module(connector, aconnector->edid);
>>>>
>>>>      } else {
>>>> +            drm_dp_cec_unset_edid(&aconnector->dm_dp_aux.aux);
>>>>              amdgpu_dm_remove_sink_from_freesync_module(connector);
>>>>              drm_connector_update_edid_property(connector, NULL);
>>>>              aconnector->num_modes = 0;
>>>> @@ -1059,12 +1063,16 @@ static void handle_hpd_rx_irq(void *param)
>>>>                      drm_kms_helper_hotplug_event(dev);
>>>>              }
>>>>      }
>>>> +
>>>>      if ((dc_link->cur_link_settings.lane_count != LANE_COUNT_UNKNOWN) ||
>>>> -        (dc_link->type == dc_connection_mst_branch))
>>>> +        (dc_link->type == dc_connection_mst_branch)) {
>>>>              dm_handle_hpd_rx_irq(aconnector);
>>>> +    }
>>>
>>> These lines don't really add anything functional.
>>
>> Oops, a left-over from debugging code. I'll remove this 'change' and post a v2
>> with all the Acks/reviewed-bys.
>>
>> Any idea who would typically merge a patch series like this?
> 
> I (or anyone else with drm-misc rights) can push them for you, however
> drm-misc is a committer tree so if you'd like access to apply patches
> yourself, you could do that too.  Request access here:
> https://www.freedesktop.org/wiki/AccountRequests/

OK, I pushed this series to drm-next. It's the first time I'm using dim & drm-misc
so let me know if I did anything silly.

Regards,

	Hans
