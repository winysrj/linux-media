Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41336C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 09:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 108B7222DD
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 09:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfBPJmp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 04:42:45 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36668 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbfBPJmp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 04:42:45 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id uwUYgeiZPLMwIuwUcgaFvT; Sat, 16 Feb 2019 10:42:43 +0100
Subject: Re: v4l2 mem2mem compose support?
To:     Tim Harvey <tharvey@gateworks.com>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Carlos Rafael Giani <dv@pseudoterminal.org>,
        Discussion of the development of and with GStreamer 
        <gstreamer-devel@lists.freedesktop.org>
References: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1417dde5-ecd5-354e-2ed1-9be4d26ce104@xs4all.nl>
Date:   Sat, 16 Feb 2019 10:42:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfP+sefcq6ZaNsyVjZ/O31TdPVdEx6tw06UoCrsTdkpKsiF3cjpca8aZ7GMzANhnzm6neir7eN8iTElAiSUHuPpoDVmy7U5xDlAk5i0x3pKkpjfWMHWfV
 gfUneLz/zqxbWBUZTvXt4fXNqSXUUmS1oWZVCg/U00p7P6qEschFqGXUtwvQp129CJNV9JCq8fwQ1knQ/Hbz4iJsUPf7UJJxJ0+UhJtW6fFjTpkar0eNpPhR
 LoUQhrlqlJNzQK+CyWTKzg8VD312zp+HFFhJxkWHR7UpmVRIjPWFNTDFY6T4FM+ec5eeuYE7whok+ZpXfdLcy7dPysSsiD49m+cv/m9cdQkFeyfmyHqfRB7L
 l/jK9oZSHrJrtzJ3r0d8Q80oXdQnRsq2L8Y3pCG/eRbSyHqelWxMM4tIn2EcE7bjbxmQZWrfhlt6M2LmO2f9oz8WsoDI3g==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/16/19 1:16 AM, Tim Harvey wrote:
> Greetings,
> 
> What is needed to be able to take advantage of hardware video
> composing capabilities and make them available in something like
> GStreamer?

Are you talking about what is needed in a driver or what is needed in
gstreamer? Or both?

In any case, the driver needs to support the V4L2 selection API, specifically
the compose target rectangle for the video capture.

Regards,

	Hans

> 
> Philipp's mem2mem driver [1] exposes the IMX IC and GStreamer's
> v4l2convert element uses this nicely for hardware accelerated
> scaling/csc/flip/rotate but what I'm looking for is something that
> extends that concept and allows for composing frames from multiple
> video capture devices into a single memory buffer which could then be
> encoded as a single stream.
> 
> This was made possible by Carlo's gstreamer-imx [2] GStreamer plugins
> paired with the Freescale kernel that had some non-mainlined API's to
> the IMX IPU and GPU. We have used this to take for example 8x analog
> capture inputs, compose them into a single frame then H264 encode and
> stream it. The gstreamer-imx elements used fairly compatible
> properties as the GstCompositorPad element to provide a destination
> rect within the compose output buffer as well as rotation/flip, alpha
> blending and the ability to specify background fill.
> 
> Is it possible that some of this capability might be available today
> with the opengl GStreamer elements?
> 
> Best Regards,
> 
> Tim
> 
> [1] https://patchwork.kernel.org/patch/10768463/
> [2] https://github.com/Freescale/gstreamer-imx
> 

