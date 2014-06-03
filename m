Return-path: <linux-media-owner@vger.kernel.org>
Received: from c.ponzo.net ([69.12.221.20]:48036 "EHLO c.ponzo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaFCBtJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jun 2014 21:49:09 -0400
Message-ID: <538D2392.6030301@ponzo.net>
Date: Mon, 02 Jun 2014 18:23:30 -0700
From: Scott Doty <scott@ponzo.net>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: hdpvr troubles
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mr. Hans and mailing list,

In a nutshell, I'm having some hdpvr trouble:

I'm using vlc to view the stream.  Kernel 3.9.11 works pretty well,
including giving me AC3 5.1 audio from the optical input to the
Hauppauge device.  The only problem I've run across is the device
hanging when I change channels, but I've learned to live with that. 
(Though naturally it would be nice to fix. :) )

However, every kernel I've tried after 3.9.11 seems to have trouble with
the audio.  I get silence, and pulseaudio reports there is only stereo. 
I've taken a couple of of snapshots of pavucontrol so you can see what I
mean:

   http://imgur.com/a/SIwc7

I even tried a git bisect to try to narrow down where things went awry,
but ran out of time to pursue the question.  But as far as I can tell,
3.9.11 is as far as I can go before my system won't use the device properly.

I see the conversation in the archives from around the middle of May,
where Hans was working with Ryley and Keith, but I'm not sure if I
should apply that patch or not.  I would love to make this work,
including submitting a patch if someone could outline where the problem
might be.

Thank you in advance for any help you can provide, and please let me
know if I can send any more information. :)

 -Scott
Bus 008 Device 003: ID 2040:4903 Hauppauge HS PVR

