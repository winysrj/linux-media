Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47848 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaAZPzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 10:55:07 -0500
Message-ID: <52E52FD9.2060706@iki.fi>
Date: Sun, 26 Jan 2014 17:55:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: jana1972@centrum.cz, linux-media@vger.kernel.org
Subject: Re: Developers blogs
References: <52DF9A9A.14029.1F9A8A4A@jana1972.centrum.cz>
In-Reply-To: <52DF9A9A.14029.1F9A8A4A@jana1972.centrum.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jahn

On 22.01.2014 11:16, Jahn wrote:
>   Hi everyone,
> I am a newbie in V4L fields so I
>    search for various info about V4L to study available details
>   I am happy I found few blogs that provides
>   interesting  information
>   e.g.
>   http://blog.palosaari.fi/

=) My plan has been share some hardware level information, mostly from 
consumer market USB DTV devices, as those are the devices I am familiar. 
Give some general info how these sticks are are build on a level chips 
are interconnected, from the driver developer point of view. One thing 
what I have tried to tell is how to gather needed information using some 
common reverse-engineering techniques, needed by about every Linux 
developer working with these devices.

One thing I would like to do is demodulator reverse-engineering 
tutorial. Unfortunately I haven't found suitable example yet, as it 
should be some DVB USB device having existing drivers for USB interface 
and RF tuner, and simple USB protocol. EC100/EC168 is one very good 
example, but unfortunately I have done its driver ages back. Maybe I 
should rewrite it from the scratch :)


>   http://www.kernellabs.com/blog/?page_id=2066

Especially I like to read those articles related of sniffing hardware 
directly from the bus (I2C, IF, ...).

>
>   but if I found even more ....
>
>
> I think it would be a good idea  if anyone
>   in the vger.kernel.org list could provide his blog's ( website) address
>   so that we can share knowledge   together.
>   What do you think?


regards
Antti

-- 
http://palosaari.fi/
