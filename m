Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEB1C169C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 01:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E64F92081B
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 01:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="ddnU+FrA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfBGBJb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 20:09:31 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:38705 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGBJb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 20:09:31 -0500
Received: by mail-qt1-f171.google.com with SMTP id 2so10224014qtb.5
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 17:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=EmD4Ng3aZ9GlR/UDc5bCr3MD7amZkWyFjNA+aDmPXrM=;
        b=ddnU+FrAO07omNWwOKykx51rPEQzwmIJ5nel0+rEHF0rF6a++xwnkT6BFq9VVTQ2za
         NTUaRWWSsbp3f2msfDCFz8cOlcnRwBh+sVM3qvZdmSyc/yKmOzUHbEHjrzUJgd6QlIbT
         5qgQ4np99LSrh/AkCOTSUf74vCxO9yxs1t/U3Tkp0akoq1jKM4XF0AF1siGwbnU+qodb
         rxzdICmHydCVMtgOo6s4oQX/NsipmVFw42qPcoKzqQl4SItcvztPVelO2/ujDgpzh5e8
         ztDB3j7h71Y/INwG/FuaStQUia9Py0+yBh4FMJPLVOkdL6NoGyVXtLLM0PCMgfv+xEtx
         jClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EmD4Ng3aZ9GlR/UDc5bCr3MD7amZkWyFjNA+aDmPXrM=;
        b=JIQSwmFmRg50eVAT5lQXlvKR+UobHEtONCzQDbyPIeiXjFvKNxwKFEU3a51/QmwTh0
         gfhJB6SsVYVsgoGo5H7XAaL8DJ2vVXgvqB2Hat/Z75R79ohHrvPu61qlhXNGfMnrop4+
         ZJWftPNxyoaLgTFl7EaMjzHOaWMtqyPV72MbtskjOPoT2HvLJiQY0Wsc1l/aerTm7lvO
         e8Js9mXwvcS19FISDpLUiHe6WYQjivEaDvYEQnB7ClzMfwCrJiIqmahSE2dFhs68bFEP
         d2MAIdUWpGTV4Zw3xDYuZt5djVUzxBi4+EShhKV21svPnAvsP9ibb0x7eMFeKac+t9gN
         KGog==
X-Gm-Message-State: AHQUAuYbEJhQkLjWkXZqdiMvkn3DXAxI2Nhv+EdujwHJ0SR4Xw8IZXS/
        xNtrcOvxwk9pXEjB2vO7CwQMgA==
X-Google-Smtp-Source: AHgI3IYmj1xqgwtymaD0somJ4nCUTf4A804jLmrVFLNnPh/Qmzuyh94Ocq2QvFTHcWHlR7QkxBeNPg==
X-Received: by 2002:a0c:b786:: with SMTP id l6mr10229553qve.244.1549501769625;
        Wed, 06 Feb 2019 17:09:29 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id d78sm19461546qke.94.2019.02.06.17.09.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 17:09:28 -0800 (PST)
Message-ID: <aa8dcd7454a0cf91bfcb20605132adc589c395c0.camel@ndufresne.ca>
Subject: Re: [PATCH] media: v4l2-tpg: Fix the memory layout of AYUV buffers
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        linux-media@vger.kernel.org
Date:   Wed, 06 Feb 2019 20:09:27 -0500
In-Reply-To: <1549377502.3929.12.camel@pengutronix.de>
References: <20190129023222.10036-1-vivek.kasireddy@intel.com>
         <92dbd1f9-f5dc-37ed-856a-b3b2aa2b75d5@xs4all.nl>
         <1549377502.3929.12.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mardi 05 février 2019 à 15:38 +0100, Philipp Zabel a écrit :
> Hi Hans,
> 
> On Thu, 2019-01-31 at 14:36 +0100, Hans Verkuil wrote:
> [...]
> > Our YUV32 fourcc is defined as follows:
> > 
> > https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-packed-yuv.html
> > 
> > As far as I see the format that the TPG generates is according to the V4L2 spec.
> > 
> > Philipp, can you check the YUV32 format that the imx-pxp driver uses?
> > Is that according to our spec?
> > 
> > At some point we probably want to add a VUY32 format which is what Weston
> > expects, but we certainly cannot change what the TPG generates for YUV32
> > since that is correct.
> 
> I hadn't noticed as YUV32 doesn't show up in GStreamer, but testing with
> v4l2-ctl, it seems to be incorrect. This script:

Oops, noted, I have filed an issue for that.

https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/565

It was skipped because I always assumed this was not a real format. It
was added in GStreamer for software color conversion as a YUV unpack
format (same for AYUV64 16-16-16-16). This is used in the generic color
conversion path, or the slow path.

> 
>   #!/bin/sh
>   function check() {
>       PATTERN="$1"
>       NAME="$2"
>       echo -ne "${NAME}:\t"
>       v4l2-ctl \
>           --set-fmt-video-out=width=8,height=8,pixelformat=RGBP \
>           --set-fmt-video=width=8,height=8,pixelformat=YUV4 \
>           --stream-count 1 \
>           --stream-poll \
>           --stream-out-pattern "${PATTERN}" \
>           --stream-out-mmap 3 \
>           --stream-mmap 3 \
>           --stream-to - 2>/dev/null | hexdump -v -n4 -e '/1 "%02x "'
>       echo
>   }
>   check 6 "100% white"
>   check 7 "100% red"
>   check 9 "100% blue"
> 
> results in the following output:
> 
>   100% white:	80 80 ea ff 
>   100% red:	f0 66 3e ff 
>   100% blue:	74 f0 23 ff 
> 
> That looks like 32-bit VUYA 8-8-8-8.
> 
> regards
> Philipp

