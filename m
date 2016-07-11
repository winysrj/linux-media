Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:36060 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754159AbcGKQlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 12:41:02 -0400
Message-ID: <1468255253.8360.142.camel@perches.com>
Subject: Re: [PATCH v4] [media] pci: Add tw5864 driver
From: Joe Perches <joe@perches.com>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kozlov Sergey <serjk@netup.ru>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey_utkin@fastmail.com>
Date: Mon, 11 Jul 2016 09:40:53 -0700
In-Reply-To: <20160711151714.5452-1-andrey.utkin@corp.bluecherry.net>
References: <20160711151714.5452-1-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-07-11 at 18:17 +0300, Andrey Utkin wrote:
[]
> diff --git a/drivers/media/pci/tw5864/tw5864-core.c b/drivers/media/pci/tw5864/tw5864-core.c
[]
> +static const char * const artifacts_warning =
> +"BEWARE OF KNOWN ISSUES WITH VIDEO QUALITY\n"
> +"\n"
> +"This driver was developed by Bluecherry LLC by deducing behaviour of\n"
> +"original manufacturer's driver, from both source code and execution traces.\n"
> +"It is known that there are some artifacts on output video with this driver:\n"
> +" - on all known hardware samples: random pixels of wrong color (mostly\n"
> +"   white, red or blue) appearing and disappearing on sequences of P-frames;\n"
> +" - on some hardware samples (known with H.264 core version e006:2800):\n"
> +"   total madness on P-frames: blocks of wrong luminance; blocks of wrong\n"
> +"   colors \"creeping\" across the picture.\n"
> +"There is a workaround for both issues: avoid P-frames by setting GOP size\n"
> +"to 1. To do that, run this command on device files created by this driver:\n"
> +"\n"
> +"v4l2-ctl --device /dev/videoX --set-ctrl=video_gop_size=1\n"
> +"\n";
> +
> +static char *artifacts_warning_continued =
> +"These issues are not decoding errors; all produced H.264 streams are decoded\n"
> +"properly. Streams without P-frames don't have these artifacts so it's not\n"
> +"analog-to-digital conversion issues nor internal memory errors; we conclude\n"
> +"it's internal H.264 encoder issues.\n"
> +"We cannot even check the original driver's behaviour because it has never\n"
> +"worked properly at all in our development environment. So these issues may\n"
> +"be actually related to firmware or hardware. However it may be that there's\n"
> +"just some more register settings missing in the driver which would please\n"
> +"the hardware.\n"
> +"Manufacturer didn't help much on our inquiries, but feel free to disturb\n"
> +"again the support of Intersil (owner of former Techwell).\n"
> +"\n";
[]
> +static int tw5864_initdev(struct pci_dev *pci_dev,
> +			  const struct pci_device_id *pci_id)
> +{
[]
> +	dev_warn(&pci_dev->dev, "%s", artifacts_warning);
> +	dev_warn(&pci_dev->dev, "%s", artifacts_warning_continued);

Is all that verbosity useful?

And trivially:

Each of these blocks will start with the dev_<level> prefix
and the subsequent lines will not have the same prefix

Perhaps it'd be better to write this something like:

static const char * const artifacts_warning[] = {
	"BEWARE OF KNOWN ISSUES WITH VIDEO QUALITY",
	"",
	"This driver was developed by Bluecherry LLC by deducing behaviour of",
	"original manufacturer's driver, from both source code and execution traces.",
	"It is known that there are some artifacts on output video with this driver:",
	" - on all known hardware samples: random pixels of wrong color (mostly",
	"   white, red or blue) appearing and disappearing on sequences of P-frames;",
	" - on some hardware samples (known with H.264 core version e006:2800):",
	"   total madness on P-frames: blocks of wrong luminance; blocks of wrong",
	"   colors \"creeping\" across the picture.",
	"There is a workaround for both issues: avoid P-frames by setting GOP size",
	"to 1. To do that, run this command on device files created by this driver:",
	"",
	"v4l2-ctl --device /dev/videoX --set-ctrl=video_gop_size=1",
	"",
	"These issues are not decoding errors; all produced H.264 streams are decoded",
	"properly. Streams without P-frames don't have these artifacts so it's not",
	"analog-to-digital conversion issues nor internal memory errors; we conclude",
	"it's internal H.264 encoder issues.",
	"We cannot even check the original driver's behaviour because it has never",
	"worked properly at all in our development environment. So these issues may",
	"be actually related to firmware or hardware. However it may be that there's",
	"just some more register settings missing in the driver which would please",
	"the hardware.",
	"Manufacturer didn't help much on our inquiries, but feel free to disturb",
	"again the support of Intersil (owner of former Techwell).\n"
};

and use

	for (i = 0; i < ARRAY_SIZE(artifacts_warning), i++)
		dev_warn(&pci_dev->dev, %s\n", artifacts_warning[i]);

so that each line is prefixed.

It also might be better to issue something like a single
line dev_warn referring to the driver code and just leave
this comment in the driver sources.

Something like:

	dev_warn(&pci_dev->dev,
		"This driver has known defects in video quality\n");

