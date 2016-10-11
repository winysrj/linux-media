Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43435
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbcJKKWm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:22:42 -0400
Date: Tue, 11 Oct 2016 07:12:04 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Michael Ira Krufky <mkrufky@linuxtv.org>,
        Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/26] Don't use stack for DMA transers on dvb-usb
 drivers
Message-ID: <20161011071204.6096efbb@vento.lan>
In-Reply-To: <CAOcJUbxv_jm4SVtPYpm=+jhFh_0cFx4-h_N8gZoQ9r2+nqULOg@mail.gmail.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
        <5e53e19c-80df-523f-2d93-5c94b80ba22d@iki.fi>
        <CAOcJUbxv_jm4SVtPYpm=+jhFh_0cFx4-h_N8gZoQ9r2+nqULOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Oct 2016 07:44:53 -0400
Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:

> Antti makes a very good point.  If we consider a situation where we
> are streaming data while concurrently checking frontend status and
> polling for IR codes, some locking will certainly be required in all
> of these drivers.
> 
> -Mike Krufky
> 
> On Mon, Oct 10, 2016 at 7:24 AM, Antti Palosaari <crope@iki.fi> wrote:
> > Hello
> > If you use usb buffers from the state you will need add lock in order to
> > protect concurrent access to buffer. There may have multiple concurrent
> > operations from rc-polling/demux/frontend. Lets say you are reading ber and
> > it sets data to buffer (state), then context switch to remote controller
> > polling => buffer in state is overwritten, then context is changed back to
> > ber reading and now there is bad data.

Indeed a mutex to protect it is required. I added it and re-submitted
the series, with a few extra patches, fixing issues on some drivers
that are outside dvb-usb.

Feel free to review.

Regards,
Mauro
