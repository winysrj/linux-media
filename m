Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56930 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaIYPjz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 11:39:55 -0400
Message-ID: <54243749.7030506@iki.fi>
Date: Thu, 25 Sep 2014 18:39:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: TeVii S480 in Debian Wheezy
References: <CAL9G6WWEocLTVeZSOtRaJYa6ieJyCzF9BiacZgrdWvKnt3P78Q@mail.gmail.com>
In-Reply-To: <CAL9G6WWEocLTVeZSOtRaJYa6ieJyCzF9BiacZgrdWvKnt3P78Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka
Could you look what system message log says?

Fedora uses nowadays journalctl command, but I think most of the others 
just print to /var/log/messages or so. Maybe dmesg command works.

regards
Antti

On 09/25/2014 06:12 PM, Josu Lazkano wrote:
> Hello all,
>
> I want to use a new dual DVB-S2 device, TeVii S480.
>
> I am using Debian Wheezy with 3.2 kernel, I copy the firmware files:
>
> # md5sum /lib/firmware/dvb-*
> a32d17910c4f370073f9346e71d34b80  /lib/firmware/dvb-fe-ds3000.fw
> 2946e99fe3a4973ba905fcf59111cf40  /lib/firmware/dvb-usb-s660.fw
>
> The device is listed as 2 USB devices:
>
> # lsusb | grep TeVii
> Bus 006 Device 002: ID 9022:d483 TeVii Technology Ltd.
> Bus 007 Device 002: ID 9022:d484 TeVii Technology Ltd.
>
> But there is no any device in /dev/dvb/:
>
> # ls -l /dev/dvb/
> ls: cannot access /dev/dvb/: No such file or directory
>
> Need I install any other driver or piece of software?
>
> I will appreciate any help.
>
> Best regards.
>

-- 
http://palosaari.fi/
