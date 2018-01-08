Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755097AbeAHVbt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 16:31:49 -0500
Date: Mon, 8 Jan 2018 22:31:09 +0100
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
To: "Josef Griebichler" <griebichler.josef@gmx.at>
Cc: "Mauro Carvalho Chehab" <mchehab@s-opensource.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>,
        "Rik van Riel" <riel@redhat.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hannes Frederic Sowa" <hannes@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180108223109.66c91554@redhat.com>
In-Reply-To: <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
References: <20180107090336.03826df2@vento.lan>
        <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
        <20180108074324.3c153189@vento.lan>
        <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Mon, 8 Jan 2018 17:26:10 +0100
"Josef Griebichler" <griebichler.josef@gmx.at> wrote:

> I tried your mentioned patch but unfortunately no real improvement for me.
> dmesg http://ix.io/DOg
> tvheadend service log http://ix.io/DOi
>
> Errors during recording are still there.

Are you _also_ recording the stream on the Raspberry Pi?

It seems to me, that you are expecting too much from this small device.

> Errors increase if there is additional tcp load on raspberry.

I did expected the issue to get worse, when you load the Pi with
network traffic, as now the softirq time-budget have to be shared
between networking and USB/DVB. Thus, I guess you are running TCP and
USB/mpeg2ts on the same CPU (why when you have 4 CPUs?...)

If you expect/want to get stable performance out of such a small box,
then you (or LibreELEC) need to tune the box for this usage.  And it
does not have to be that complicated.  First step is to move IRQ
handling for the NIC to another CPU and than the USB port handling the
DVB signal (/proc/irq/*/smp_affinity_list).  And then pin the
userspace process (taskset) to another CPU than the one handling
USB-softirq.

> Unfortunately there's no usbmon or tshark on libreelec so I can't
> provide further logs.

Do you have perf or trace-cmd on the box?  Maybe we could come up with
some kernel functions to trace, to measure/show the latency spikes?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
