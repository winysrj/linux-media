Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:42925 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbeEANmo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2018 09:42:44 -0400
Date: Tue, 1 May 2018 08:42:42 -0500
From: Rob Herring <robh@kernel.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 27/28] venus: add sdm845 compatible and resource data
Message-ID: <20180501134242.GA31402@rob-hp-laptop>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
 <20180424124436.26955-28-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424124436.26955-28-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 03:44:35PM +0300, Stanimir Varbanov wrote:
> This adds sdm845 DT compatible string with it's resource
> data table.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  .../devicetree/bindings/media/qcom,venus.txt       |  1 +
>  drivers/media/platform/qcom/venus/core.c           | 22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
