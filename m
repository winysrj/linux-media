Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:53117 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZEDQhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 12:37:31 -0400
Received: by gxk10 with SMTP id 10so7987168gxk.13
        for <linux-media@vger.kernel.org>; Mon, 04 May 2009 09:37:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49FF1892.7040109@forseth.name>
References: <49FF1892.7040109@forseth.name>
Date: Mon, 4 May 2009 12:37:31 -0400
Message-ID: <412bdbff0905040937k10869c91ydec578fdda6b178@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle pctv hybrid pro stick 340e support
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: "Lars D. Forseth" <lars@forseth.name>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 4, 2009 at 12:32 PM, Lars D. Forseth <lars@forseth.name> wrote:
> Hello,
>
> I have a Pinnacle PCTV Hybrid Stick Solo 340e SE which identifies as
> "2304:023e" with lsusb.
> After searching the web for almost two days now I did not find any working
> solution in getting this DVB-T USB stick to work under Ubuntu 9.04 UNR. When
> I found this thread (http://marc.info/?l=linux-dvb&w=2&r=1&s=340e&q=b) and
> started reading it I hoped that I would find a hint or something, but it
> seems that the last post was on 2008-08-22? Were there any improvements in
> getting this card to work since then? I would really appreciate any help in
> getting this card to work under Ubuntu UNR 9.04 on my Acer Aspire One...
>
>
> Thanks in advance and best regards,
> Lars.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello Lars,

The status on this is unchanged.  I've got the xc4000 driver specs,
but I don't have the hardware so I cannot write the driver.

If somebody wants to ship me a 340e, I can probably get it to work (I
did the other Pinnacle variants that use dib0700/xc5000).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
