Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E06C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1EB620645
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1EB620645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbeLMM2u (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 07:28:50 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:42457 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728859AbeLMM2u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 07:28:50 -0500
Received: from [IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6] ([IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6])
        by smtp-cloud8.xs4all.net with ESMTPA
        id XQ6ggsVzvuDWoXQ6hgNfiC; Thu, 13 Dec 2018 13:28:48 +0100
Subject: Re: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
To:     Jonas Karlman <jonas@kwiboo.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        =?UTF-8?Q?Jernej_=c5=a0krabec?= <jernej.skrabec@gmail.com>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-7-hverkuil-cisco@xs4all.nl>
 <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl>
Date:   Thu, 13 Dec 2018 13:28:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNovSwHaz4bLGh+ey8vqPUjdnH1Bna6XHuzkNt6G7v8JF9PO6uUZhzTlECd1e9umVFjaG8tDlR5wibcdvB47/6A5Q1va90RTlJApseSW/gYnsG2j4NTi
 ZGZgmqK/+LcNQ3ff2y3m0Mjk3DEk0dK/KGiR6D6UOYs67RILTLxpqd7mnkWmaarZ4Qll+Jw0GuRe+5GTYU0jUeJY5HxLzyRNh+1sQOkvoQXM11RrJoZwhADl
 ltpEQriyMZAtJHD7SkbrOX5nf3jAlk82NSIA0PDf1oh7XayCRgoSQx4rczTZz2meZ4IUqvZojo855X910++fpKv0LNElzjPRfkm4WtVeG9U3yB1qPqGnSNnM
 ffaA+oPwArU6kdMBej1oiO/78kg991HxBaifZcNaWRrqGJgeodx9TvzmdXRBf6VW874r4uDa2lH1StIvrgV8DBG1R2k8QYBjGjuazEUl8muU1wQ91XA3VBmn
 34jt9osW55PkAupUyuqqh5Hp8RyMnf3nH4ieJaxBdBCLFSooOuGXwl5zbiqLvfDhbfugupKFKTObj8ZJ12sT+DsAOJpdwPPE16+GYw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/12/18 7:28 PM, Jonas Karlman wrote:
> Hi Hans,
> 
> Since this function only return DEQUEUED and DONE buffers,
> it cannot be used to find a capture buffer that is both used for
> frame output and is part of the frame reference list.
> E.g. a bottom field referencing a top field that is already
> part of the capture buffer being used for frame output.
> (top and bottom field is output in same buffer)
> 
> Jernej Škrabec and me have worked around this issue in cedrus driver by
> first checking
> the tag/timestamp of the current buffer being used for output frame.
> 
> 
> // field pictures may reference current capture buffer and is not
> returned by vb2_find_tag
> if (v4l2_buf->tag == dpb->tag)
>     buf_idx = v4l2_buf->vb2_buf.index;
> else
>     buf_idx = vb2_find_tag(cap_q, dpb->tag, 0);
> 
> 
> What is the recommended way to handle such case?

That is the right approach for this. Interesting corner case, I hadn't
considered that.

> Could vb2_find_timestamp be extended to allow QUEUED buffers to be returned?

No, because only the driver knows what the current buffer is.

Buffers that are queued to the driver are in state ACTIVE. But there may be
multiple ACTIVE buffers and vb2 doesn't know which buffer is currently
being processed by the driver.

So this will have to be checked by the driver itself.

Regards,

	Hans

> 
> 
> In our sample code we only keep at most one output, one capture buffer
> in queue
> and use buffer indices as tag/timestamp to simplify buffer handling.
> FFmpeg keeps track of buffers/frames referenced and a buffer will not be
> reused
> until the codec and display pipeline have released all references to it.
> 
> Sample code having interlaced and multi-slice support using previous tag
> version of this patchset can be found at:
> https://github.com/jernejsk/LibreELEC.tv/blob/hw_dec_ffmpeg/projects/Allwinner/patches/linux/0025-H264-fixes.patch#L120-L124
> https://github.com/Kwiboo/FFmpeg/compare/4.0.3-Leia-Beta5...v4l2-request-hwaccel
> 
> Regards,
> Jonas
