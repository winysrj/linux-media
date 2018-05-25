Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:38986 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030683AbeEYXj5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 19:39:57 -0400
Received: by mail-pg0-f49.google.com with SMTP id w12-v6so1680810pgc.6
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 16:39:56 -0700 (PDT)
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
References: <m37eobudmo.fsf@t19.piap.pl>
 <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com> <m3tvresqfw.fsf@t19.piap.pl>
 <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com> <m3fu2oswjh.fsf@t19.piap.pl>
 <m3603hsa4o.fsf@t19.piap.pl> <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
 <m3h8mxqc7t.fsf@t19.piap.pl> <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
 <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com>
Date: Fri, 25 May 2018 16:39:53 -0700
MIME-Version: 1.0
In-Reply-To: <m3y3g8p5j3.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof, Philipp,


On 05/25/2018 12:18 AM, Krzysztof Hałasa wrote:
> Philipp Zabel <p.zabel@pengutronix.de> writes:
>
>> Maybe scanline interlave and double write reduction can't be used at the
>> same time?
> Well, if it works in non-interlaced modes - it may be the case.
>
> Perhaps the data reduction is done before the field merge step.

Yeah, that might explain the incompatibility. The IDMAC top/bottom
line merging needs all the lines present. It won't have them if the
IDMAC has previously skipped the odd chroma lines. Or maybe I'm
over-simplifying.

In any case as I said they are proved to be incompatible. I am
preparing a patch-set with these fixes.

Krzysztof, in the meantime the patches are available in my
media-tree fork, for testing on the Ventana GW5300:

git@github.com:slongerbeam/mediatree.git, branch 'fix-csi-interlaced'

Steve
