Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38659 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932391AbeEYGex (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 02:34:53 -0400
Message-ID: <1527230092.4938.3.camel@pengutronix.de>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Date: Fri, 25 May 2018 08:34:52 +0200
In-Reply-To: <f327c8f9-5aa2-b945-a356-f86ca488f6fc@gmail.com>
References: <m37eobudmo.fsf@t19.piap.pl>
         <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
         <m3tvresqfw.fsf@t19.piap.pl>
         <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
         <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
         <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
         <m3h8mxqc7t.fsf@t19.piap.pl>
         <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
         <aad7c874-ee05-ef9b-733c-609b6928fc3c@gmail.com>
         <f327c8f9-5aa2-b945-a356-f86ca488f6fc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2018-05-24 at 14:33 -0700, Steve Longerbeam wrote:
> Hi Krzysztof, Philipp,
> 
> And I can confirm that capturing planar 4:2:0 (YU12, YV12, or NV12),
> is broken because of the call to ipu_cpmem_skip_odd_chroma_rows().
> YU12 or NV12 images look correct again when commenting out that
> call. Commits
> 
> 14330d7f08 ("media: imx: csi: enable double write reduction")
> b54a5c2dc8 ("media: imx: prpencvf: enable double write reduction")
> 
> should be reverted for now, until the behavior of this bit is better 
> understood.

I think that is a bit radical. I am not aware of any problems with non-
interlaced formats. Could we just disable them when the interlaced_scan
bit is set?

regards
Philipp
