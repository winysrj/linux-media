Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:40737 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbeDLSjx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 14:39:53 -0400
Subject: Re: [PATCH] media: imx: Skip every second frame in VDIC DIRECT mode
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20180407130440.24886-1-marex@denx.de>
 <1523527441.3689.7.camel@pengutronix.de>
From: Marek Vasut <marex@denx.de>
Message-ID: <d0a89fe0-dff6-ed52-612f-fff6ab353962@denx.de>
Date: Thu, 12 Apr 2018 12:06:32 +0200
MIME-Version: 1.0
In-Reply-To: <1523527441.3689.7.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2018 12:04 PM, Philipp Zabel wrote:
> On Sat, 2018-04-07 at 15:04 +0200, Marek Vasut wrote:
>> In VDIC direct mode, the VDIC applies combing filter during and
>> doubles the framerate, that is, after the first two half-frames
>> are received and the first frame is emitted by the VDIC, every
>> subsequent half-frame is patched into the result and a full frame
>> is produced. The half-frame order in the full frames is as follows
>> 12 32 34 54 etc.
> 
> Is that true? We are only supporting full motion mode (VDI_MOT_SEL=2),
> so I was under the impression that only data from the current field
> makes it into the full frame. The missing lines should be purely
> estimated from the available field using the di_vfilt 4-tap filter.

Try using the VDIC within a pipeline directly:

        media-ctl -l "'ipu1_csi0':1->'ipu1_vdic':0[1]"
        media-ctl -l "'ipu1_vdic':2->'ipu1_ic_prp':0[1]"
        media-ctl -l "'ipu1_ic_prp':2->'ipu1_ic_prpvf':0[1]"
        media-ctl -l "'ipu1_ic_prpvf':1->'ipu1_ic_prpvf capture':0[1]"

-- 
Best regards,
Marek Vasut
