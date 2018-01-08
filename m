Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757718AbeAHWRO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 17:17:14 -0500
Date: Mon, 8 Jan 2018 23:16:56 +0100
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josef Griebichler <griebichler.josef@gmx.at>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        torvalds@linux-foundation.org
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180108231656.3bbd1968@redhat.com>
In-Reply-To: <20180108214427.GT29822@worktop.programming.kicks-ass.net>
References: <20180107090336.03826df2@vento.lan>
        <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
        <20180108074324.3c153189@vento.lan>
        <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
        <20180108223109.66c91554@redhat.com>
        <20180108214427.GT29822@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Jan 2018 22:44:27 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Jan 08, 2018 at 10:31:09PM +0100, Jesper Dangaard Brouer wrote:
> > I did expected the issue to get worse, when you load the Pi with
> > network traffic, as now the softirq time-budget have to be shared
> > between networking and USB/DVB. Thus, I guess you are running TCP and
> > USB/mpeg2ts on the same CPU (why when you have 4 CPUs?...)  
> 
> Isn't networking also over USB on the Pi ?

Darn, that is true. Looking at the dmesg output in http://ix.io/DOg:

[    0.405942] usbcore: registered new interface driver smsc95xx
[    5.821104] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0x45E1

I don't know enough about USB... is it possible to control which CPU
handles the individual USB ports, or on some other level (than ports)?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
