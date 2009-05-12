Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:45756 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZELFRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 01:17:23 -0400
Subject: Re: [PATCH v2 4/7] FMTx: si4713: Add files to handle si4713 i2c
 device
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1242034309-13448-5-git-send-email-eduardo.valentin@nokia.com>
References: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-2-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-3-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-4-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-5-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 08:15:50 +0300
Message-Id: <1242105350.19944.56.camel@eenurkka-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-05-11 at 11:31 +0200, Valentin Eduardo (Nokia-D/Helsinki)
wrote:
> +/*
> + * Values for region specific configurations
> + * (spacing, bottom and top frequencies, preemphasis)
> + */
> +static struct region_info region_configs[] = {
> +       /* USA */
> +       {
> +               .channel_spacing        = 20,
> +               .bottom_frequency       = 8750,
> +               .top_frequency          = 10800,
> +               .preemphasis            = 0,
> +               .region                 = 0,
> +       },
> +       /* Australia */
> +       {
> +               .channel_spacing        = 20,
> +               .bottom_frequency       = 8750,
> +               .top_frequency          = 10800,
> +               .preemphasis            = 1,
> +               .region                 = 1,
> +       },
> +       /* Europe */
> +       {
> +               .channel_spacing        = 10,
> +               .bottom_frequency       = 8750,
> +               .top_frequency          = 10800,
> +               .preemphasis            = 1,
> +               .region                 = 2,
> +       },
> +       /* Japan */
> +       {
> +               .channel_spacing        = 10,
> +               .bottom_frequency       = 7600,
> +               .top_frequency          = 9000,
> +               .preemphasis            = 1,
> +               .region                 = 3,
> +       },
> +       /* Japan wide band */
> +       {
> +               .channel_spacing        = 10,
> +               .bottom_frequency       = 7600,
> +               .top_frequency          = 10800,
> +               .preemphasis            = 1,
> +               .region                 = 4,
> +       },
> +};
> +

Hi,

I took a quick peek;

For USA, the correct range appears as:
USA: 87.9 - 107.9

Some more to add:

China: 92 - 108 Mhz
Korea: 88 - 108 Mhz
(Europe?Middle east? Israel: 87.5 - 108)

But please do double check these before changing ;)

- Eero

