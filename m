Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab1G0SbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 14:31:01 -0400
Message-ID: <4E305962.4090208@redhat.com>
Date: Wed, 27 Jul 2011 15:30:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] IT9137 driver for Kworld UB499-2T T09 (id 1b80:e409)
 - firmware details
References: <1311618885.7655.3.camel@localhost>
In-Reply-To: <1311618885.7655.3.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-07-2011 15:34, Malcolm Priestley escreveu:
> Firmware information for Kworld UB499-2T T09 based on IT913x series. This device
> uses file dvb-usb-it9137-01.fw.
> 
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> 
> ---
>  Documentation/dvb/it9137.txt |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/dvb/it9137.txt
> 
> diff --git a/Documentation/dvb/it9137.txt b/Documentation/dvb/it9137.txt
> new file mode 100644
> index 0000000..9e6726e
> --- /dev/null
> +++ b/Documentation/dvb/it9137.txt
> @@ -0,0 +1,9 @@
> +To extract firmware for Kworld UB499-2T (id 1b80:e409) you need to copy the
> +following file(s) to this directory.
> +
> +IT9135BDA.sys Dated Mon 22 Mar 2010 02:20:08 GMT
> +
> +extract using dd
> +dd if=IT9135BDA.sys ibs=1 skip=69632 count=5731 of=dvb-usb-it9137-01.fw
> +
> +copy to default firmware location.


Malcolm,

You should add a rule like the above at:
	Documentation/dvb/get_dvb_firmware

if you cannot get the distribution rights for such firmware.

Thanks,
Mauro
