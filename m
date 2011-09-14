Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49747 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab1INGZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 02:25:19 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id D9E569400F2
	for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 08:25:11 +0200 (CEST)
Date: Wed, 14 Sep 2011 08:25:13 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Question about USB interface index restriction in gspca
Message-ID: <20110914082513.574baac2@tele>
In-Reply-To: <4E6FAB94.2010007@googlemail.com>
References: <4E6FAB94.2010007@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Sep 2011 21:14:28 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> wrote:

> I have a question about the following code in gspca.c:
> 
> in function gspca_dev_probe(...):
>      ...
>      /* the USB video interface must be the first one */
>      if (dev->config->desc.bNumInterfaces != 1
> && intf->cur_altsetting->desc.bInterfaceNumber != 0)
>              return -ENODEV;
>      ...
> 
> Is there a special reason for not allowing devices with USB interface 
> index > 0 for video ?
> I'm experimenting with a device that has the video interface at index 3 
> and two audio interfaces at index 0 and 1 (index two is missing !).
> And the follow-up question: can we assume that all device handled by the 
> gspca-driver have vendor specific video interfaces ?
> Then we could change the code to
> 
>      ...
>      /* the USB video interface must be of class vendor */
>      if (intf->cur_altsetting->desc.bInterfaceClass != 
> USB_CLASS_VENDOR_SPEC)
>              return -ENODEV;
>       ...

Hi Frank,

For webcam devices, the interface class is meaningful only when set to
USB_CLASS_VIDEO (UVC). Otherwise, I saw many different values.

For video on a particular interface, the subdriver must call the
function gspca_dev_probe2() as this is done in spca1528 and xirlink_cit.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
