Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57260 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031722AbeBPQ1f (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 11:27:35 -0500
Date: Fri, 16 Feb 2018 08:27:31 -0800
From: Tony Lindgren <tony@atomide.com>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: linux-usb@vger.kernel.org, Bin Liu <b-liu@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [BUG] musb: broken isochronous transfer at TI AM335x platform
Message-ID: <20180216162730.GG6359@atomide.com>
References: <CAJs94EZhV7-3Ra5zqZNfz07xu2n1xeHQLV3BQpOPqPp+0YydGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJs94EZhV7-3Ra5zqZNfz07xu2n1xeHQLV3BQpOPqPp+0YydGw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Matwey V. Kornilov <matwey@sai.msu.ru> [180215 17:55]:
>     [        ]   7.219456 d=  0.000997 [181.0 +  3.667] [  3] IN   : 4.5
>     [    T   ]   7.219459 d=  0.000003 [181.0 +  7.083] [800] DATA0: 53 da ...
>     [        ]   7.220456 d=  0.000997 [182   +  3.667] [  3] IN   : 4.5
>     [    T   ]   7.220459 d=  0.000003 [182   +  7.000] [800] DATA0: 13 36 ...
>     [        ]   7.222456 d=  0.001997 [184   +  3.667] [  3] IN   : 4.5
>     [        ]   7.222459 d=  0.000003 [184   +  7.000] [  3] DATA0: 00 00
>     [        ]   7.223456 d=  0.000997 [185.0 +  3.667] [  3] IN   : 4.5
>     [        ]   7.223459 d=  0.000003 [185.0 +  7.000] [  3] DATA0: 00 00
> 
> Please note, that the time moment "7.221456" has missed IN request
> packet which must be sent out every 1ms in this low-speed USB case.
> Then, all incoming packets became empty ones. Such moments coincide
> with frame discarding in pwc driver.

Well sounds like you may be able to fix it since you have a test
case for it :)

> Even though IN sending is usually handled by USB host hardware, it is
> not fully true for MUSB. Every IN is triggered by musb kernel driver
> (see MUSB_RXCSR_H_REQPKT usage in musb_host_packet_rx() and
> musb_ep_program()) since auto IN is not used. Rather complicated logic
> is incorporated to decide whether IN packet has to be sent. First,
> musb_host_packet_rx() handles IN sending when current URB is not
> completed (i.e. current URB has another packet which has to be
> received next). Second, musb_advance_schedule() (via musb_start_urb())
> handles the case when current URB is completed but there is another
> URB pending. It seems that there is a hardware logic to fire IN packet
> in a way to have exactly 1ms between two consequent INs. So,
> MUSB_RXCSR_H_REQPKT is considered as IN requesting flag.

Yeah this is a known issue with musb, there is not much ISO support
currently really. The regression should be fixed though.

Sorry I don't have much ideas on how to improve things here. One
way might be to attempt to split the large musb functions into
smaller functions and see if that then allows finer grained control.

Just to try to come up with some new ideas.. Maybe there's some way
to swap the hardware EP config dynamically and have some packets
mostly preconfigured and waiting to be triggered?

Regards,

Tony
