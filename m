Return-path: <linux-media-owner@vger.kernel.org>
Received: from 0x55535970.adsl.cybercity.dk ([85.83.89.112]:18869 "EHLO
	kultorvet.udgaard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab0AQTNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 14:13:46 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by kultorvet.udgaard.com (8.14.3/8.14.3) with ESMTP id o0HImFZf004152
	for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 19:48:16 +0100
Message-ID: <4B535B6F.2080609@udgaard.com>
Date: Sun, 17 Jan 2010 19:48:15 +0100
From: Peter Rasmussen <plr@udgaard.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Question about Terratec Aureon 7.1 Universe
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I thought I'd ask the list as I hope there might be someone with a clue 
or a suggestion, as I haven't got any :-)

A few years ago I bought a Terratec Aureon 7.1 Universe sound board, but 
I then had trouble getting it to work properly in Linux and put it aside.

Now I attempted to try it out again, especially because of its 
supposedly high quality vinyl record pre-amplifier, which I would like 
to use, but it seems that it isn't recognized at all by my Linux system. 
On a PC platform.

I wonder if it is broken, or if there are some special things that needs 
to be done first?

When executing 'lspci' it doesn't show up at all, but there is one LED 
light showing up on the front of the box that is a part of it.

Are you aware of any magic that needs to be done to make it recognized 
by a Linux system?
I have tried to use a few kernel compiles from 2.6.19 to 2.6.33rc4 and I 
chose to include the following drivers (I'm using Slackware so all 
packages, including the kernels are generic):

CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y

Or, are you aware of a weakness in the electric parts that may have 
broken while I stored it?
I don't remember what I did right after having bought the board, but I 
suppose it was at least recognized as I didn't return it as being broken.

Terratec has discontinued it so it may not even be possible to repair 
it, if it is indeed broken.

Thank you for your time,
Peter

