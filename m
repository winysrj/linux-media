Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:59750 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbdC0L2a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 07:28:30 -0400
Subject: Re: [PATCH] cec-core.rst: document the new cec_get_drvdata() helper
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <119266d8-95c9-4bcf-114e-a5bfdb4144e3@xs4all.nl>
CC: Jose Abreu <Jose.Abreu@synopsys.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <2e7b6c7b-c16a-a3f4-a805-a2df84b20c63@synopsys.com>
Date: Mon, 27 Mar 2017 12:26:21 +0100
MIME-Version: 1.0
In-Reply-To: <119266d8-95c9-4bcf-114e-a5bfdb4144e3@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


Thanks! I totally forgot about the documentation update.


On 27-03-2017 10:53, Hans Verkuil wrote:
> Document the new cec_get_drvdata() helper function.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Jose Abreu <joabreu@synopsys.com>

Best regards,
Jose Miguel Abreu

> ---
> diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
> index 81c6d8e93774..8ea3a783f968 100644
> --- a/Documentation/media/kapi/cec-core.rst
> +++ b/Documentation/media/kapi/cec-core.rst
> @@ -51,6 +51,7 @@ ops:
>
>  priv:
>  	will be stored in adap->priv and can be used by the adapter ops.
> +	Use cec_get_drvdata(adap) to get the priv pointer.
>
>  name:
>  	the name of the CEC adapter. Note: this name will be copied.
> @@ -65,6 +66,10 @@ available_las:
>  	the number of simultaneous logical addresses that this
>  	adapter can handle. Must be 1 <= available_las <= CEC_MAX_LOG_ADDRS.
>
> +To obtain the priv pointer use this helper function:
> +
> +.. c:function::
> +	void *cec_get_drvdata(const struct cec_adapter *adap);
>
>  To register the /dev/cecX device node and the remote control device (if
>  CEC_CAP_RC is set) you call:
