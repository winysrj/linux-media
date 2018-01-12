Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:40499 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965133AbeALVst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 16:48:49 -0500
Message-ID: <1515793726.3606.1.camel@gmail.com>
Subject: Re: dvb usb issues since kernel 4.9
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>
Cc: Josef Griebichler <griebichler.josef@gmx.at>,
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
Date: Fri, 12 Jan 2018 13:48:46 -0800
In-Reply-To: <20180112191343.3083b70e@vento.lan>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-01-12 at 19:13 -0200, Mauro Carvalho Chehab wrote:
> 
> 
> The .config file used to build the Kernel is at:
> 	https://pastebin.com/wpZghann
> 

Hi Mauro

Any chance you can try CONFIG_HZ_1000=y, CONFIG_HZ=1000 ?

Thanks.
