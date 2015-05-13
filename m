Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45323 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934502AbbEMOrS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 10:47:18 -0400
Message-ID: <555363ED.50207@iki.fi>
Date: Wed, 13 May 2015 17:47:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mike Martin <mike@redtux.org.uk>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Disappearing dvb-usb stick IT9137FN (Kworld 499-2T)
References: <CAOwYNKbkLgeEdfuC9m3ytjKKwPqxob6JD0pDtrkJFGqbY_a8Ag@mail.gmail.com>
In-Reply-To: <CAOwYNKbkLgeEdfuC9m3ytjKKwPqxob6JD0pDtrkJFGqbY_a8Ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/13/2015 12:26 PM, Mike Martin wrote:
> Hi
>
> I have the above usb stick (dual frontend) which works fine for a
> while then just vanishes.
> ie: frontend just goes
>   eg
>
> ls /dev/dvb (I have a permanent DVB card as well)
> /dev/dvb/adapter0
> /dev/dvb/adapter1
> /dev/dvb/adapter2
>
> goes to
>
> ls /dev/dvb (I have a permanent DVB card as well)
> /dev/dvb/adapter0
>
> To get it back I have plug/unplug several times (rebooting the box
> seems to make no difference)
>
> I am currently on fedora 21, but this seems to be a continual issue ,
> through at least fedora 18 to date
>
> I cant see anything obvious in dmesg or the logs
>
> Any ideas

Could you still post that dmesg, just those texts appeared after plugin.

Antti
-- 
http://palosaari.fi/
