Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:33045 "EHLO
	mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbcF2Etc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 00:49:32 -0400
Received: by mail-qt0-f172.google.com with SMTP id c34so19208438qte.0
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 21:49:32 -0700 (PDT)
Received: from mail-qt0-f174.google.com (mail-qt0-f174.google.com. [209.85.216.174])
        by smtp.gmail.com with ESMTPSA id g15sm997928qtc.17.2016.06.28.21.42.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2016 21:42:47 -0700 (PDT)
Received: by mail-qt0-f174.google.com with SMTP id c34so19154477qte.0
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 21:42:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5772DC68.9050600@kaa.org.ua>
References: <5772DC68.9050600@kaa.org.ua>
From: Olli Salonen <olli.salonen@iki.fi>
Date: Wed, 29 Jun 2016 07:42:46 +0300
Message-ID: <CAAZRmGwCeKQnLU7xFH2TDwhWorzcxRQDT1-pSi97h7VxZFG_KQ@mail.gmail.com>
Subject: Re: si2157 driver
To: Oleh Kravchenko <oleg@kaa.org.ua>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oleg,

Correct, only digital TV is supported currently by the driver.

Cheers,
-olli

On 28 June 2016 at 23:22, Oleh Kravchenko <oleg@kaa.org.ua> wrote:
> Hello linux media developers!
>
> I try add support for usb hybrid tuner, it based on:
> CX23102-112, Si2158, Si2168
>
> I updated cx231xx-cards.c with valid ids, but I don't have idea how to
> use Si2158.
> It is not listed in tuner-types.c
>
> Why si2157.c is absent in tuner-types.c?
> Or at the current state si2157.c don't have analog support?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
