Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36021 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab1HQQPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 12:15:37 -0400
Received: by wyg24 with SMTP id 24so789340wyg.19
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2011 09:15:36 -0700 (PDT)
Subject: Re: Afatech AF9013
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Josu Lazkano <josu.lazkano@gmail.com>,
	Jose Alberto Reguero <jareguero@telefonica.net>
In-Reply-To: <201108170123.09647.jareguero@telefonica.net>
References: <CAL9G6WUpso9FFUzC3WWiBZDqQDr-+HQFouCO_2V-zVHVyiyKeg@mail.gmail.com>
	 <201108162227.00963.jareguero@telefonica.net> <4E4AD9B4.2040908@iki.fi>
	 <201108170123.09647.jareguero@telefonica.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 17:15:29 +0100
Message-ID: <1313597729.2672.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2011-08-17 at 01:23 +0200, Jose Alberto Reguero wrote:
> On Martes, 16 de Agosto de 2011 22:57:24 Antti Palosaari escribió:
> > On 08/16/2011 11:27 PM, Jose Alberto Reguero wrote:
> > >> options dvb-usb force_pid_filter_usage=1
> > >> 
> > >> I change the signal timeout and tuning timeout and now it works perfect!
> > >> 
> > >> I can watch two HD channels, thanks for your help.
> > >> 
> > >> I really don't understand what force_pid_filter_usage do on the
> > >> module, is there any documentation?
> > >> 
> > >> Thanks and best regards.
> > > 
> > > For usb devices with usb 2.0 when tunned to a channel there is enought
> > > usb bandwith to deliver the whole transponder. With pid filters they
> > > only deliver the pids needed for the channel. The only limit is that the
> > > pid filters is limited normaly to 32 pids.
> > 
> > May I ask how wide DVB-T streams you have? Here in Finland it is about
> > 22 Mbit/sec and I think two such streams should be too much for one USB
> > bus. I suspect there is some other bug in back of this.
> > 
> > regards
> > Antti
> 
> Here the transport stream is like yours. About 4 Mbit/sec by channel, and 
> about 5 channels by transport stream. The problem I have is that when I have 
> the two tuners working I have a few packets lost, and I have some TS 
> discontinuitys. With pid filters the stream is perfect. Perhaps Josu have 
> another problem.

I am certain it is the configuration of the second frontend that ripples
through Afatech devices.

I have only got a single AF9015 device so can't test the dual
configuration.

Does the same problems exist when running the second frontend solo or
dual with the Windows driver?

With the IT1937(aka AF9035) the second frontend appeared not to work at
all in Windows in dual mode.

tvboxspy

