Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:30836 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZARUYs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 15:24:48 -0500
Message-ID: <4973900C.6090406@iki.fi>
Date: Sun, 18 Jan 2009 22:24:44 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3 works,	but keys
 get stuck
References: <49738339.9030203@podzimek.org>
In-Reply-To: <49738339.9030203@podzimek.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrej Podzimek wrote:
> After reloading the module, the remote control (almost) worked. Unfortunately, keys got stuck somehow, just as if I were holding a key on the keyboard. Another key press changed the event being repeated, but there seemed to be *no* key release events at all.
> 
> Pressing the channel up/down keys seemed to stop that key event flood, but both of my keyboards (one on the laptop and an external one) stopped working. Again, this may have been due to the absence of a key release event. (This time the key events were not that obvious, since channel up/down does not produce an alphanumeric key code.)
> 
> I use kernel 2.6.27.10, revision af9015-57423d241699 and (presumably) MSI Digivox Mini II V3.
> 
> Either I misunderstood / misconfigured something, or this could be a bug. I'm not familiar with this source code and don't have time to explore it in detail. However, feel free to ask for debugging output and other data you may need.

This seems to be hw bug. For more information:

http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030292.html

regards
Antti
