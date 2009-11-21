Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4136 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZKUAxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 19:53:07 -0500
Message-ID: <4B0739F5.4090403@linuxtv.org>
Date: Fri, 20 Nov 2009 19:53:09 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L/DVB: Fix test in copy_reg_bits()
References: <4B06E125.6090305@gmail.com>
In-Reply-To: <4B06E125.6090305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ah!  Nice catch.  Thank you, Roel.  Mauro / Andrew, can one of you 
please merge this?  The driver hasn't changed, so it should go to Linus' 
current tree and also stable, although it isn't crucial.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

Roel Kluin wrote:
> The reg_pair2[j].reg was tested twice.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/media/common/tuners/mxl5007t.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> I think this was intended?
> 
> diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
> index 2d02698..7eb1bf7 100644
> --- a/drivers/media/common/tuners/mxl5007t.c
> +++ b/drivers/media/common/tuners/mxl5007t.c
> @@ -196,7 +196,7 @@ static void copy_reg_bits(struct reg_pair_t *reg_pair1,
>  	i = j = 0;
>  
>  	while (reg_pair1[i].reg || reg_pair1[i].val) {
> -		while (reg_pair2[j].reg || reg_pair2[j].reg) {
> +		while (reg_pair2[j].reg || reg_pair2[j].val) {
>  			if (reg_pair1[i].reg != reg_pair2[j].reg) {
>  				j++;
>  				continue;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

