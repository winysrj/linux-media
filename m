Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm5.telefonica.net ([213.4.138.21]:15309 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335Ab1HPXXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 19:23:23 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: Afatech AF9013
Date: Wed, 17 Aug 2011 01:23:09 +0200
Cc: Josu Lazkano <josu.lazkano@gmail.com>, linux-media@vger.kernel.org
References: <CAL9G6WUpso9FFUzC3WWiBZDqQDr-+HQFouCO_2V-zVHVyiyKeg@mail.gmail.com> <201108162227.00963.jareguero@telefonica.net> <4E4AD9B4.2040908@iki.fi>
In-Reply-To: <4E4AD9B4.2040908@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108170123.09647.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Martes, 16 de Agosto de 2011 22:57:24 Antti Palosaari escribió:
> On 08/16/2011 11:27 PM, Jose Alberto Reguero wrote:
> >> options dvb-usb force_pid_filter_usage=1
> >> 
> >> I change the signal timeout and tuning timeout and now it works perfect!
> >> 
> >> I can watch two HD channels, thanks for your help.
> >> 
> >> I really don't understand what force_pid_filter_usage do on the
> >> module, is there any documentation?
> >> 
> >> Thanks and best regards.
> > 
> > For usb devices with usb 2.0 when tunned to a channel there is enought
> > usb bandwith to deliver the whole transponder. With pid filters they
> > only deliver the pids needed for the channel. The only limit is that the
> > pid filters is limited normaly to 32 pids.
> 
> May I ask how wide DVB-T streams you have? Here in Finland it is about
> 22 Mbit/sec and I think two such streams should be too much for one USB
> bus. I suspect there is some other bug in back of this.
> 
> regards
> Antti

Here the transport stream is like yours. About 4 Mbit/sec by channel, and 
about 5 channels by transport stream. The problem I have is that when I have 
the two tuners working I have a few packets lost, and I have some TS 
discontinuitys. With pid filters the stream is perfect. Perhaps Josu have 
another problem.

Jose Alberto
