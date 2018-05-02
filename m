Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:46476 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750867AbeEBIdV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 04:33:21 -0400
Subject: Re: [PATCHv5, 1/3] drm: add support for DisplayPort
 CEC-Tunneling-over-AUX
To: Dariusz Marcinkiewicz <darekm@google.com>
Cc: linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        hans.verkuil@cisco.com, dri-devel@lists.freedesktop.org,
        carlos.santa@intel.com
References: <20171120114211.21825-2-hverkuil@xs4all.nl>
 <CALFZZQEbHX2pxvEa0e7B96RoZireiw=pW3NvC6dH=8TP1d+UhA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dfd80abe-edbf-de55-ccc9-cb91ebe5fc8e@xs4all.nl>
Date: Wed, 2 May 2018 10:33:13 +0200
MIME-Version: 1.0
In-Reply-To: <CALFZZQEbHX2pxvEa0e7B96RoZireiw=pW3NvC6dH=8TP1d+UhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/18 10:24, Dariusz Marcinkiewicz wrote:
> Hello, pretty late here but I have a small comment.
> 
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> This adds support for the DisplayPort CEC-Tunneling-over-AUX
>> feature that is part of the DisplayPort 1.3 standard.
> 
> ....
>> +int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux, const char
> *name,
>> +                                struct device *parent, const struct edid
> *edid)
>> +{
>> +       u32 cec_caps = CEC_CAP_DEFAULTS | CEC_CAP_NEEDS_HPD;
> It seems there is a slight issue here when kernel is compiled w/o
> CONFIG_MEDIA_CEC_RC, in such case
> https://github.com/torvalds/linux/blob/master/drivers/media/cec/cec-core.c#L255
> strips CEC_CAP_RC from the adapter's caps. As a result the below check
> always fails and a new adapter is created every time this is run.

Ah, good one. I missed that.

I've fixed it in my tree.

I still haven't had the time to finish this patch series :-(
It's high on my TODO list, but not high enough yet...

Regards,

	Hans

> ....
>> +               if (aux->cec_adap->capabilities == cec_caps &&
>> +                   aux->cec_adap->available_log_addrs == num_las) {
>> +                       cec_s_phys_addr_from_edid(aux->cec_adap, edid);
>> +                       return 0;
>> +               }
>> +               cec_unregister_adapter(aux->cec_adap);
>> +       }
>> +
> ...
> 
> Thank you and best regards.
> 
