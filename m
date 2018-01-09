Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49436 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755925AbeAIQvz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 11:51:55 -0500
MIME-Version: 1.0
Message-ID: <trinity-920967ce-ab0f-4535-8557-f82a7e667a79-1515516669310@3c-app-gmx-bs24>
From: "Josef Griebichler" <griebichler.josef@gmx.at>
To: "Jesper Dangaard Brouer" <jbrouer@redhat.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>,
        "Mauro Carvalho Chehab" <mchehab@s-opensource.com>,
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
        "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org
Subject: Aw: Re: dvb usb issues since kernel 4.9
Content-Type: text/plain; charset=UTF-8
Date: Tue, 9 Jan 2018 17:51:09 +0100
In-Reply-To: <20180108231656.3bbd1968@redhat.com>
References: <20180107090336.03826df2@vento.lan>
 <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
 <20180108074324.3c153189@vento.lan>
 <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
 <20180108223109.66c91554@redhat.com>
 <20180108214427.GT29822@worktop.programming.kicks-ass.net>
 <20180108231656.3bbd1968@redhat.com>
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

your patch works very good for me and others (please see https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=77006#post77006). No errors in recordings any more.
The patch was also tested on x86_64 (Revo 3700) with positive effect.
I agree with the forum poster, that there's still an issue when recording and watching livetv at same time. I also get audio dropouts and audio is out of sync.
According to user smp kernel 4.9.73 with your patch on rpi and according to user jahutchi kernel 4.11.12 on x86_64 have no such issues.
I don't know if this dropouts are related to this topic.

If of any help I could provide perf output on raspberry with libreelec and tvheadend.

Regards,
Josef 
 

Gesendet: Montag, 08. Januar 2018 um 23:16 Uhr
Von: "Jesper Dangaard Brouer" <jbrouer@redhat.com>
An: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Josef Griebichler" <griebichler.josef@gmx.at>, "Mauro Carvalho Chehab" <mchehab@s-opensource.com>, "Alan Stern" <stern@rowland.harvard.edu>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>, "Rik van Riel" <riel@redhat.com>, "Paolo Abeni" <pabeni@redhat.com>, "Hannes Frederic Sowa" <hannes@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, LMML <linux-media@vger.kernel.org>, "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org
Betreff: Re: dvb usb issues since kernel 4.9
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

[ 0.405942] usbcore: registered new interface driver smsc95xx
[ 5.821104] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0x45E1

I don't know enough about USB... is it possible to control which CPU
handles the individual USB ports, or on some other level (than ports)?

--
Best regards,
Jesper Dangaard Brouer
MSc.CS, Principal Kernel Engineer at Red Hat
LinkedIn: http://www.linkedin.com/in/brouer[http://www.linkedin.com/in/brouer]
