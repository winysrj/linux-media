Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47649 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbeDFPzw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 11:55:52 -0400
Message-ID: <1523030150.32493.2.camel@pengutronix.de>
Subject: Re: [PATCH] media: coda: do not try to propagate format if capture
 queue busy
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sasha Hauer <kernel@pengutronix.de>
Date: Fri, 06 Apr 2018 17:55:50 +0200
In-Reply-To: <CAAFQd5DAm4G23H32OsbNQxZGLKSTaEw2gt4bM6G0cmJ6NMyKkw@mail.gmail.com>
References: <20180328171243.28599-1-p.zabel@pengutronix.de>
         <CAAFQd5DAm4G23H32OsbNQxZGLKSTaEw2gt4bM6G0cmJ6NMyKkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Tue, 2018-04-03 at 10:13 +0000, Tomasz Figa wrote:
> Hi Philipp,
> 
> On Thu, Mar 29, 2018 at 2:12 AM Philipp Zabel <p.zabel@pengutronix.de>
> wrote:
> 
> > The driver helpfully resets the capture queue format and selection
> > rectangle whenever output format is changed. This only works while
> > the capture queue is not busy.
> 
> Is the code in question used only for decoder case? For encoder, CAPTURE
> queue determines the codec and so things should work the other way around,
> i.e. setting CAPTURE format should reset OUTPUT format and it should be
> allowed only if OUTPUT queue is not busy.

thank you for the comment, this code is indeed also used for the encoder
 device. I'll fix this in the next round.

regards
Philipp
