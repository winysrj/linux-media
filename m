Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51921 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726338AbeHXKwB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 06:52:01 -0400
Subject: Re: [PATCH (repost) 5/5] drm/amdgpu: add DisplayPort
 CEC-Tunneling-over-AUX support
To: Harry Wentland <harry.wentland@amd.com>,
        linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
 <20180817141122.9541-6-hverkuil@xs4all.nl>
 <79366c45-6cd4-6e19-5b5f-73b50b9e995e@amd.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <13f3fa34-29af-b37d-bbde-7fed160efe1d@xs4all.nl>
Date: Fri, 24 Aug 2018 09:18:30 +0200
MIME-Version: 1.0
In-Reply-To: <79366c45-6cd4-6e19-5b5f-73b50b9e995e@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2018 08:38 PM, Harry Wentland wrote:
> On 2018-08-17 10:11 AM, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add DisplayPort CEC-Tunneling-over-AUX support to amdgpu.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: Alex Deucher <alexander.deucher@amd.com>
>> ---
>>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   | 13 +++++++++++--
>>  .../drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |  2 ++
>>  2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> index 34f34823bab5..77898c95bef6 100644
>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> @@ -898,6 +898,7 @@ amdgpu_dm_update_connector_after_detect(struct amdgpu_dm_connector *aconnector)
>>  		aconnector->dc_sink = sink;
>>  		if (sink->dc_edid.length == 0) {
>>  			aconnector->edid = NULL;
>> +			drm_dp_cec_unset_edid(&aconnector->dm_dp_aux.aux);
>>  		} else {
>>  			aconnector->edid =
>>  				(struct edid *) sink->dc_edid.raw_edid;
>> @@ -905,10 +906,13 @@ amdgpu_dm_update_connector_after_detect(struct amdgpu_dm_connector *aconnector)
>>  
>>  			drm_connector_update_edid_property(connector,
>>  					aconnector->edid);
>> +			drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
>> +					    aconnector->edid);
>>  		}
>>  		amdgpu_dm_add_sink_to_freesync_module(connector, aconnector->edid);
>>  
>>  	} else {
>> +		drm_dp_cec_unset_edid(&aconnector->dm_dp_aux.aux);
>>  		amdgpu_dm_remove_sink_from_freesync_module(connector);
>>  		drm_connector_update_edid_property(connector, NULL);
>>  		aconnector->num_modes = 0;
>> @@ -1059,12 +1063,16 @@ static void handle_hpd_rx_irq(void *param)
>>  			drm_kms_helper_hotplug_event(dev);
>>  		}
>>  	}
>> +
>>  	if ((dc_link->cur_link_settings.lane_count != LANE_COUNT_UNKNOWN) ||
>> -	    (dc_link->type == dc_connection_mst_branch))
>> +	    (dc_link->type == dc_connection_mst_branch)) {
>>  		dm_handle_hpd_rx_irq(aconnector);
>> +	}
> 
> These lines don't really add anything functional.

Oops, a left-over from debugging code. I'll remove this 'change' and post a v2
with all the Acks/reviewed-bys.

Any idea who would typically merge a patch series like this?

Regards,

	Hans

> 
> Either way, this patch is
> Reviewed-by: Harry Wentland <harry.wentland@amd.com>
> 
> Harry
> 
>>  
>> -	if (dc_link->type != dc_connection_mst_branch)
>> +	if (dc_link->type != dc_connection_mst_branch) {
>> +		drm_dp_cec_irq(&aconnector->dm_dp_aux.aux);
>>  		mutex_unlock(&aconnector->hpd_lock);
>> +	}
>>  }
>>  
>>  static void register_hpd_handlers(struct amdgpu_device *adev)
>> @@ -2732,6 +2740,7 @@ static void amdgpu_dm_connector_destroy(struct drm_connector *connector)
>>  		dm->backlight_dev = NULL;
>>  	}
>>  #endif
>> +	drm_dp_cec_unregister_connector(&aconnector->dm_dp_aux.aux);
>>  	drm_connector_unregister(connector);
>>  	drm_connector_cleanup(connector);
>>  	kfree(connector);
>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
>> index 9a300732ba37..18a3a6e5ffa0 100644
>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
>> @@ -496,6 +496,8 @@ void amdgpu_dm_initialize_dp_connector(struct amdgpu_display_manager *dm,
>>  	aconnector->dm_dp_aux.ddc_service = aconnector->dc_link->ddc;
>>  
>>  	drm_dp_aux_register(&aconnector->dm_dp_aux.aux);
>> +	drm_dp_cec_register_connector(&aconnector->dm_dp_aux.aux,
>> +				      aconnector->base.name, dm->adev->dev);
>>  	aconnector->mst_mgr.cbs = &dm_mst_cbs;
>>  	drm_dp_mst_topology_mgr_init(
>>  		&aconnector->mst_mgr,
>>
