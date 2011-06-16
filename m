Return-path: <mchehab@pedra>
Received: from wp209.webpack.hosteurope.de ([80.237.132.216]:40212 "EHLO
	wp209.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755972Ab1FPL6x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 07:58:53 -0400
Message-ID: <4DF9EA62.2040008@killerhippy.de>
Date: Thu, 16 Jun 2011 13:34:58 +0200
From: =?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: RTL2831U wont compile against 2.6.38
References: <4DF9BCAA.3030301@holzeisen.de>
In-Reply-To: <4DF9BCAA.3030301@holzeisen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thomas Holzeisen wrote:
> Hi there,
> 
> I tried to get an RTL2831U dvb-t usb-stick running with a more recent kernel (2.6.38) and failed.
> 
> The hg respository ~jhoogenraad/rtl2831-r2 aborts on countless drivers, the rc coding seem have to
> changed a lot since it got touched the last time.
> 
> The hg respository ~anttip/rtl2831u wont compile as well, since its even older.
> 
> The recent git respositories for media_tree and anttip dont contain drivers for the rtl2831u.
> 
> Has this device been abandoned, or is anyone working on it?
> 
> greetings,
> Thomas

There are still people working on it and there is new sources, e.g. look at
http://www.spinics.net/lists/linux-media/msg24890.html
at the very bottom. Worked like a charm at my system with kernel 2.6.39.

I think, there will be announcements later at
http://wiki.zeratul.org/doku.php?id=linux:v4l:realtek:start

Greetings from Braunschweig, Germany.
Sascha
