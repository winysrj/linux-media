Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47259 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbcGTHag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 03:30:36 -0400
Subject: Re: [PATCH v6] [media] pci: Add tw5864 driver
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kozlov Sergey <serjk@netup.ru>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <20160720014205.15521-1-andrey.utkin@corp.bluecherry.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey_utkin@fastmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6be09f83-7fd0-2c1b-8e8e-fa19f6d52751@xs4all.nl>
Date: Wed, 20 Jul 2016 09:30:23 +0200
MIME-Version: 1.0
In-Reply-To: <20160720014205.15521-1-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2016 03:42 AM, Andrey Utkin wrote:
> Changes since v5:
>  - Rework known issues notice as suggested by Hans Verkuil (and previously Joe Perches)
> 
> I am leaving for a vacation in a day and won't respond before 3rd of August.
> I wish to all of you to enjoy your time, too.
> 
> Thanks to all the reviewers for their efforts.
> 

<snip>

> +static int tw5864_input_std_get(struct tw5864_input *input,
> +				enum tw5864_vid_std *std_arg)
> +{
> +	struct tw5864_dev *dev = input->root;
> +	enum tw5864_vid_std std;
> +	u8 std_reg = tw_indir_readb(TW5864_INDIR_VIN_E(input->nr));
> +
> +	std = (std_reg & 0x70) >> 4;
> +
> +	if (std_reg & 0x80) {
> +		dev_err(&dev->pci->dev,
> +			"Video format detection is in progress, please wait\n");

Use dev_dbg instead of dev_err.

> +		return -EAGAIN;
> +	}
> +
> +	if (std == STD_INVALID) {
> +		dev_err(&dev->pci->dev, "No valid video format detected\n");
> +		return -EPERM;

This is still wrong. From my v5 review:

"In this case set *std_arg to V4L2_STD_UNKNOWN and just return 0. As per the QUERYSTD spec."

Also, don't use dev_err here. There is nothing wrong with not being able to detect
a valid format. I'd just drop the message.

> +	}
> +
> +	*std_arg = std;
> +	return 0;
> +}

Regards,

	Hans
