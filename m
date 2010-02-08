Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45223 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0BHMnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 07:43:39 -0500
Subject: Re: [SAA7134, REQUEST] slow register writing
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <201002080859.23332.hverkuil@xs4all.nl>
References: <20100208162014.1c12ec9a@glory.loctelecom.ru>
	 <201002080859.23332.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 08 Feb 2010 07:43:11 -0500
Message-Id: <1265632991.3070.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-02-08 at 08:59 +0100, Hans Verkuil wrote:
> On Monday 08 February 2010 08:20:14 Dmitri Belimov wrote:
> > Hi All.
> > 
> > I wrote SPI bitbang master over GPIO of saa7134. Speed of writing is much slow then in a Windows systems.
> > I make some tests:
> > 
> > Windows, SPI bitbang 97002 bytes x 2 time of writing is around 1.2 seconds
> > Linux, SPI bitbang with call saa7134_set_gpio time of writing is 18 seconds
> > Linux, SPI bitbang without call saa7134_set_gpio time of writing is 0.25seconds.
> > 
> > The overhead of SPI subsystem is 0.25 seconds. Writing speed to registers of the saa7134
> > tooooo slooooow.
> > 
> > What you think about it?
> 
> Internally the spi subsystem uses delays based on some nsecs parameter. I see some
> interesting code in spi_bitbang.h under #ifdef EXPAND_BITBANG_TXRX. My guess is
> that you use the default timings from the spi subsystem that are too high for this
> card.
> 
> Try to discover what timings are currently in use and see if they match the
> hardware spec. If not, then you should figure out how to optimize that.


Dmitri,

When looking for timing problems in the kernel, I found the tracing
facility to be very useful.




Using tracing on the ivtv driver, I found that
ivtv-mailbox.c:ivtv_api_get_data() is a simple function being
simply inefficient.  It's consuming about half the time used in
the ivtv_rq_handler() mostly doing uneeded PCI MMIO.

Here's a typical example where ivtv_api_get_data() takes over half of
the total execution time of the ivtv_irq_handler():

 1)               |  ivtv_irq_handler() {
 1) + 53.471 us   |    ivtv_api_get_data();
 1)               |    stream_enc_dma_append() {
 1)               |      ivtv_queue_move() {
 1)   1.064 us    |        ivtv_queue_move_buf();
 1)   2.943 us    |      }
 1)   0.824 us    |      pci_dma_sync_single_for_device();
 1) + 15.472 us   |    }
 1)               |    ivtv_dma_enc_start() {
 1)               |      ivtv_queue_move() {
 1)   0.894 us    |        ivtv_queue_move_buf();
 1)   2.730 us    |      }
 1)               |      ivtv_dma_enc_start_xfer() {
 1)   0.845 us    |        pci_dma_sync_single_for_device();
 1)   7.282 us    |      }
 1) + 13.088 us   |    }
 1) + 91.243 us   |  }


And another example:

 1)               |  ivtv_irq_handler() {
 1) + 41.701 us   |    ivtv_api_get_data();
 1)   0.884 us    |    pci_dma_sync_single_for_cpu();
 1)               |    dma_post() {
 1)   1.514 us    |      pci_dma_sync_single_for_cpu();
 1)               |      ivtv_queue_move() {
 1)   0.881 us    |        ivtv_queue_move_buf();
 1)   2.879 us    |      }
 1) + 12.360 us   |    }
 1) + 64.144 us   |  }



Here's how I set up this sort of tracing on my Fedora 12 machine, in
case you wish to try something similar:

1. Set up access to the kernel tracer

$ su - root
# mount
# ls -al /sys/kernel/debug/
# mount -t debugfs debug /sys/kernel/debug/
# mount
# less /sys/kernel/debug/tracing/README


2. Enable dynamic function tracing

# cat /proc/sys/kernel/ftrace_enabled 
# echo 1 > /proc/sys/kernel/ftrace_enabled
# cat /sys/kernel/debug/tracing/available_filter_functions 


3. Perform a function_graph trace of the ivtv.ko module functions except
the I2C bus calls

# echo function_graph > /sys/kernel/debug/tracing/current_tracer
# echo 0 > /sys/kernel/debug/tracing/options/latency-format 
# echo 0 > /sys/kernel/debug/tracing/options/verbose
# echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
# echo > /sys/kernel/debug/tracing/set_ftrace_filter 
# nm --defined-only /lib/modules/`uname -r`/kernel/drivers/media/video/ivtv/ivtv.ko | \
        grep ' [Tt] ' | grep -v trace | grep -v 'ivtv_[sg]ets[cd][al]' | \
        grep -v map_single | awk '{print $3}' > /sys/kernel/debug/tracing/set_ftrace_filter 
# echo 1 > /sys/kernel/debug/tracing/tracing_enabled 
     (perform 'cat /dev/video0 > foo.mpg' in another window for a bit)
# echo 0 > /sys/kernel/debug/tracing/tracing_enabled 
# cat /sys/kernel/debug/tracing/trace > t1.txt
# less t1.txt 


4. Perform a function latency trace of the ivtv.ko module functions
except for I2C bus calls

# echo function > /sys/kernel/debug/tracing/current_tracer
# echo 1 > /sys/kernel/debug/tracing/options/latency-format 
# echo 1 > /sys/kernel/debug/tracing/options/verbose
# echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
# echo > /sys/kernel/debug/tracing/set_ftrace_filter 
# nm --defined-only /lib/modules/`uname -r`/kernel/drivers/media/video/ivtv/ivtv.ko | \
        grep ' [Tt] ' | grep -v trace | grep -v 'ivtv_[sg]ets[cd][al]' | \
        grep -v map_single | awk '{print $3}' > /sys/kernel/debug/tracing/set_ftrace_filter 
# echo 1 > /sys/kernel/debug/tracing/tracing_enabled 
     (perform 'cat /dev/video0 > foo.mpg' in another window for a bit)
# echo 0 > /sys/kernel/debug/tracing/tracing_enabled 
# cat /sys/kernel/debug/tracing/trace > t2.txt
# less t2.txt 


Hopefully that can help you set up an experiment to find your timing
delays.

Regards,
Andy

