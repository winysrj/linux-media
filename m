Return-path: <linux-media-owner@vger.kernel.org>
Received: from jik4.kamens.us ([45.79.160.233]:56152 "EHLO jik4.kamens.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932313AbcIVBVZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 21:21:25 -0400
Received: from jik5.kamens.us (146-115-42-232.c3-0.abr-ubr1.sbo-abr.ma.cable.rcn.com [146.115.42.232])
        (authenticated bits=0)
        by jik4.kamens.us (8.14.7/8.14.7) with ESMTP id u8M0bcjF009397
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2016 20:37:38 -0400
To: linux-media@vger.kernel.org
From: Jonathan Kamens <jik@kamens.us>
Subject: Supported, available Dual ATSC tuner? If not, I'll pay you to make
 one work!
Message-ID: <f0481f87-2f17-1230-12d7-43f74617cdc6@kamens.us>
Date: Wed, 21 Sep 2016 20:37:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm sure this is one of the most commonly asked question on this list,
and for that I apologize, but I've tried reading all the information
that I can find about this online, and I just can't figure it out, so
here goes... Is there actually a USB or PCI, ATSC, DVB-T device with
two tuners that I can buy today that will actually work on Linux
(Ubuntu 16.04.1)? If so, what is it?

It seems like all the lists of compatible devices I've seen list a
bunch of devices that aren't actually sold anymore, and most of them
only have one tuner. I already have a working device with one tuner; I
need two.

And a related question... I bought the Hauppauge WinTV-dualHD tuner,
in particular this device:

https://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-dualHD#Model_01595_.28USB_device_ID_2040:026d.29

thinking that it was compatible with Linux, but it's actually not.

Is it just a matter of messing around with USB device detection and
kernel driver settings and loading the correct firmware into the
dongle, or something? Could an experienced V4L developer with access
to this device figure out how to make it work relatively easily?

If so, then I've got an offer that will hopefully be attractive enough
for someone to take me up on it. Here's the deal...

If you know what you're doing in this code -- I certainly don't, and I
don't have time to learn -- and you think you can make this device
work with Linux -- and to be clear, I mean making *both* tuners work,
not just one of them -- then in exchange for your doing so, I offer
one of the following:

1. I will give you the tuner for free for you to keep;
2. I will donate USD$300 to any IRS-recognized 501(c)3 charity of your
   choice; or
3. I will send you USD$200 via Paypal.

To facilitate this, I will either give you remote access to an Ubuntu
Linux 16.04.1 box with the tuner plugged into it for you to work on
(including TeamViewer access so you can see the remote display to
verify that the tuner is working when you get to the point where it's
actually being registered properly in the kernel), or send you the
tuner (if you're in the U.S.; shipping overseas is cost-prohibitive),
with the understanding that if you then _can't_ make it work, you have
to pay to send it back to me.

Why am I doing this? Because I'm sick of trying to make this work by
myself and I don't have any more time to spend on it, so I'm happy to
substitute money for time if there's someone more knowledgeable than I
am who can solve this problem for me. And because I want to help the
Linux community by adding at least one to the small set of currently
sold tuner devices that actually work with Linux.

Anybody interested?

Thanks,

Jonathan Kamens

