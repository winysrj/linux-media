Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58434 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbeGRKdK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 06:33:10 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v4 11/11] drm: rcar-du: Support interlaced video output
 through vsp1
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Ulrich Hecht <ulrich.hecht@gmail.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
 <11186195.Bn5zmcZr3a@avalon>
 <14ede71e-fa99-01d3-eb27-f171e5f3d082@ideasonboard.com>
 <6606380.Aa3oybNsgi@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <af188f90-3c76-0946-2837-cb2d3d2c2367@ideasonboard.com>
Date: Wed, 18 Jul 2018 10:55:58 +0100
MIME-Version: 1.0
In-Reply-To: <6606380.Aa3oybNsgi@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+ MM Team.

On 18/07/18 09:55, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Tuesday, 17 July 2018 23:32:56 EEST Kieran Bingham wrote:
>> On 17/07/18 14:51, Laurent Pinchart wrote:
>>> On Monday, 16 July 2018 20:20:30 EEST Kieran Bingham wrote:
>>>> On 24/05/18 12:50, Laurent Pinchart wrote:
>>>>> On Thursday, 3 May 2018 16:36:22 EEST Kieran Bingham wrote:
>>>>>> Use the newly exposed VSP1 interface to enable interlaced frame support
>>>>>> through the VSP1 lif pipelines.
>>>>>
>>>>> s/lif/LIF/
>>>>
>>>> Fixed.
>>>>
>>>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>>>> ---
>>>>>>
>>>>>>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 1 +
>>>>>>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 3 +++
>>>>>>  2 files changed, 4 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
>>>>>> b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c index
>>>>>> d71d709fe3d9..206532959ec9
>>>>>> 100644
>>>>>> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
>>>>>> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
>>>>>> @@ -289,6 +289,7 @@ static void rcar_du_crtc_set_display_timing(struct
>>>>>> rcar_du_crtc *rcrtc)
>>>>>>
>>>>>>  	/* Signal polarities */
>>>>>>  	value = ((mode->flags & DRM_MODE_FLAG_PVSYNC) ? DSMR_VSL : 0)
>>>>>>  	
>>>>>>  	      | ((mode->flags & DRM_MODE_FLAG_PHSYNC) ? DSMR_HSL : 0)
>>>>>>
>>>>>> +	      | ((mode->flags & DRM_MODE_FLAG_INTERLACE) ? DSMR_ODEV : 0)
>>>>>
>>>>> How will this affect Gen2 ?.
>>>>
>>>> The bit is documented identically for Gen2. Potentially / Probably it
>>>> 'might' reverse the fields... I'm not certain yet. I don't have access
>>>> to a Gen2 platform to test.
>>>>
>>>> I'll see if this change can be dropped, but I think it is playing a role
>>>> in ensuring that the field detection occurs in VSP1 through the
>>>> VI6_STATUS_FLD_STD() field. (see vsp1_dlm_irq_frame_end())
>>>>
>>>>> Could you document what this change does in the
>>>>> commit message ?
>>>>
>>>> This sets the position in the buffer of the ODDF. With this set, the ODD
>>>> field is located in the second half (BOTTOM) of the same frame of the
>>>> interlace display.
>>>>
>>>> Otherwise, it's in the first half (TOP)
>>>>
>>>> I faced some issues as to the ordering when testing, so I suspect this
>>>> might actually be related to that. (re VI6_STATUS_FLD_STD in
>>>> vsp1_dlm_irq_frame_end()).
>>>>
>>>> As you mention - this may have a negative effect on the Gen2
>>>> implementation - so it needs considering with that.
>>>>
>>>>
>>>> /me to investigate further.
>>>
>>> Thank you. I don't object to this change, but I'd like to know what its
>>> implications are on Gen2. It might even fix a bug :-) Let me know if you'd
>>> like me to run tests on a Lager board.
>>
>> I've done some testing with this (removing the DSMR change, and
>> inverting the VI6_STATUS_FLD_STD handling) and had some odd results.
>> Perhaps my testing needs refinement.
>>
>> So, yes please - I think I'd really like to know what the effects are on
>> a Lager platform.
>>
>> Would you (or anyone with a Gen2 and interest in vsp1/du) be able to
>> test my latest vsp1/du/interlaced branch/tag on your local Gen2 platform
>> please?
> 
> I can test it when I'll come back home on the 24th (or rather on the next day 
> as I'll land in the evening). Could you please ping me on the 25th ?
> 
>> I'm testing interlaced with:
>>
>> kmstest # sanity test.
>> kmstest -c 1 -r 1920x1080i --flip

 ## -c 1 may have to change to be the right CRTC number

> 
> My monitors don't support interlaced modes, so this won't be easy :-/

More than that - I suspect "won't be possible"?

Perhaps Niklas, Jacopo, or Uli could help ?

Do any of you have a Gen2 platform - and a monitor/TV capable of showing
interlaced display output?



> Also, what's the expected outcome of the above command in the working and non-
> working cases ?

Expected outcome ... a clean output of the standard kmstest pattern for
the sanity test.

For:
kmstest -c 1 -r 1920x1080i --flip


Good:
  A clean view of the usual 'flip' bar moving from left to right across
the screen.
 Must visually check the following for good result:
  - No 'tearing' on the vertical bar
  - A full height bar, showing the colours, red, green, and blue,
followed by 3 shades of grey; each separated by a white block.
  - cleanly drawn frame numbers



Bad symptoms
 - Half height frames
   (only RGB, or 3 Grey shades showing in the flip bar)

 - Tearing or image racing of any kind (check the frame numbers as they
overdraw on the moving bar. Any blurring of the numbers as the bar
travels past is a fail)


> 
>> Any (easy) other methods for testing interlaced pipelines are welcome.
>>
>> Is it possible to set the mode for kmscube? (--help doesn't look promising)
> 
> Not that I know of, but I think that shouldn't be too difficult to add.
> 
>> I have various test streams of interlaced media content in my media
>> library, but not an easy way of decoding and presenting these on the
>> screen on the Gen3.
>>
>> I believe GStreamer now has a drm/kms sink ... Perhaps I should get that
>> recompiled. (That would help me with other tasks too actually)
>>
>>>>>>  	      | DSMR_DIPM_DISP | DSMR_CSPM;
>>>>>>  	
>>>>>>  	rcar_du_crtc_write(rcrtc, DSMR, value);
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
>>>>>> b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c index
>>>>>> af7822a66dee..c7b37232ee91
>>>>>> 100644
>>>>>> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
>>>>>> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
>>>>>> @@ -186,6 +186,9 @@ static void rcar_du_vsp_plane_setup(struct
>>>>>> rcar_du_vsp_plane *plane)
>>>>>>  	};
>>>>>>  	unsigned int i;
>>>>>>
>>>>>> +	cfg.interlaced = !!(plane->plane.state->crtc->mode.flags
>>>>>> +			    & DRM_MODE_FLAG_INTERLACE);
>>>>>> +
>>>>>>  	cfg.src.left = state->state.src.x1 >> 16;
>>>>>>  	cfg.src.top = state->state.src.y1 >> 16;
>>>>>>  	cfg.src.width = drm_rect_width(&state->state.src) >> 16;
> 
