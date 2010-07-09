Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47659 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0GIU21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 16:28:27 -0400
Received: by qwh6 with SMTP id 6so584243qwh.19
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 13:28:27 -0700 (PDT)
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
From: Kenney Phillisjr <kphillisjr@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 15:28:25 -0500
Message-ID: <1278707305.25199.6.camel@dandel-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I know this is an old thread, however i have an card that meets the
requirements to be tested by the patches made by andy, and so far
with what i've tried it's been doing really well for input.

I pretty much just downloaded and tested Andy's patch set...
http://linuxtv.org/hg/~awalls/cx23885-ir2

The tests where done on ubuntu 10.04 with kernel 2.6.32-23-generic
(64-bit) and this appears to be working perfectly. (This even properly
identifies the card I'm using down to the model)

card notes: Hauppauge WinTV-HVR1250 (Model: 79001)

oh and the only change i made to the test is i commented out the
4 lines in the makefile that generate the firedtv module so i could
compile the tests 

