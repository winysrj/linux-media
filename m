Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44921 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2KQPwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Nov 2012 10:52:49 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so2468792qat.19
        for <linux-media@vger.kernel.org>; Sat, 17 Nov 2012 07:52:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKQROYXaEVasawMTd7XiDOvx_ZxL6H=0MqEds2-C+WFDru0m=Q@mail.gmail.com>
References: <CAKQROYXaEVasawMTd7XiDOvx_ZxL6H=0MqEds2-C+WFDru0m=Q@mail.gmail.com>
Date: Sat, 17 Nov 2012 15:52:48 +0000
Message-ID: <CAKQROYVE6ZtvSLjQq5jyWcPyK1k6oapr=F3Mw5m4mQDHo2fvqg@mail.gmail.com>
Subject: Re: Linux DVB Explained..
From: Richard <tuxbox.guru@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apologies Mauro, I accidentailly bumped the 'Send' whilst typing your name.

The message is addressed to Mauro and All,

On 17 November 2012 13:35, Richard <tuxbox.guru@gmail.com> wrote:
> Hi Mau,
>
>
> I have started documenting a HOWTO on making a linuxDVB device and
> would like to know what the following is used for....
>
>
> struct dvb_demux :
> This has a start_feed and a stop feed.   What feed is this? ... the
> RAW 188 byte packets from the device perhaps?
>
> What is the main purpose of this structure?
>
> struct dmx_demux :
> This structure holds the frontend device struct and contains the .fops
> for read/write.  Is this the main interface when using the
> /dev/dvb/adapterX/demux ? /dvr?
>
>
> So far...
>
> adapter = dvb_register_adapter() : Register a new DVB device adapter
> (called once)
> dvb_dmx_init(dvbdemux);  // Called once per Demux chain?
> dvb_dmxdev_init();  // Called once per demux chain ? same as above
>
> -------------------
> The hardware I am using has 6 TS data inputs, 4 tuners (linked to TS
> inputs)  and hardware PID filters and I am trying to establish the
> relationship of dmx and dmxdev.
>
>
> Any clarification is most welcome
> Best Regards,
> Richard

To add more queries,

What is the purpose of
dmx_frontend  and dvb_frontend

The word 'frontend' seems to be sending me in a loop.

Its usually FE->Tuner->Demod->PID Filter-> TS Data  so I am at a loss
where dmx_frontend goes

Richard
