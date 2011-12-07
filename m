Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab1LGLt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 06:49:59 -0500
Message-ID: <4EDF52E4.9090606@redhat.com>
Date: Wed, 07 Dec 2011 09:49:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hamad Kadmany <hkadmany@codeaurora.org>
CC: linux-media@vger.kernel.org
Subject: Re: [dvb] Problem registering demux0 device
References: <001101ccae6d$9900b350$cb0219f0$@org> <000001ccb4d3$aab157f0$001407d0$@org>
In-Reply-To: <000001ccb4d3$aab157f0$001407d0$@org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-12-2011 09:30, Hamad Kadmany wrote:
> Hi,
>
> I'm implementing new adapter for DVB, I built a module to register the
> adapter and demux/net devices. From the kernel log I see all actions are
> performed fine and dvb_register_device (called by dvb_dmxdev_init) is called
> successfully for net0/demux0/dvr0, however, demux0/dvr0 devices do not show
> up, "ls /sys/class/dvb" shows only dvb0.net0 (and nothing appears under
> /dev/dvb/ anyhow).
>
> What could cause not having demux0/dvr0 registered? Note that net0 shows up
> fine.

It is hard to tell the exact problem without looking into the driver. Are you
handling the error codes returned by the register functions?

You can follow what's happening inside your driver by enabling tracepoints.
Here is one of the scripts I used when I need to know what functions are
called:

	#!/bin/bash
	cd /sys/kernel/debug/tracing

	echo disabling trace
	echo 0 > tracing_enabled
	echo getting funcs
	FUNC="`cat /sys/kernel/debug/tracing/available_filter_functions|grep -i drx`"

	echo setting functions
	echo $FUNC>set_ftrace_filter
	echo set trace type
	echo function_graph > current_tracer
	echo enabling trace
	echo 1 > tracing_enabled

(the above enables tracing only for functions with "drx" in the name - you'll
need to tailor it for your specific needs)

Of course, after finishing the device creation, you should disable the trace and
get its results with:

	#!/bin/bash
	cd /sys/kernel/debug/tracing
	echo 0 > tracing_enabled
	less trace

I suggest you to compare the trace for a device that is known to create all dvb
nodes with your driver. This may give you a good hint about what is missing on
your driver.

Regards,
Mauro
