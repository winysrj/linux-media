Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33497 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1JGXMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 19:12:50 -0400
Received: by wwn22 with SMTP id 22so1575546wwn.1
        for <linux-media@vger.kernel.org>; Fri, 07 Oct 2011 16:12:49 -0700 (PDT)
MIME-Version: 1.0
From: Felipe Magno de Almeida <felipe.m.almeida@gmail.com>
Date: Fri, 7 Oct 2011 20:12:29 -0300
Message-ID: <CADfx-VQ=orwikZuDy+Uu4XNgOrr2qjkBy-iWDJFRoWUeDsysZg@mail.gmail.com>
Subject: Filtering DSMCC streams with dib0700/dib8000 Prolink PixelView SBTVD HD
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm not sure this is the right place to ask, but since I haven't found
anywhere else to ask I'm trying here.

I'm in Brazil, where we use ISDB-Tb standard derived from ISDB-T and
I'm using Prolink PixelView SBTVD HD.  A USB adapter. It uses
dvb-usb-dib0700 driver. I'm parsing PAT, PMT and NIT tables. With PMT
table I can find streams for which stream_type is between 0x8 and 0xD,
which means DSMCC streams. But with the following code:

dmx_sct_filter_params f;
std::memset(&f, 0, sizeof(f));
f.pid = *elementary_pid;
f.timeout = 0;
f.flags = DMX_IMMEDIATE_START | DMX_CHECK_CRC;

if(ioctl(new_demux_fd, DMX_SET_FILTER, &f) == -1)
{
  std::exit(-1);
}

which runs correctly. There never seems to be anything to read from
the fd. elementary_pid is the PID in the PMT table. I've also tried
PES filtering with no success.

I was able to to read a audio stream the same way, by using a
elementary pid from a stream with stream_type 0x11. And it worked
as I expected.

Am I doing something wrong, or the device has some sort of restriction
for DSMCC streams, or it is more likely the channel is not broadcasting
any DSMCC streams though it is publishing it in its PMT table?

Thanks in advance,
-- 
Felipe Magno de Almeida
