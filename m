Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33543 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965839AbdEOUY3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 16:24:29 -0400
Received: by mail-oi0-f52.google.com with SMTP id w10so1420049oif.0
        for <linux-media@vger.kernel.org>; Mon, 15 May 2017 13:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF_dkJCmY-n_0MdceZGXRA5fuPuMCg395Ct8x8WGRF+QCAp1eg@mail.gmail.com>
References: <CAF_dkJB=2PNbD79msw=G47U-6QkajDOWwLJbr3pCaTQeqn=fXA@mail.gmail.com>
 <CAL8zT=jwVquxzvnieVA2njSTdL98mOt+n=oy=Nb8ptXdBbJ-1w@mail.gmail.com> <CAF_dkJCmY-n_0MdceZGXRA5fuPuMCg395Ct8x8WGRF+QCAp1eg@mail.gmail.com>
From: Patrick Doyle <wpdster@gmail.com>
Date: Mon, 15 May 2017 16:23:58 -0400
Message-ID: <CAF_dkJABcAgHzEVOwg7AQHK1+5n2TqJy2tCsOdUp-QC6qO1SFQ@mail.gmail.com>
Subject: Re: Is it possible to have a binary blob custom control?
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another possible mis-abuse of a binary blob control would be as a
mechanism for retrieving a lumanance histogram from an image
processing peripheral.  Once again, I could implement that through the
debugfs as Jean-Michel suggested, or I could do something more
standard.

Any suggestions for a "more standard" mechanism for retrieving
out-of-band data (such as a histogram) from a V4L2 camera source?

I guess, now that I have mentioned out-of-band data, I could also
start thinking about the "embedded data lines" that are provided as
the first two lines from my Sony imager.  Is there any standard way
for directing those two lines to a separate buffer?

I'd rather ask silly sounding questions, than implement silly code. :-)

--wpd
