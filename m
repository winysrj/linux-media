Return-path: <linux-media-owner@vger.kernel.org>
Received: from dubhe.uberspace.de ([185.26.156.47]:41700 "EHLO
        dubhe.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbeGQHb5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 03:31:57 -0400
Subject: Re: [PATCH RFC] usb: add usb_fill_iso_urb()
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <20180620164945.xb24m7wlbtb6cys5@linutronix.de>
 <Pine.LNX.4.44L0.1806201322260.1758-100000@iolanthe.rowland.org>
 <20180712223527.5nmxndignujo7smt@linutronix.de>
 <20180713072923.GA31191@kroah.com>
 <20180713074728.itw7ua7zygazotuk@linutronix.de>
 <20180716225357.v25f6rurz56q4yes@linutronix.de>
From: Clemens Ladisch <clemens@ladisch.de>
Message-ID: <d05f2d3a-dfa7-d94a-a115-925158b31b5f@ladisch.de>
Date: Tue, 17 Jul 2018 08:54:34 +0200
MIME-Version: 1.0
In-Reply-To: <20180716225357.v25f6rurz56q4yes@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sebastian Andrzej Siewior wrote:
> sound/ is (almost) the only part where struct usb_iso_packet_descriptor
> init does not fit. It looks like it is done just before urb_submit() and
> could be avoided there (moved to the init funtcion instead).

For playback, the packet lengths change dynamically, because the nominal
sample rate (let alone the actual sample rate) often is not an integer
multiple of the 1 kHz/8 kHz USB frame rate.


Regards,
Clemens
