Return-path: <mchehab@pedra>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:35392 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab1FLWgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 18:36:08 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Mon, 13 Jun 2011 00:34:37 +0200
To: Antti Palosaari <crope@iki.fi>
Cc: Juergen Lock <nox@jelal.kn-bremen.de>, linux-media@vger.kernel.org,
	hselasky@c2i.net
Subject: Re: [PATCH] [media] af9015: setup rc keytable for LC-Power
 LC-USB-DVBT
Message-ID: <20110612223437.GB71121@triton8.kn-bremen.de>
References: <20110612202512.GA63911@triton8.kn-bremen.de>
 <201106122215.p5CMF0Xr069931@triton8.kn-bremen.de>
 <4DF53CB6.109@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF53CB6.109@iki.fi>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 13, 2011 at 01:24:54AM +0300, Antti Palosaari wrote:
> On 06/13/2011 01:15 AM, Juergen Lock wrote:
> >> About the repeating bug you mention, are you using latest driver
> >> version? I am not aware such bug. There have been this kind of incorrect
> >> behaviour old driver versions which are using HID. It was coming from
> >> wrong HID interval.
> >>
> >> Also you can dump remote codes out when setting debug=2 to
> >> dvb_usb_af9015 module.
> >
> >   That doesn't seem to work here so maybe my version is really too old
> > to have that fix.  (But the keytable patch should still apply I guess?)
> 
> Could you send af9015.c file you have I can check?
> 
> Your patch is OK, but I want to know why it repeats.

Sent off-list.

 Thanx, :)
	Juergen
