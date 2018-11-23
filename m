Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39428 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbeKXJYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 04:24:05 -0500
Received: by mail-pl1-f196.google.com with SMTP id 101so4863945pld.6
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2018 14:37:59 -0800 (PST)
Subject: Re: 'bad remote port parent' warnings
To: Fabio Estevam <festevam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>
References: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
 <1542904065.16720.2.camel@pengutronix.de>
 <CAOMZO5CRWC1qbYa3wAYfd+_ig0s9Bq2Z8Hz1SmM95Zuxb6LqRw@mail.gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5d63d8ba-94d5-ffb6-cd7c-3217138c5ad4@gmail.com>
Date: Fri, 23 Nov 2018 14:37:54 -0800
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CRWC1qbYa3wAYfd+_ig0s9Bq2Z8Hz1SmM95Zuxb6LqRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On 11/22/18 11:17 AM, Fabio Estevam wrote:
> Hi Philipp,
>
> On Thu, Nov 22, 2018 at 2:27 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
>> There are empty endpoint nodes (without remote-endpoint property)
>> labeled ipu1_csi[01]_mux_from_parallel_sensor in the i.MX6 device trees
>> for board DT implementers' convenience. See commit 2539f517acbdc ("ARM:
>> dts: imx6qdl: Add video multiplexers, mipi_csi, and their connections").
>>
>> We had a discussion about this issue in February when this caused a
>> probing error: https://patchwork.kernel.org/patch/10234469/
> Thanks for the clarification.
>
>   We could demote the warning to a debug message, make the wording a bit
>> less misleading (there is no bad remote port parent, there is just no
>> remote endpoint at all), or we could just accept the error message for
> Something like this?
>
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -613,7 +613,7 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct
> device *dev,
>          asd->match.fwnode =
>                  fwnode_graph_get_remote_port_parent(endpoint);
>          if (!asd->match.fwnode) {
> -               dev_warn(dev, "bad remote port parent\n");
> +               dev_dbg(dev, "no remote endpoint found\n");
>                  ret = -ENOTCONN;
>                  goto out_err;
>          }
>
> And how should we treat these error probes?
>
> [    3.449564] imx-ipuv3 2400000.ipu: driver could not parse
> port@1/endpoint@0 (-22)
> [    3.457342] imx-ipuv3-csi: probe of imx-ipuv3-csi.1 failed with error -22
> [    3.464498] imx-ipuv3 2800000.ipu: driver could not parse
> port@0/endpoint@0 (-22)
> [    3.472120] imx-ipuv3-csi: probe of imx-ipuv3-csi.4 failed with error -22

Yes, this is a regression caused by the imx subdev notifier patches. 
I've already sent a patch to the list for this, see

https://www.spinics.net/lists/linux-media/msg141809.html

Steve
