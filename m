Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55358 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KSKwr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 05:52:47 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so2755257wgb.1
        for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 02:52:46 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Richard <tuxbox.guru@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Linux DVB Explained..
Date: Mon, 19 Nov 2012 11:52:43 +0100
Message-ID: <1603480.BOCkXrJCoo@dibcom294>
In-Reply-To: <CAKQROYXaEVasawMTd7XiDOvx_ZxL6H=0MqEds2-C+WFDru0m=Q@mail.gmail.com>
References: <CAKQROYXaEVasawMTd7XiDOvx_ZxL6H=0MqEds2-C+WFDru0m=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

I can maybe answer some of your questions with semi-complete answers in the 
hope it helps you further.

On Saturday 17 November 2012 13:35:18 Richard wrote:
> struct dvb_demux :
> This has a start_feed and a stop feed.   What feed is this? ... the
> RAW 188 byte packets from the device perhaps?

start/stop_feed are callbacks in the dvb_demux-device (which is represented 
with dvb/adapterX/demuxX by your driver) which have to be filled in by the 
driver which implements and controls the HW-demux.

E.g: (from dmxdev.c) when a user is issuing the DMX_ADD_PID ioctl (which 
marks the request of a certain PID from the TS currently received) the 
start_feed-callback is called. It tells the driver that the TS-packets 
identified with PID are expected via e.g. the dvrX device. So the driver has 
to instruct its internal demux to have them pass the filter.

> What is the main purpose of this structure?
> 
> struct dmx_demux :
> This structure holds the frontend device struct and contains the .fops
> for read/write.  Is this the main interface when using the
> /dev/dvb/adapterX/demux ? /dvr?

I'm not sure to get what you want to know here.

> adapter = dvb_register_adapter() : Register a new DVB device adapter
> (called once)
> dvb_dmx_init(dvbdemux);  // Called once per Demux chain?
> dvb_dmxdev_init();  // Called once per demux chain ? same as above
> 
> -------------------
> The hardware I am using has 6 TS data inputs, 4 tuners (linked to TS
> inputs)  and hardware PID filters and I am trying to establish the
> relationship of dmx and dmxdev.

Before understanding the relationship you need to know where, in the end, 
you want your TS-packets. In user-space? Sent to a hardware-decoder? 
Somewhere else? All of that?

HTH a litte bit,
--
Patrick 

