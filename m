Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45226 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbdHPIkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 04:40:47 -0400
Subject: Re: [PATCH 1/5] media/cec.h: add CEC_CAP_DEFAULTS
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <2bed1912-2c1c-d753-dbf6-8e032c902793@samsung.com>
Date: Wed, 16 Aug 2017 10:40:41 +0200
MIME-version: 1.0
In-reply-to: <20170804104155.37386-2-hverkuil@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170804104155.37386-1-hverkuil@xs4all.nl>
        <20170804104155.37386-2-hverkuil@xs4all.nl>
        <CGME20170816084045epcas2p435b2d7ef400710156d28a6e6bdf90efd@epcas2p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2017 12:41 PM, Hans Verkuil wrote:

> The CEC_CAP_LOG_ADDRS, CEC_CAP_TRANSMIT, CEC_CAP_PASSTHROUGH and
> CEC_CAP_RC capabilities are normally always present.
> 
> Add a CEC_CAP_DEFAULTS define that ORs these four caps to simplify
> drivers.
> 
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
