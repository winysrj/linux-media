Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38412 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1756430AbeAHTPg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 14:15:36 -0500
Date: Mon, 8 Jan 2018 14:15:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>
Subject: Re: dvb usb issues since kernel 4.9
In-Reply-To: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Jan 2018, Linus Torvalds wrote:

> Can somebody tell which softirq it is that dvb/usb cares about?

I don't know about the DVB part.  The USB part is a little difficult to
analyze, mostly because the bug reports I've seen are mostly from
people running non-vanilla kernels.  For example, Josef is using a
Raspberry Pi 3B with a non-standard USB host controller driver:
dwc_otg_hcd is built into raspbian in place of the normal dwc2_hsotg
driver.

Both dwc2_hsotg and ehci-hcd use the tasklets embedded in the 
giveback_urb_bh member of struct usb_hcd.  See usb_hcd_giveback_urb() 
in drivers/usb/core/hcd.c; the calls are

        else if (high_prio_bh)
                tasklet_hi_schedule(&bh->bh);
        else
                tasklet_schedule(&bh->bh);

As it turns out, high_prio_bh gets set for interrupt and isochronous
URBs but not for bulk and control URBs.  The DVB driver in question
uses bulk transfers.

xhci-hcd, on the other hand, does not use these tasklets (it doesn't
set the HCD_BH bit in the hc_driver's .flags member).

Alan Stern
