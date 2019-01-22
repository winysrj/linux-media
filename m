Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2072C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8551B2084C
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfAVIGA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 03:06:00 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48553 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727165AbfAVIGA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 03:06:00 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lr4EgkddxBDyIlr4HgSm6x; Tue, 22 Jan 2019 09:05:58 +0100
Subject: Re: [PATCH v2] media: docs-rst: Document m2m stateless video decoder
 interface
To:     Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        linux-media@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20190122062616.164838-1-acourbot@chromium.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9c6ceddc-62c4-e4e7-9e27-b8213d8adb42@xs4all.nl>
Date:   Tue, 22 Jan 2019 09:05:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190122062616.164838-1-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFN+05/CpeswRCtOqgbdRuEGa0RoMps27PYWJR/qbFL/iKmLbs9yf3s6RjDuqLMTbtM7j5TBbVk3H7Mh+KhJav4/oiXyC+WPLF21V+dGZGbZsM5a7owb
 M0kvjJ8eE8jAVCY9837x9knCK3R7LsnTlY4DruHzt2AmGLfZ88GtYJPQzv1IIv+5YRLeRLG384l0TSKeq5FzhZv6feWkBHRCJ+ffrWTQ+plm2vyU7Ztkadmg
 3kbRXskBMbOXVu/DUu8e2q7zBCJDaeLIOdAfGLrT3J4mvwf+PN/Lxiprapl9K20x++Vu9g3zPfKT+0ZpcBG7OwyMShTeuHyYvfmjE3mqf9dqwxFEhlX+GOFb
 sWRFP8bcxVJGmQ4BHY/cRlMi6yrvSrGX9DZPld8VDwt7n18N3L4/lEGeeB3ys6/IRge0YG7f
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/22/2019 07:26 AM, Alexandre Courbot wrote:
> Documents the protocol that user-space should follow when
> communicating with stateless video decoders.
> 
> The stateless video decoding API makes use of the new request and tags
> APIs. While it has been implemented with the Cedrus driver so far, it
> should probably still be considered staging for a short while.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
> Changes since v1:
> 
> * Use timestamps instead of tags to reference frames,
> * Applied Paul's suggestions to not require one frame worth of data per OUTPUT
>   buffer
> 
> One of the effects of requiring sub-frame units to be submitted per request is
> that the stateless decoders are not exactly "stateless" anymore: if a frame is
> made of several slices, then the decoder must keep track of the buffer in which
> the current frame is being decoded between requests, and all the slices for the
> current frame must be submitted before we can consider decoding the next one.
> 
> Also if we decide to force clients to submit one slice per request, then doesn't
> some of the H.264 controls need to change? For instance, in the current v2
> there is still a v4l2_ctrl_h264_decode_param::num_slices member. It is used in
> Chromium to specify the number of slices given to the
> V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS control, but is apparently ignored by the
> Cedrus driver. Maxime, can you comment on this?
> 
>  Documentation/media/uapi/v4l/dev-codec.rst    |   5 +
>  .../media/uapi/v4l/dev-stateless-decoder.rst  | 378 ++++++++++++++++++
>  2 files changed, 383 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> 

Thank you! I have uploaded a version of the V4L2 spec with this and the two older
stateful codec patches applied:

https://hverkuil.home.xs4all.nl/codec-api/uapi/v4l/dev-codec.html

Regards,

	Hans
