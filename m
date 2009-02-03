Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4182 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZBCOCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 09:02:33 -0500
Message-ID: <49884E67.4090003@linuxtv.org>
Date: Tue, 03 Feb 2009 09:02:15 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: CityK <cityk@rogers.com>
CC: David Engel <david@istwok.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com> <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com> <20090202235820.GA9781@opus.istwok.net> <4987DE4E.2090902@rogers.com>
In-Reply-To: <4987DE4E.2090902@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CityK wrote:
> - how to provide a proper solution that will resolve the underlying i2c
> gate issue remains a point in discussion. In the meantime:
>
>   

It's a load order dependency --  There is no way to toggle the i2c gate 
without first bringing up the demod, which requires firmware.  The 
ATSC11(0/5) requires the DVB bring-up to complete before bringing up the 
analog i2c clients.


> - Hans kworld repo:
> Pros: does provide analog tv functionality for, at a minimum, tvtime.
> Cons: The changes introduced result in, as testing to date has shown, a
> harmless bit of duplication in the way of the tuner being loaded twice.
> kdetv/motv/xawtv, at a minimum, do not work in overlay mode.
>   

Tuner is _not_ loaded twice.  The tuner-simple driver is displaying 
itself twice in the dmesg logs, because it is attached twice.  Once for 
analog, again for digital -- this is *by design*.

The old code used dvb-pll for the digital side, and tuner-simple for 
analog.  The common support within those two modules has been merged 
together to remove redundancy and allow us to share state between the 
two instances of the driver for the same part.

As tuner-simple registers each side of the interface, it will display a 
message to the kernel logs indicating what tuner has been attached -- 
this is what you see twice.

-Mike
