Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:38928 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756091AbeFOId5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 04:33:57 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced scanning
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
        <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
        <1528708771.3818.7.camel@pengutronix.de>
        <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
        <2aff8f80-aa79-6718-6183-6e49088ae498@redhat.com>
        <f6e7eaa3-355e-a5d9-1be5-e5db08a99897@gmail.com>
        <m3h8m5yaeh.fsf@t19.piap.pl>
        <798b8ad7-2fce-8408-b1c4-c2954f524d23@gmail.com>
Date: Fri, 15 Jun 2018 10:33:54 +0200
In-Reply-To: <798b8ad7-2fce-8408-b1c4-c2954f524d23@gmail.com> (Steve
        Longerbeam's message of "Thu, 14 Jun 2018 09:26:16 -0700")
Message-ID: <m336xoxxcd.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

> Right, the selection of interweave is moved to the capture devices,
> so the following will enable interweave:
>
> v4l2-ctl -dN --set-fmt-video=field=interlaced_tb

and

> So the patch to adv7180 needs to be modified to report # field lines.
>
> Try the following:
>
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c

With this patch, fix-csi-interlaced.3 seems to work for me.
"ipu2_csi1":2 reports [fmt:AYUV32/720x576 field:seq-tb], but the
/dev/videoX shows (when requested) 720 x 576 NV12 interlaced, top field
first, and I'm getting valid output.

Thanks for your work.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
