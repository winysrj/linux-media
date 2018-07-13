Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:46384 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeGMIBB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 04:01:01 -0400
Date: Fri, 13 Jul 2018 09:47:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH RFC] usb: add usb_fill_iso_urb()
Message-ID: <20180713074728.itw7ua7zygazotuk@linutronix.de>
References: <20180620164945.xb24m7wlbtb6cys5@linutronix.de>
 <Pine.LNX.4.44L0.1806201322260.1758-100000@iolanthe.rowland.org>
 <20180712223527.5nmxndignujo7smt@linutronix.de>
 <20180713072923.GA31191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180713072923.GA31191@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-07-13 09:29:23 [+0200], Greg Kroah-Hartman wrote:
> Do you have a few example patches of using this new function?  Many many
> years ago we tried to create this function, but we gave up as it just
> didn't seem to work for the majority of the users of ISO packets.  Maybe
> things have changed since then and people do it all more in a "standard"
> way and we can take advantage of this.  But it would be nice to see
> proof it can be used before taking this patch.

sure. Let me refresh my old usb_fill_int_urb() series with this instead.

> thanks,
> 
> greg k-h

Sebastian
