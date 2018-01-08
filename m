Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64610 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756664AbeAHRPj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 12:15:39 -0500
MIME-Version: 1.0
Message-ID: <trinity-d42aadc3-e83a-4e22-9c98-011ab0bffcf3-1515431701061@3c-app-gmx-bs43>
From: "Josef Griebichler" <griebichler.josef@gmx.at>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Mauro Carvalho Chehab" <mchehab@s-opensource.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>,
        "Rik van Riel" <riel@redhat.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hannes Frederic Sowa" <hannes@redhat.com>,
        "Jesper Dangaard Brouer" <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org
Subject: Aw: Re:  Re: dvb usb issues since kernel 4.9
Content-Type: text/plain; charset=UTF-8
Date: Mon, 8 Jan 2018 18:15:01 +0100
In-Reply-To: <Pine.LNX.4.44L0.1801081130200.1908-100000@iolanthe.rowland.org>
References: <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
 <Pine.LNX.4.44L0.1801081130200.1908-100000@iolanthe.rowland.org>
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No I can't sorry. There's no sat connection near to my workstation.
 
 

Gesendet: Montag, 08. Januar 2018 um 17:31 Uhr
Von: "Alan Stern" <stern@rowland.harvard.edu>
An: "Josef Griebichler" <griebichler.josef@gmx.at>
Cc: "Mauro Carvalho Chehab" <mchehab@s-opensource.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>, "Rik van Riel" <riel@redhat.com>, "Paolo Abeni" <pabeni@redhat.com>, "Hannes Frederic Sowa" <hannes@redhat.com>, "Jesper Dangaard Brouer" <jbrouer@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, LMML <linux-media@vger.kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org
Betreff: Re: Aw: Re: dvb usb issues since kernel 4.9
On Mon, 8 Jan 2018, Josef Griebichler wrote: > Hi Maro, > > I tried your mentioned patch but unfortunately no real improvement for me. > dmesg http://ix.io/DOg > tvheadend service log http://ix.io/DOi[http://ix.io/DOi] > Errors during recording are still there. > Errors increase if there is additional tcp load on raspberry. > > Unfortunately there's no usbmon or tshark on libreelec so I can't provide further logs. Can you try running the same test on an x86_64 system? Alan Stern
