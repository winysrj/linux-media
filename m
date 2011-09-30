Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52884 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1I3Ony (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 10:43:54 -0400
Received: by ywb5 with SMTP id 5so1553072ywb.19
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 07:43:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E85AF12.1000700@infradead.org>
References: <201109281350.52099.simon.farnsworth@onelan.com>
	<4E859E74.7080900@infradead.org>
	<201109301203.36370.simon.farnsworth@onelan.co.uk>
	<4E85AF12.1000700@infradead.org>
Date: Fri, 30 Sep 2011 10:43:53 -0400
Message-ID: <CAGoCfizt-9E_kiheuojrXNNbP46FF+wV=dtQ7QwPEa3szenKBQ@mail.gmail.com>
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner)
 - workaround hack included
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	LMML <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 30, 2011 at 7:59 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Michael/Devin may be able to double check what tda18271 variants are used at the
> hvr1100 supported models.

Mike could confirm definitively but I would be very surprised if it
was anything other than a C2.  I also don't think we've had multiple
revisions of that board (other than the ones in the list which were
all released at the same time and are just different population
options).

All that said, I also wonder if perhaps this is an issue with the
analog demod as opposed to the tuner.  It feels unlikely but that
might explain why I didn't see similar results when I did the testing
on the cx231xx/tda18271 combo back in February.

The big problem here really though is that somebody who is
knowledgeable of the driver internals needs to dig into the issue, and
I don't foresee that happening in the immediate future (I cannot speak
for Michael but I've been too tied up in other projects).  I'm
definitely not discounting Simon's skills or findings, but this needs
to be investigated in a context beyond the tuner/demod combination
found on a single product.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
