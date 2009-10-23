Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59003 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZJWQIU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 12:08:20 -0400
Received: by fxm18 with SMTP id 18so10454932fxm.37
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 09:08:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091023174502.0608cd4e@rechenknecht2k7>
References: <20091023174502.0608cd4e@rechenknecht2k7>
Date: Fri, 23 Oct 2009 12:08:22 -0400
Message-ID: <829197380910230908p733ee69bt79043b78ca5ad81f@mail.gmail.com>
Subject: Re: pinnacle pctv 7010ix and saa716x
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 23, 2009 at 11:45 AM, Benjamin Valentin
<benpicco@zedat.fu-berlin.de> wrote:
> Hello,
> I have a Pinnacle pctv 7010ix that is oddly recognized as a Pinnacle
> PCTV 3010iX [1].
> I found that the SAA7162 chip used in that device is supported while
> the device itself is not. I was a bit confused wich of the various
> repositories I encountered reflects the latest version of development,
> however, none of the linux/drivers/media/video/saa7164/saa7164-cards.c
> contained a string referring to said pinnacle card.
> It seems like the only obstacle that keeps the card from working is the
> missing configuration for the board - how does one figure out that?
> I would like to get some hints on how to determine necessary
> configuration or test some.

You cannot use a saa7162 based device with the saa7164 driver.  They
chipsets are too dissimilar.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
