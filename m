Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48420 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbeIJOHL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 10:07:11 -0400
Subject: Re: [PATCH 0/2] Document memory-to-memory video codec interfaces
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        ezequiel@collabora.com
References: <20180724140621.59624-1-tfiga@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bed0d45d-d5c0-d2dc-03d7-eedf99246182@xs4all.nl>
Date: Mon, 10 Sep 2018 11:13:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180724140621.59624-1-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 07/24/2018 04:06 PM, Tomasz Figa wrote:
> This series attempts to add the documentation of what was discussed
> during Media Workshops at LinuxCon Europe 2012 in Barcelona and then
> later Embedded Linux Conference Europe 2014 in Düsseldorf and then
> eventually written down by Pawel Osciak and tweaked a bit by Chrome OS
> video team (but mostly in a cosmetic way or making the document more
> precise), during the several years of Chrome OS using the APIs in
> production.
> 
> Note that most, if not all, of the API is already implemented in
> existing mainline drivers, such as s5p-mfc or mtk-vcodec. Intention of
> this series is just to formalize what we already have.
> 
> It is an initial conversion from Google Docs to RST, so formatting is
> likely to need some further polishing. It is also the first time for me
> to create such long RST documention. I could not find any other instance
> of similar userspace sequence specifications among our Media documents,
> so I mostly followed what was there in the source. Feel free to suggest
> a better format.
> 
> Much of credits should go to Pawel Osciak, for writing most of the
> original text of the initial RFC.

I'm adding this here as a result of an irc discussion, since it applies
to both encoders and decoders:

How to handle non-square pixel aspect ratios?

Decoders would have to report it through VIDIOC_CROPCAP, so this needs
to be documented when the application should call this, but I don't
think we can provide this information today for encoders.

Regards,

	Hans
