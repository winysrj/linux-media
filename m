Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:45405 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752438AbeAESlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 13:41:14 -0500
Date: Fri, 5 Jan 2018 12:41:12 -0600
From: Rob Herring <robh@kernel.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 3/5] media: dt-bindings: ov5640: refine CSI-2 and add
 parallel interface
Message-ID: <20180105184112.pdtpk524bbrxrq5h@rob-hp-laptop>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <1514973452-10464-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514973452-10464-4-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 03, 2018 at 10:57:30AM +0100, Hugues Fruchet wrote:
> Refine CSI-2 endpoint documentation and add bindings
> for DVP parallel interface support.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5640.txt       | 46 +++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 2 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>                 
