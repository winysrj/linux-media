Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45732 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1HNXvb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 19:51:31 -0400
Message-ID: <4E485F81.9020700@iki.fi>
Date: Mon, 15 Aug 2011 02:51:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Smart card reader support for Anysee DVB devices
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>
In-Reply-To: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I looked your codes and examined also some more. About your driver, I
don't like you put so much functionality to the Kernel driver. Just put
this functionality to the userspace driver all and offer only lowest
possible interface (read + write) from Kernel. If you look other IFDs it
is like that.
On the other hand I see it could be possible to add some glue and
functionality to the Kernel driver if you find already existing
userspace protocol (IFD driver) which can be used. Add some emulation to
Kernel and use existing user space. Select some well supported serial
smartcard reader and make Anysee driver speak like that.

Biggest problem I see whole thing is poor application support. OpenCT is
rather legacy but there is no good alternative. All this kind of serial
drivers seems to be OpenCT currently.

regards
Antti

On 07/17/2011 05:18 PM, István Váradi wrote:
> Hi,
> 
> I have developed smart card reader support for the Anysee devices by
> extending Antti Palosaari's driver. I attached the patches for it. It
> registers a character device named /dev/anysee_scN for each Anysee
> device.
> 
> The character device supports two ioctl's (see anysee_sc), one for
> detecting the presence of a card, the other one for resetting the card
> and querying the ATR. The write() operation writes to the card by
> packaging the bytes into USB commands. The read() operation issues an
> appropriate command over USB and returns the reply. I have also
> written a simple OpenCT driver (attached) which shows the usage.
> 
> I would like to have the kernel driver included in the official
> sources. For this reason I corresponded with Antti, and he suggested
> the perhaps the kernel driver should have a lower-level interface. I
> had the following proposal:
> 
> We would continue having the two ioctls, ANYSEE_SC_ACTIVATE and
> ANYSEE_SC_PRESENT, however, ANYSEE_SC_ACTIVATE would do only the
> register reading and writing.
> 
> Besides these two we need access to the anysee_ctrl_msg() function
> somehow. I think the cleanest way would be via another ioctl() call in
> which we would pass the return buffer as well, with the length so that
> we know how many bytes to copy. Another possibility would be that a
> call to write() calls anysee_ctrl_msg() and stores the return data in
> a 64 byte buffer that we allocate for each device. The read()
> following a write() would read this buffer, then discard it. Further
> read() attempts would fail with EAGAIN, or we could maintain an offset
> into the 64 byte buffer, and read as long as there is data, and fail
> only then. A write() would cause losing any unread data.
> 
> What do you think?
> 
> Thanks,
> 
> Istvan


-- 
http://palosaari.fi/
