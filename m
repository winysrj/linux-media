Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:37318 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbeEBIYQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2018 04:24:16 -0400
Received: by mail-lf0-f67.google.com with SMTP id b23-v6so19600142lfg.4
        for <linux-media@vger.kernel.org>; Wed, 02 May 2018 01:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20171120114211.21825-2-hverkuil@xs4all.nl>
In-Reply-To: <20171120114211.21825-2-hverkuil@xs4all.nl>
From: Dariusz Marcinkiewicz <darekm@google.com>
Date: Wed, 02 May 2018 08:24:03 +0000
Message-ID: <CALFZZQEbHX2pxvEa0e7B96RoZireiw=pW3NvC6dH=8TP1d+UhA@mail.gmail.com>
Subject: Re: [PATCHv5, 1/3] drm: add support for DisplayPort CEC-Tunneling-over-AUX
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        hans.verkuil@cisco.com, dri-devel@lists.freedesktop.org,
        carlos.santa@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, pretty late here but I have a small comment.


> From: Hans Verkuil <hans.verkuil@cisco.com>

> This adds support for the DisplayPort CEC-Tunneling-over-AUX
> feature that is part of the DisplayPort 1.3 standard.

....
> +int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux, const char
*name,
> +                                struct device *parent, const struct edid
*edid)
> +{
> +       u32 cec_caps = CEC_CAP_DEFAULTS | CEC_CAP_NEEDS_HPD;
It seems there is a slight issue here when kernel is compiled w/o
CONFIG_MEDIA_CEC_RC, in such case
https://github.com/torvalds/linux/blob/master/drivers/media/cec/cec-core.c#L255
strips CEC_CAP_RC from the adapter's caps. As a result the below check
always fails and a new adapter is created every time this is run.
....
> +               if (aux->cec_adap->capabilities == cec_caps &&
> +                   aux->cec_adap->available_log_addrs == num_las) {
> +                       cec_s_phys_addr_from_edid(aux->cec_adap, edid);
> +                       return 0;
> +               }
> +               cec_unregister_adapter(aux->cec_adap);
> +       }
> +
...

Thank you and best regards.
