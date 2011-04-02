Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40311 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1DBMsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 08:48:05 -0400
Received: by wya21 with SMTP id 21so3616891wya.19
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2011 05:48:03 -0700 (PDT)
Subject: Re: [PATCH] v1.82 DM04/QQBOX dvb-usb-lmedm04 diseqc timing changes
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <1301182168.7060.5.camel@localhost>
References: <1301182168.7060.5.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Apr 2011 13:47:55 +0100
Message-ID: <1301748475.7763.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-03-26 at 23:29 +0000, Malcolm Priestley wrote:
> Frontend timing change for diseqc functions.
> 
> Timing on the STV0288 and STV0299 frontends cause initial disegc errors
> on some applications.
> 
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/dvb/dvb-usb/lmedm04.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 

A bug has been found in a stv0288 register, v1.82 is now withdrawn
pending changes.  

