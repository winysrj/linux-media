Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37294 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1757097AbeAHQbM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 11:31:12 -0500
Date: Mon, 8 Jan 2018 11:31:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Josef Griebichler <griebichler.josef@gmx.at>
cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        <torvalds@linux-foundation.org>
Subject: Re: Aw: Re: dvb usb issues since kernel 4.9
In-Reply-To: <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
Message-ID: <Pine.LNX.4.44L0.1801081130200.1908-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Jan 2018, Josef Griebichler wrote:

> Hi Maro,
> 
> I tried your mentioned patch but unfortunately no real improvement for me.
> dmesg http://ix.io/DOg
> tvheadend service log http://ix.io/DOi
> Errors during recording are still there.
> Errors increase if there is additional tcp load on raspberry.
> 
> Unfortunately there's no usbmon or tshark on libreelec so I can't provide further logs.

Can you try running the same test on an x86_64 system?

Alan Stern
