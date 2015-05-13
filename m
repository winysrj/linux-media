Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:54868 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806AbbEMIDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 04:03:55 -0400
Message-ID: <5553055B.8070308@xs4all.nl>
Date: Wed, 13 May 2015 10:03:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v6 06/11] cec: add HDMI CEC framework
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com> <1430760785-1169-7-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430760785-1169-7-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

I've started work on a cec-compliance utility and while doing that I
noticed a confusing name:

On 05/04/15 19:32, Kamil Debski wrote:
> +struct cec_caps {
> +	__u32 available_log_addrs;
> +	__u32 capabilities;
> +	__u32 vendor_id;
> +	__u8  version;
> +	__u8  reserved[35];
> +};

I think 'version' should be renamed to 'cec_version' to indicate that we
are talking about the CEC version that the adapter supports, and not about
the driver version.

Regards,

	Hans
