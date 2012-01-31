Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37812 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152Ab2AaKDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 05:03:13 -0500
Subject: Re: [PATCH 05/16] cx18: fix handling of 'radio' module parameter
From: Andy Walls <awalls@md.metrocast.net>
To: Danny Kukawka <danny.kukawka@bisect.de>,
	Rusty Russell <rusty@rustcorp.com.au>, mchehab@redhat.com
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 31 Jan 2012 05:01:59 -0500
In-Reply-To: <1327952458-7424-6-git-send-email-danny.kukawka@bisect.de>
References: <1327952458-7424-1-git-send-email-danny.kukawka@bisect.de>
	 <1327952458-7424-6-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <1328004120.2821.8.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-01-30 at 20:40 +0100, Danny Kukawka wrote:
> Fixed handling of 'radio' module parameter from module_param_array
> to module_param_named to fix these compiler warnings in cx18-driver.c:

NACK.

"radio" is an array of tristate values (-1, 0, 1) per installed card:

	static int radio[CX18_MAX_CARDS] = { -1, -1,

and must remain an array or you will break the driver.

Calling "radio_c" a module parameter named "radio" is wrong.

The correct fix is to reverse Rusty Russel's patch to the driver in
commit  90ab5ee94171b3e28de6bb42ee30b527014e0be7
to change the "bool" back to an "int" as it should be in
"module_param_array(radio, ...)"

Regards,
Andy

> In function ‘__check_radio’:
> 113:1: warning: return from incompatible pointer type [enabled by default]
> At top level:
> 113:1: warning: initialization from incompatible pointer type [enabled by default]
> 113:1: warning: (near initialization for ‘__param_arr_radio.num’) [enabled by default]
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/media/video/cx18/cx18-driver.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
> index 349bd9c..27b5330 100644
> --- a/drivers/media/video/cx18/cx18-driver.c
> +++ b/drivers/media/video/cx18/cx18-driver.c
> @@ -110,7 +110,7 @@ static int retry_mmio = 1;
>  int cx18_debug;
>  
>  module_param_array(tuner, int, &tuner_c, 0644);
> -module_param_array(radio, bool, &radio_c, 0644);
> +module_param_named(radio, radio_c, bool, 0644);
>  module_param_array(cardtype, int, &cardtype_c, 0644);
>  module_param_string(pal, pal, sizeof(pal), 0644);
>  module_param_string(secam, secam, sizeof(secam), 0644);


