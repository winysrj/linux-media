Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:53068 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755465Ab0KNUtx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 15:49:53 -0500
Message-ID: <4CE04B60.4080105@skyboo.net>
Date: Sun, 14 Nov 2010 21:49:36 +0100
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: Massis Sirapian <msirapian@free.fr>, linux-media@vger.kernel.org
References: <4CDFF446.2000403@free.fr> <4CE0047D.8060401@arcor.de> <4CE03704.4070300@free.fr>
In-Reply-To: <4CE03704.4070300@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: HVR900H : IR Remote Control
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Massis,

On 11/14/2010 08:22 PM, Massis Sirapian wrote:
> Thanks Stefan. I've checked the /drivers/media/IR/keymaps of the kernel
> source directory, but nothing seems to fit my remote, which is a
> DSR-0012 : http://lirc.sourceforge.net/remotes/hauppauge/DSR-0112.jpg.
 >
> Were you talking about these rc_"map" modules? If so and if there is
> corresponding module for my remote, how can I contribute as I have one?

First of all you need to check for the codes if they appear when you
pressing buttons. If you have /dev/input/eventX number then you can use:
input-events X
where X is the event number related with you IR receiver

then you can make a map for you remote (based on that codes you've got)
you can also create the temporary map for testing and load it using
command:
input-kbd -f your_map_file X
where X - event number,
your_map_file - a file with key mappings in format:
key_code = KEY_something, ie:
146 = KEY_0

regards
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
