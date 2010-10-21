Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1077 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0JUJyB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 05:54:01 -0400
Message-ID: <94fe1f7e552afe0c9e16dc4aa9ccc13c.squirrel@webmail.xs4all.nl>
In-Reply-To: <1287647561-28386-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1287647561-28386-1-git-send-email-matti.j.aaltonen@nokia.com>
Date: Thu, 21 Oct 2010 11:53:48 +0200
Subject: Re: [PATCH] v4l-utils: Add support for new RDS CAP bits.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	"Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matti,

Looks good. I'll merge it in v4l-utils once the driver is merged in v4l-dvb.

Regards,

        Hans

> Add support for V4L2_TUNER_CAP_RDS_BLOCK_IO and
> V4L2_TUNER_CAP_RDS_CONTROLS tuner/modulator capability
> bits.
>
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl.cpp |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index ab9a7d1..bd971dc 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -1266,6 +1266,10 @@ static std::string tcap2s(unsigned cap)
>  		s += "lang2 ";
>  	if (cap & V4L2_TUNER_CAP_RDS)
>  		s += "rds ";
> +	if (cap & V4L2_TUNER_CAP_RDS_BLOCK_IO)
> +		s += "rds-block-io ";
> +	if (cap & V4L2_TUNER_CAP_RDS_CONTROLS)
> +		s += "rds-controls ";
>  	return s;
>  }
>
> --
> 1.6.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

