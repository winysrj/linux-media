Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55147 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3FBU5X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 16:57:23 -0400
Message-ID: <51ABB18A.1090602@iki.fi>
Date: Sun, 02 Jun 2013 23:56:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: marco caminati <marco.caminati@yahoo.it>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: rtl2832u+r820t working
References: <1367840892.39557.YahooMailNeo@web28904.mail.ir2.yahoo.com> <5187D1BC.8030204@gmail.com> <1367880378.47575.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1370189132.73195.YahooMailNeo@web28906.mail.ir2.yahoo.com>
In-Reply-To: <1370189132.73195.YahooMailNeo@web28906.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2013 07:05 PM, marco caminati wrote:
>
> This usb dongle (0bda:2838) now works for me.
> Thanks to all people who worked on it, especially to Gianluca.
> Built from git://linuxtv.org/media_build under Linux box 3.8.10-tinycore #3810 SMP Tue Apr 30 15:45:26 UTC 2013 i686 GNU/Linux.
>
> ---INFRARED REMOTE---
>
> I also ask if ir remote will be supported.
> With some old version of v4l (not supporting r820t) I managed to have the infrared working as a hid (/dev/input/eventX) device.
> So it should be possible to merge the code from that old version into the current one to have everything supported.
> The problem is that I can't remember which version was that, can anybody help me?
>
> Alternatively, I patched as from  [1], and successfully built, current v4l: however, resulting .ko do not support ir remote, it seems (not even as an option to pass to modprobe).
> Any indication, please?
>
> Cheers
>
> [1] https://patchwork.kernel.org/patch/2468671/

That remote controller patch looks interesting. I will try to get some 
time to review and test it...


regards
Antti

-- 
http://palosaari.fi/
