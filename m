Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.wa.amnet.net.au ([203.161.124.50]:55148 "EHLO
	smtp1.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab0A2Owe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 09:52:34 -0500
Message-ID: <4B62F620.6020105@barber-family.id.au>
Date: Fri, 29 Jan 2010 22:52:16 +0800
From: Francis Barber <fedora@barber-family.id.au>
MIME-Version: 1.0
To: David Henig <dhhenig@googlemail.com>
CC: leandro Costantino <lcostantino@gmail.com>,
	=?ISO-8859-1?Q?N=E9meth_?= =?ISO-8859-1?Q?M=E1rton?=
	<nm127@freemail.hu>, linux-media@vger.kernel.org
Subject: Re: Make failed - standard ubuntu 9.10
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>	 <4B62A967.3010400@googlemail.com> <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com> <4B62F048.1010506@googlemail.com>
In-Reply-To: <4B62F048.1010506@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/01/2010 10:27 PM, David Henig wrote:
> Thanks, eventually tip 1 fixed this. For some reason I had 
> 2.6.31-17-generic without a .config, as I seem to be using 
> 2.6.31-17-generic-pae. Creating a symlink to that fixed this error.
>
> Unfortunately still can't finish build, I get an error in 
> firedtv-1394, as shown below. Do I need to reinstall, as I also get 
> the following message?
>
> ***WARNING:*** You do not have the full kernel sources installed.
> This does not prevent you from building the v4l-dvb tree if you have the
> kernel headers, but the full kernel source may be required in order to 
> use
> make menuconfig / xconfig / qconfig.
>
> If you are experiencing problems building the v4l-dvb tree, please try
> building against a vanilla kernel before reporting a bug.
>
> Thanks again for any help, I'm sorry I'm only a couple of months into 
> linux, I'm just trying to do this against what I thought was a fairly 
> standard build...
>
> David
>
Hi David,

It looks like you don't have the kernel headers package installed.  In 
Ubuntu this package is called linux-headers-generic for the generic 
kernel, and linux-headers-server for the server kernel, etc and so forth.

If you have this package you shouldn't need to any symlinking with the 
.config, either.  I didn't have to.

Regards,
Frank.
