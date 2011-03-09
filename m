Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:54512 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab1CIQWp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2011 11:22:45 -0500
Message-ID: <4D77A951.5010209@linuxtv.org>
Date: Wed, 09 Mar 2011 17:22:41 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pascal_J=FCrgens?=
	<lists.pascal.juergens@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Simultaneous recordings from one frontend
References: <B7991825-5F55-4AA0-AB7B-BB2A968F7464@googlemail.com>
In-Reply-To: <B7991825-5F55-4AA0-AB7B-BB2A968F7464@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/09/2011 03:20 PM, Pascal Jürgens wrote:
> SUMMARY: What's the best available tool for demultiplexing into multiple simultaneous recordings (files)?

The kernel. There's no need to do that in userspace.

Any(*) number of tools may open a demux simultaneously, set up a filter
for the first PID with DMX_OUT_TSDEMUX_TAP and add any(*) number of TS
PIDs with DMX_ADD_PID. Data has to be read from demux, not from the
limited and IMHO obsolete dvr device.

In simplified code for PAT, PMT PID 0x80, Video PID 0x100, Audio PID 0x101:

int fd = open("/dev/dvb/adapter0/demux0", O_RDWR);

struct dmx_pes_filter_params f = {
	.pid = 0, // PAT
	.input = DMX_IN_FRONTEND, // live TV
	.output = DMX_OUT_TSDEMUX_TAP, // TS packets!
	.pes_type = DMX_PES_OTHER, // no decoding
	.flags = DMX_IMMEDIATE_START,
};

uint16_t pid[] = { 0x80, 0x100, 0x101 };

ioctl(fd, DMX_SET_PES_FILTER, &f);
for (int i = 0; i < 3; i++)
	ioctl(fd, DMX_ADD_PID, &pid[i]);

ssize_t r;
unsigned char buf[N * 188];
while ((r = read(fd, buf, sizeof(buf)) >= 0)
	write(1, buf, r);	// write to stdout

close(fd);

If there's no tool using this interface yet, it's probably time to write
or modify one,

Regards,
Andreas

*) Depending on available system resources.
