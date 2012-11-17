Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47188 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2KQNfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Nov 2012 08:35:19 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so2300604qcr.19
        for <linux-media@vger.kernel.org>; Sat, 17 Nov 2012 05:35:19 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 13:35:18 +0000
Message-ID: <CAKQROYXaEVasawMTd7XiDOvx_ZxL6H=0MqEds2-C+WFDru0m=Q@mail.gmail.com>
Subject: Linux DVB Explained..
From: Richard <tuxbox.guru@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mau,


I have started documenting a HOWTO on making a linuxDVB device and
would like to know what the following is used for....


struct dvb_demux :
This has a start_feed and a stop feed.   What feed is this? ... the
RAW 188 byte packets from the device perhaps?

What is the main purpose of this structure?

struct dmx_demux :
This structure holds the frontend device struct and contains the .fops
for read/write.  Is this the main interface when using the
/dev/dvb/adapterX/demux ? /dvr?


So far...

adapter = dvb_register_adapter() : Register a new DVB device adapter
(called once)
dvb_dmx_init(dvbdemux);  // Called once per Demux chain?
dvb_dmxdev_init();  // Called once per demux chain ? same as above

-------------------
The hardware I am using has 6 TS data inputs, 4 tuners (linked to TS
inputs)  and hardware PID filters and I am trying to establish the
relationship of dmx and dmxdev.


Any clarification is most welcome
Best Regards,
Richard
