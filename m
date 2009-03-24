Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:39547 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762653AbZCXRNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 13:13:48 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2646308yxl.1
        for <linux-media@vger.kernel.org>; Tue, 24 Mar 2009 10:13:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C90BCC.1080401@gmx.de>
References: <49C90BCC.1080401@gmx.de>
Date: Tue, 24 Mar 2009 13:13:46 -0400
Message-ID: <412bdbff0903241013r479fbaabo8d7f45a7153aebb9@mail.gmail.com>
Subject: Re: [question] atsc and api v5
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: wk <handygewinnspiel@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 24, 2009 at 12:35 PM, wk <handygewinnspiel@gmx.de> wrote:
> While trying to update an application to API v5 some question arised.
>
> Which type of "delivery_system" should be set for ATSC?
> <frontend.h> says...
>
> SYS_DVBC_ANNEX_AC,   <- european DVB-C
> SYS_DVBC_ANNEX_B,      <- american ATSC QAM
> ..
> SYS_ATSC,   <- oops, here we have ATSC again, cable and terrestrial not
> named? Is this VSB *only*?
>
>
>
> Which one should i choose, "SYS_ATSC" for both (VSB and QAM),
> or should i choose SYS_DVBC_ANNEX_B for ATSC cable and SYS_ATSC for VSB?
>
> thanks,
> Winfried

I'm pretty sure it's SYS_ATSC for both VSB and QAM.

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
