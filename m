Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37784 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755095AbcH3KXq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 06:23:46 -0400
Received: by mail-wm0-f43.google.com with SMTP id i5so27687663wmg.0
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2016 03:23:46 -0700 (PDT)
Date: Tue, 30 Aug 2016 11:23:42 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Yannick Fertre <yannick.fertre@st.com>, kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v5 0/3] support of v4l2 encoder for
 STMicroelectronics SOC
Message-ID: <20160830102342.GA19583@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1472476868-10322-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1472476868-10322-1-git-send-email-jean-christophe.trotin@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Christophe,

On Mon, 29 Aug 2016, Jean-Christophe Trotin wrote:

> version 5:
> - Compilation problem with 4.8-rc1 corrected: unsigned long used for dma_attrs
> - The video bitrate (V4L2_CID_MPEG_VIDEO_BITRATE) and the CPB size (V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE) were respectively considered in kbps and kb, while the V4L2 API specifies them in bps and kB. This is corrected and the code is now aligned with the V4L2 specification
> - If the encoder close function (enc->close) has not been called through hva_stop_streaming (e.g. application is killed), it's called at the encoder instance release (hva_release)
> - hva-v4l2.c: DEFAULT_* renamed HVA_DEFAULT_*
> - hva-v4l2.c: few log messages modified
> - typos corrected
> - V4L2 compliance successfully passed with this version (see report below)
> 

Looks like you forgot to add my: -

 Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter.
