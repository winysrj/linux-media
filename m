Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9398 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1LGN1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 08:27:19 -0500
Received: from HKADMANY (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id ADD0E10004C7
	for <linux-media@vger.kernel.org>; Wed,  7 Dec 2011 05:27:18 -0800 (PST)
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: <linux-media@vger.kernel.org>
References: <001101ccae6d$9900b350$cb0219f0$@org> <000001ccb4d3$aab157f0$001407d0$@org> <4EDF52E4.9090606@redhat.com> 
In-Reply-To: 
Subject: RE: [dvb] Problem registering demux0 device
Date: Wed, 7 Dec 2011 15:27:22 +0200
Message-ID: <002301ccb4e3$f509d560$df1d8020$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-12-2011 13:50, Mauro Carvalho Chehab wrote:
> It is hard to tell the exact problem without looking into the driver. Are you
> handling the error codes returned by the register functions?
>
> You can follow what's happening inside your driver by enabling tracepoints.
> Here is one of the scripts I used when I need to know what functions are
> called:
>
>	#!/bin/bash
>	cd /sys/kernel/debug/tracing
>
>	echo disabling trace
>	echo 0 > tracing_enabled
>	echo getting funcs
>	FUNC="`cat /sys/kernel/debug/tracing/available_filter_functions|grep -i drx`"
>
>	echo setting functions
>	echo $FUNC>set_ftrace_filter
>	echo set trace type
>	echo function_graph > current_tracer
>	echo enabling trace
>	echo 1 > tracing_enabled
>
> (the above enables tracing only for functions with "drx" in the name - you'll
> need to tailor it for your specific needs)

> Of course, after finishing the device creation, you should disable the trace and
> get its results with:
>
>	#!/bin/bash
>	cd /sys/kernel/debug/tracing
>	echo 0 > tracing_enabled
>	less trace
>
> I suggest you to compare the trace for a device that is known to create all dvb
> nodes with your driver. This may give you a good hint about what is missing on
> your driver.
>
> Regards,
> Mauro

I'm checking return error codes, no problems there, I also added traces within the register functions and they all run fine. Here's my code that registers the demux device (note that the net device works fine):

static struct dvb_demux demux;
static struct dmxdev dmxdev;
static struct dvb_net net;
static struct dmx_frontend fe_hw;
static struct dmx_frontend fe_mem;

static int test_start_feed(struct dvb_demux_feed *feed)
{
	printk(KERN_INFO "%s executed\n", __FUNCTION__);
	return 0;
}

static int test_stop_feed(struct dvb_demux_feed *feed)
{
	printk(KERN_INFO "%s executed\n", __FUNCTION__);
	return 0;
}

static int test_write_to_decoder(struct dvb_demux_feed *feed, const u8 *buf, size_t len)
{
	printk(KERN_INFO "%s executed\n", __FUNCTION__);
	return 0;
}
	
// initialization specific demux device
void test_demux_device_init(struct dvb_adapter* adapter)
{
	int result;

	printk(KERN_INFO "%s executed\n", __FUNCTION__);
	
	memset(&demux, 0, sizeof(struct dvb_demux));

	demux.dmx.capabilities = DMX_TS_FILTERING | 
					  DMX_PES_FILTERING |
					  DMX_SECTION_FILTERING | 
					  DMX_MEMORY_BASED_FILTERING |
					  DMX_CRC_CHECKING | 
					  DMX_TS_DESCRAMBLING;

	demux.priv = NULL;	
	demux.filternum = 31;
	demux.feednum = 31;
	demux.start_feed = test_start_feed;
	demux.stop_feed = test_stop_feed;
	demux.write_to_decoder = test_write_to_decoder;

	printk(KERN_INFO "%s call dvb_dmx_init\n", __FUNCTION__);
	
	if ((result = dvb_dmx_init(&demux)) < 0) 
	{
		printk(KERN_ERR "%s: dvb_dmx_init failed\n", __FUNCTION__);
		goto init_failed;
	}

	dmxdev.filternum = 31;
	dmxdev.demux = &demux.dmx;
	dmxdev.capabilities = 0;

	printk(KERN_INFO "%s call dvb_dmxdev_init\n", __FUNCTION__);
	
	if ((result = dvb_dmxdev_init(&dmxdev, adapter)) < 0) 
	{
		printk(KERN_ERR "%s: dvb_dmxdev_init failed (errno=%d)\n", __FUNCTION__, result);
		goto init_failed_dmx_release;
	}

	fe_hw.source = DMX_FRONTEND_0;

	printk(KERN_INFO "%s call add_frontend\n", __FUNCTION__);
	
	if ((result = demux.dmx.add_frontend(&demux.dmx, &fe_hw)) < 0) 
	{
		printk(KERN_ERR "%s: add_frontend (hw) failed (errno=%d)\n", __FUNCTION__, result);
		goto init_failed_dmxdev_release;
	}

	fe_mem.source = DMX_MEMORY_FE;

	if ((result = demux.dmx.add_frontend(&demux.dmx, &fe_mem)) < 0) 
	{
		printk(KERN_ERR "%s: add_frontend (mem) failed (errno=%d)\n", __FUNCTION__, result);
		goto init_failed_remove_hw_frontend;
	}

	if ((result = demux.dmx.connect_frontend(&demux.dmx, &fe_hw)) < 0) 
	{
		printk(KERN_ERR "%s: connect_frontend failed (errno=%d)\n", __FUNCTION__, result);
		goto init_failed_remove_mem_frontend;
	}
	
	if ((result = dvb_net_init(adapter, &net, &demux.dmx)) < 0) 
	{
		printk(KERN_ERR "%s: dvb_net_init failed (errno=%d)\n", __FUNCTION__, result);
		goto init_failed_disconnect_frontend;
	}
	
init_failed_disconnect_frontend:
	demux.dmx.disconnect_frontend(&demux.dmx);
init_failed_remove_mem_frontend:
	demux.dmx.remove_frontend(&demux.dmx, &fe_mem);
init_failed_remove_hw_frontend:
	demux.dmx.remove_frontend(&demux.dmx, &fe_hw);
init_failed_dmxdev_release:
	dvb_dmxdev_release(&dmxdev);
init_failed_dmx_release:
	dvb_dmx_release(&demux);
init_failed:
	return;
}
EXPORT_SYMBOL(test_demux_device_init);

// terminate specific demux device
void test_demux_device_terminate(struct dvb_adapter* adapter)
{
	dvb_net_release(&net);
	demux.dmx.close(&demux.dmx);
	demux.dmx.disconnect_frontend(&demux.dmx);
	demux.dmx.remove_frontend(&demux.dmx, &fe_mem);
	demux.dmx.remove_frontend(&demux.dmx, &fe_hw);
	dvb_dmxdev_release(&dmxdev);
	dvb_dmx_release(&demux);
}
EXPORT_SYMBOL(test_demux_device_terminate);

Thanks,
Hamad

