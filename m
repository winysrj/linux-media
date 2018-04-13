Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42767 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753254AbeDMOIK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Apr 2018 10:08:10 -0400
Date: Fri, 13 Apr 2018 11:08:03 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 15/17] media: st_rc: Don't stay on an IRQ handler
 forever
Message-ID: <20180413110803.0599eb2a@vento.lan>
In-Reply-To: <20180413132052.37fudkaxltvwc46v@gofer.mess.org>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
        <16b1993cde965edc096f0833091002dd05d4da7f.1523546545.git.mchehab@s-opensource.com>
        <20180412222132.z7g5enhin2uodbk7@gofer.mess.org>
        <20180413060646.25b8a19d@vento.lan>
        <20180413094005.wudyd2y5efaeimg3@gofer.mess.org>
        <20180413070050.10d0de84@vento.lan>
        <20180413132052.37fudkaxltvwc46v@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Apr 2018 14:20:52 +0100
Sean Young <sean@mess.org> escreveu:

> On Fri, Apr 13, 2018 at 07:00:50AM -0300, Mauro Carvalho Chehab wrote:
> > Yeah, we could limit it to run only 512 times (or some other reasonable
> > quantity), but in order to do that, we need to be sure that, on each read(),
> > the FIFO will shift - e. g. no risk of needing to do more than one read
> > to get the next element. That would work if the FIFO is implemented via
> > flip-flops. But if it is implemented via some slow memory, or if the
> > shift logic is implemented via some software on a micro-controller, it
> > may need a few interactions to get the next value.
> > 
> > Without knowing about the hardware implementation, I'd say that setting
> > a max time for the whole FIFO interaction is safer.  
> 
> Ok. If the 10ms timeout is reached, there really is a problem; should we
> report an error in this case?

Maybe, but then it should likely warn only once.


Thanks,
Mauro
