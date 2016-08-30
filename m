Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:28042 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757871AbcH3Mjt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 08:39:49 -0400
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Yannick FERTRE <yannick.fertre@st.com>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Tue, 30 Aug 2016 14:39:41 +0200
Subject: RE: [STLinux Kernel] [PATCH v5 0/3] support of v4l2 encoder for
 STMicroelectronics SOC
Message-ID: <A08861FBFE4B8946AB3E6ED5F2D3FEC302BFBA07B6@SAFEX1MAIL3.st.com>
References: <1472476868-10322-1-git-send-email-jean-christophe.trotin@st.com>
 <20160830102342.GA19583@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20160830102342.GA19583@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

First of all, thanks for your answer.
Sorry for the mistake: I missed your first "acked-by" on the version 4 (it seems that I have to review the rules that classify my emails!).
I wait for some other comments about the version 5, and I will add your "acked-by" in the next version.

Regards,
JC.

Jean-Christophe TROTIN | TINA: 1667397 | Tel: +33 244027397 | Mobile: +33 624726135

STMicroelectronics
9-11 rue Pierre-Félix Delarue | 72100 Le Mans | France
ST online: www.st.com


-----Original Message-----
From: Peter Griffin [mailto:peter.griffin@linaro.org] 
Sent: mardi 30 août 2016 12:24
To: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Cc: linux-media@vger.kernel.org; Hans Verkuil <hverkuil@xs4all.nl>; Yannick FERTRE <yannick.fertre@st.com>; kernel@stlinux.com; Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v5 0/3] support of v4l2 encoder for STMicroelectronics SOC

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
