Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41108 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933380AbeAMKqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Jan 2018 05:46:32 -0500
Date: Sat, 13 Jan 2018 08:46:22 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180113084622.345a1223@vento.lan>
In-Reply-To: <20180113070920.4453eafe@vento.lan>
References: <20180107090336.03826df2@vento.lan>
        <Pine.LNX.4.44L0.1801071010540.13425-100000@netrider.rowland.org>
        <20180108074324.3c153189@vento.lan>
        <trinity-c7ec7cbd-a186-4a2a-bcb6-cce8993d6a90-1515428770628@3c-app-gmx-bs32>
        <20180108223109.66c91554@redhat.com>
        <20180108214427.GT29822@worktop.programming.kicks-ass.net>
        <20180108231656.3bbd1968@redhat.com>
        <trinity-920967ce-ab0f-4535-8557-f82a7e667a79-1515516669310@3c-app-gmx-bs24>
        <CANn89iJqRH4uzFJVKyPxc8dN38z319C1O18nTJ-CCidtuOH2+g@mail.gmail.com>
        <CA+55aFzcoNEpnRp0R3fLYQKdfzS5mLj3z_v=1A1NfyrybQ__4A@mail.gmail.com>
        <20180112191343.3083b70e@vento.lan>
        <1515793726.3606.1.camel@gmail.com>
        <20180113070920.4453eafe@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 13 Jan 2018 07:09:20 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Fri, 12 Jan 2018 13:48:46 -0800
> Eric Dumazet <eric.dumazet@gmail.com> escreveu:
> 
> > On Fri, 2018-01-12 at 19:13 -0200, Mauro Carvalho Chehab wrote:
> > > 
> > > 
> > > The .config file used to build the Kernel is at:
> > > 	https://pastebin.com/wpZghann
> > > 
> > 
> > Hi Mauro
> > 
> > Any chance you can try CONFIG_HZ_1000=y, CONFIG_HZ=1000 ?

It actually made it a lot worse! without Linus patch (or reverting the
softirq patch), on a 4 minutes of capture, it got all those errors:

Jan 13 10:41:41 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: H264 @ #1911 Continuity counter error (total 1)
Jan 13 10:41:42 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: MPEG2AUDIO @ #1912 Continuity counter error (total 1)
Jan 13 10:42:14 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: H264 @ #1911 Continuity counter error (total 3)
Jan 13 10:42:47 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: H264 @ #1911 Continuity counter error (total 4)
Jan 13 10:42:58 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: H264 @ #1911 Continuity counter error (total 5)
Jan 13 10:42:58 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: MPEG2AUDIO @ #1912 Continuity counter error (total 2)
Jan 13 10:43:34 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: H264 @ #1911 Continuity counter error (total 9)
Jan 13 10:43:37 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: MPEG2AUDIO @ #1912 Continuity counter error (total 5)
Jan 13 10:44:00 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: H264 @ #1911 Continuity counter error (total 12)
Jan 13 10:44:29 rpi3 tvheadend[226]: TS: DVB-S Network/12130H/NBR: H264 @ #1911 Continuity counter error (total 13)

Thanks,
Mauro
