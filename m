Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56503 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752126AbcLEKS0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 05:18:26 -0500
Subject: Re: [PATCH v3 00/10] Add support for DELTA video decoder of
 STMicroelectronics STiH4xx SoC series
To: Hugues Fruchet <hugues.fruchet@st.com>, linux-media@vger.kernel.org
References: <1479830007-29767-1-git-send-email-hugues.fruchet@st.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <07c0d644-b168-a72f-f4bc-d08c103173a1@xs4all.nl>
Date: Mon, 5 Dec 2016 11:18:20 +0100
MIME-Version: 1.0
In-Reply-To: <1479830007-29767-1-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On 11/22/2016 04:53 PM, Hugues Fruchet wrote:
> This patchset introduces a basic support for DELTA multi-format video
> decoder of STMicroelectronics STiH4xx SoC series.
> 
> DELTA hardware IP is controlled by a remote firmware loaded in a ST231
> coprocessor. Communication with firmware is done within an IPC layer
> using rpmsg kernel framework and a shared memory for messages handling.
> This driver is compatible with firmware version 21.1-3.
> While a single firmware is loaded in ST231 coprocessor, it is composed
> of several firmwares, one per video format family.
> 
> This DELTA V4L2 driver is designed around files:
>   - delta-v4l2.c   : handles V4L2 APIs using M2M framework and calls decoder ops
>   - delta-<codec>* : implements <codec> decoder calling its associated
>                      video firmware (for ex. MJPEG) using IPC layer
>   - delta-ipc.c    : IPC layer which handles communication with firmware using rpmsg
> 
> This first basic support implements only MJPEG hardware acceleration but
> the driver structure is in place to support all the features of the
> DELTA video decoder hardware IP.
> 
> This driver depends on:
>   - ST remoteproc/rpmsg: patchset posted at https://lkml.org/lkml/2016/9/6/77
>   - ST DELTA firmware: its license is under review. When available,
>     pull request will be done on linux-firmware.
> 
> ===========
> = history =
> ===========
> version 3
>   - update after v2 review:
>     - fixed m2m_buf_done missing on start_streaming error case
>     - fixed q->dev missing in queue_init()
>     - removed unsupported s_selection
>     - refactored string namings in delta-debug.c
>     - fixed space before comment
>     - all commits have commit messages
>     - reword memory allocator helper commit
> 
> version 2
>   - update after v1 review:
>     - simplified tracing
>     - G_/S_SELECTION reworked to fit COMPOSE(CAPTURE)
>     - fixed m2m_buf_done missing on start_streaming error case
>     - fixed q->dev missing in queue_init()
>   - switch to kernel-4.9 rpmsg API
>   - DELTA support added in multi_v7_defconfig
>   - minor typo fixes & code cleanup
> 
> version 1:
>   - Initial submission
> 
> ===================
> = v4l2-compliance =
> ===================
> Below is the v4l2-compliance report for the version 3 of the DELTA video
> decoder driver. v4l2-compliance has been build from SHA1:
> 600492351ddf40cc524aab73802153674d7d287b (libdvb5: Fix multiple definition of dvb_dev_remote_init linking error)

Can you update v4l-utils and run this test again? The S_SELECTION compliance
test has been fixed to allow for ENOTTY as the error code.

If the output looks good, then I'll merge this driver (will be for 4.11).

Regards,

	Hans
