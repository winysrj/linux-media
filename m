Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59727 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab0FYSCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jun 2010 14:02:15 -0400
Received: by wwi17 with SMTP id 17so1264194wwi.19
        for <linux-media@vger.kernel.org>; Fri, 25 Jun 2010 11:02:13 -0700 (PDT)
Message-ID: <4C24EF40.6050107@gmail.com>
Date: Fri, 25 Jun 2010 20:02:40 +0200
From: fogna <fogna80@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Lubo=B9_Dole=BEel?= <lubos@dolezel.info>
CC: linux-media@vger.kernel.org,
	Heitmueller Devin <dheitmueller@kernellabs.com>,
	Adriano Gigante <adrigiga@yahoo.it>
Subject: Re: Support for 0ccd:0072 in em28xx?
References: <4C209063.7080504@dolezel.info>
In-Reply-To: <4C209063.7080504@dolezel.info>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/22/2010 12:28 PM, Lubo¹ Dole¾el wrote:
> Hello,
>
> I have a Terratec Cinergy XS Hybrid card [0ccd:0072] that used to be
> supported by the em28xx-new driver. The project has since been
> discontinued and the source code is unmaintained and incompatible with
> current kernels.
>
> Happens anyone to be working on supporting my model in the in-kernel
> em28xx? It seems my card is based on xc5000, which the current code
> doesn't take in to account :-(
>
> I don't care about analog/FM that much, DVB-T is what matters the most.
>
> Please CC me in response!
>
> Thanks,
> best regards,
> -- 
> Lubo¹ Dole¾el
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Hi Lubo¹, i have the same card and currently it's not supported, i have
contacted Terratec and a sample stick was donated for driver development
but from what i have understood it's not a priority for driver
developers... maybe one day we could see a driver but if you need dvb-t
on your pc quickly i think you should consider to buy a new fully
supported stick (i know it's crazy)... maybe Devin has some news about
the driver status and could answer our questions

bye!

