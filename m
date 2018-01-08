Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37484 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1752805AbeAHRfJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 12:35:09 -0500
Date: Mon, 8 Jan 2018 12:35:08 -0500 (EST)
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
Subject: Re: Aw: Re:  Re: dvb usb issues since kernel 4.9
In-Reply-To: <trinity-d42aadc3-e83a-4e22-9c98-011ab0bffcf3-1515431701061@3c-app-gmx-bs43>
Message-ID: <Pine.LNX.4.44L0.1801081227540.1908-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Jan 2018, Josef Griebichler wrote:

> No I can't sorry. There's no sat connection near to my workstation.

Can we ask the person who made this post:

https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=75965#post75965

to run the test?  The post says that the testing was done on an x86_64 
machine.

> Gesendet: Montag, 08. Januar 2018 um 17:31 Uhr
> Von: "Alan Stern" <stern@rowland.harvard.edu>
> An: "Josef Griebichler" <griebichler.josef@gmx.at>
> Cc: "Mauro Carvalho Chehab" <mchehab@s-opensource.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>, "Rik van Riel" <riel@redhat.com>, "Paolo Abeni" <pabeni@redhat.com>, "Hannes Frederic Sowa" <hannes@redhat.com>, "Jesper Dangaard Brouer" <jbrouer@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, LMML <linux-media@vger.kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org
> Betreff: Re: Aw: Re: dvb usb issues since kernel 4.9
> On Mon, 8 Jan 2018, Josef Griebichler wrote: > Hi Maro, > > I tried your mentioned patch but unfortunately no real improvement for me. > dmesg http://ix.io/DOg > tvheadend service log http://ix.io/DOi[http://ix.io/DOi] > Errors during recording are still there. > Errors increase if there is additional tcp load on raspberry. > > Unfortunately there's no usbmon or tshark on libreelec so I can't provide further logs. Can you try running the same test on an x86_64 system? Alan Stern

It appears that you are using a non-standard kernel.  The vanilla 
kernel does not include any "dwc_otg_hcd" driver.

Alan Stern
