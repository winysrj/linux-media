Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:53374 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754307AbeENPA3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 11:00:29 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w4EEuXpV009832
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 16:00:27 +0100
Received: from mail-pl0-f69.google.com (mail-pl0-f69.google.com [209.85.160.69])
        by mx08-00252a01.pphosted.com with ESMTP id 2hwmrg14hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 16:00:27 +0100
Received: by mail-pl0-f69.google.com with SMTP id b36-v6so11497865pli.2
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 08:00:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAoAYcNiAMafVk+-JasZZso7JwEN79FQPpBuGmbQZRhdSuQEqw@mail.gmail.com>
References: <CAAoAYcNiAMafVk+-JasZZso7JwEN79FQPpBuGmbQZRhdSuQEqw@mail.gmail.com>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Mon, 14 May 2018 16:00:24 +0100
Message-ID: <CAAoAYcNFEgYxMUXMJ2LcSvMmh72q8OxT=KQCsOMp_+sdvAX-vw@mail.gmail.com>
Subject: Re: Compressed formats - framed or unframed?
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 April 2018 at 17:25, Dave Stevenson
<dave.stevenson@raspberrypi.org> wrote:
> Hi All.
>
> I'm trying to get a V4L2 M2M driver sorted for the Raspberry Pi to
> allow access to the video codecs. Much of it is working fine.
>
> One thing that isn't clear relates to video decode. Do the compressed
> formats (eg V4L2_PIX_FMT_H264) have to be framed into one frame per
> V4L2 buffer, or is providing unframed chunks of an elementary stream
> permitted. The docs only say "H264 video elementary stream with start
> codes.". Admittedly timestamps are nearly meaningless if you feed in
> unframed data, but could potentially be interpolated.
>
> What does other hardware support?
>
> I could handle it either way, but there are some performance tweaks I
> can do if I know the data must be framed.

Does anyone have any view on this?

Thanks
  Dave
