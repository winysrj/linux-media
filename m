Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:53895 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbZJOJ0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 05:26:02 -0400
Received: by fxm27 with SMTP id 27so830669fxm.17
        for <linux-media@vger.kernel.org>; Thu, 15 Oct 2009 02:25:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23582ca0910140629g57366f4aq4c2e07462d9f18ef@mail.gmail.com>
References: <23582ca0910140629g57366f4aq4c2e07462d9f18ef@mail.gmail.com>
Date: Thu, 15 Oct 2009 11:25:25 +0200
Message-ID: <23582ca0910150225w362af3a0m69c0be862f09cb9f@mail.gmail.com>
Subject: Re: Request driver for cards
From: Theunis Potgieter <theunis.potgieter@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/10/2009, Theunis Potgieter <theunis.potgieter@gmail.com> wrote:
> Hi, what is the procedure to request drivers for specific new, perhaps
>  unknown supported cards?
>
>  I did have a look at http://www.linuxtv.org/wiki/index.php/Main_Page
>  but it didn't contain any information about supported cards. Neither
>  did 2.6.30 /usr/src/linux/Documentation/dvb/cards.txt for the
>  following brands:
>
>  name, site:
>  Compro, S300 http://www.comprousa.com/en/product/s300/s300.html
>  K-World VS-DVB-S 100/IS,
>  http://global.kworld-global.com/main/prod_in.aspx?mnuid=1248&modid=6&pcid=46&ifid=16&prodid=98
>
>  Perhaps I shouldn't waste time if I could find a dual/twin tuner card
>  for dvb-s or dvb-s2. Are there any recommended twin-tuner pci-e cards
>  that is support and can actually be bought by the average consumer?
>
>  Thanks
>
I guess this answers the Kworld on 2.6.30:

/usr/src/linux/drivers/media/dvb/frontends/cx24123.c: *   Support for
KWorld DVB-S 100 by Vadim Catana <skystar@moldova.cc>

But how would I get compro S300 support?

Is there anybody that knows of a work inprogress or completed twin
tuner type card in either pci or pci-e format?

Thanks in advance.
