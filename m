Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:55788 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933608AbeAOOlx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 09:41:53 -0500
Subject: Re: MT9M131 on I.MX6DL CSI color issue
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <1516020546.10524.4.camel@pengutronix.de>
From: Florian Boor <florian.boor@kernelconcepts.de>
Message-ID: <5a532d44-0395-4ffc-ba41-988d62385e2e@kernelconcepts.de>
Date: Mon, 15 Jan 2018 15:41:50 +0100
MIME-Version: 1.0
In-Reply-To: <1516020546.10524.4.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 15.01.2018 13:49, Philipp Zabel wrote:
> media-ctl propagates video formats downstream, can you try reversing the
> order?

I did but it does not make a difference.

> Also, while the external format is UYVY2X8, internally the IPU only
> supports AYUV32, so the last call should be 
> 
> media-ctl -d /dev/media0 -v -V "'ipu1_csi0':2 [fmt:AYUV32/${GEOM} field:none]"
> not that it should make a visible difference.
> And setting a format on 'ipu1_csi0 capture' is not necessary.

Changed this as well. What I do now is the following:

SF="UYVY2X8"
IF="AYUV32"
GEOM="1280x1024"

media-ctl -r
media-ctl -l "'mt9m111 2-0048':0 -> 'ipu1_csi0_mux':4[1]"
media-ctl -l "'ipu1_csi0_mux':5 -> 'ipu1_csi0':0[1]"
media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"

media-ctl -d /dev/media0 -v -V "'mt9m111 2-0048':0 [fmt:${SF}/${GEOM} field: none]"
media-ctl -d /dev/media0 -v -V "'ipu1_csi0_mux':4 [fmt:${SF}/${GEOM} field: none]"
media-ctl -d /dev/media0 -v -V "'ipu1_csi0_mux':5 [fmt:${SF}/${GEOM} field: none]"
media-ctl -d /dev/media0 -v -V "'ipu1_csi0':2 [fmt:${IF}/${GEOM} field:none]"


> The new picture looks a little like there is 10-bit sensor data and only
> the lower 8-bit arrive in memory, given the number of wraparounds.

I will take a look at the sensor configuration. Maybe there is some issue or a
difference among all th MT9M1x1 semsors the driver does not support.

> Can you show the output of "media-ctl -p" (or "media-ctl --get-v4l2" for
> each pad in the pipeline)?

> media-ctl --get-v4l2 "'mt9m111 2-0048':0"
                [fmt:UYVY2X8/1280x1024 field:none]
                 crop.bounds:(26,8)/1280x1024
                 crop:(26,8)/1280x1024]
> media-ctl --get-v4l2 "'ipu1_csi0_mux':4"
                [fmt:UYVY2X8/1280x1024 field:none]
> media-ctl --get-v4l2 "'ipu1_csi0_mux':5"
                [fmt:UYVY2X8/1280x1024 field:none]
> media-ctl --get-v4l2 "'ipu1_csi0':0"
                [fmt:UYVY2X8/1280x1024 field:none
                 crop.bounds:(0,0)/1280x1024
                 crop:(0,0)/1280x1024
                 compose.bounds:(0,0)/1280x1024
                 compose:(0,0)/1280x1024]
> media-ctl --get-v4l2 "'ipu1_csi0':2"
                [fmt:AYUV32/1280x1024 field:none]

I uploaded the complete topology output from media-ctrl -p as well [1].

Greetings

Florian


[1] http://www.kernelconcepts.de/~florian/media-ctl-topology.txt



-- 
The dream of yesterday                  Florian Boor
is the hope of today                    Tel: +49 271-771091-15
and the reality of tomorrow.		Fax: +49 271-338857-29
[Robert Hutchings Goddard, 1904]        florian.boor@kernelconcepts.de
                                        http://www.kernelconcepts.de/en

kernel concepts GmbH
Hauptstraße 16
D-57074 Siegen
Geschäftsführer: Ole Reinhardt
HR Siegen, HR B 9613
