Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38551 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2GVSKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jul 2012 14:10:25 -0400
Received: by wibhr14 with SMTP id hr14so2166788wib.1
        for <linux-media@vger.kernel.org>; Sun, 22 Jul 2012 11:10:24 -0700 (PDT)
Message-ID: <1342980610.2710.8.camel@router7789>
Subject: Re: AVerMedia A373 PCIe MiniCard Dual DVB-T - ITE IT913x Tuners
From: Malcolm Priestley <tvboxspy@gmail.com>
To: John Layt <jlayt@kde.org>
Cc: linux-media@vger.kernel.org
Date: Sun, 22 Jul 2012 19:10:10 +0100
In-Reply-To: <CAM1DM6m=WC4DjuhO6AkdZ6VjFphm9gvX41kYmcbykfoKvB3BMw@mail.gmail.com>
References: <CAM1DM6m=WC4DjuhO6AkdZ6VjFphm9gvX41kYmcbykfoKvB3BMw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2012-07-22 at 17:34 +0100, John Layt wrote:
> Hi,
> 
> I have recently purchased an Acer Aspire Revo RL70 HTPC which comes
> with a built-in "AVerMedia A373 MiniCard Dual DVB-T" which uses two
> ITE T913x tuners.  This card is currently unsupported in Linux and I
> have documented some details on the wiki at
> http://linuxtv.org/wiki/index.php/AVerMedia_A373_MiniCard_Dual_DVB-T .
>  I have a photo that I can upload once approved, and I also have
> Windows 7 installed on the machine so can provide details from there
> if needed.  If anyone is interested in adding support I'd be happy to
> help out where I can.

Hi John

It looks like the IT9137 is the Host Interface which is supported, the
IT9133 is the slave.

The only problem I can see is the slave many not work correctly as
another IT9137 is used as slave on other models.

I will do a little patch shortly to add the ID to the it913x driver.

Regards


Malcolm



