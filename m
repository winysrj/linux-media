Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Kj4q1-0004Gt-JV
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 06:21:56 +0200
From: allan k <sonofzev@iinet.net.au>
To: linux-dvb@linuxtv.org
Date: Fri, 26 Sep 2008 14:21:43 +1000
Message-Id: <1222402903.8329.4.camel@media1>
Mime-Version: 1.0
Subject: [linux-dvb] unknown v4l symbols from dmesg on reboot
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>



Hi 

After upgrading to 2.6.26 and updating my v4l-dvb modules last night. I
get alot of messages about unknown symbols and the driver fails to
start. (at end of message)

IF I do a modprobe -r on my bt878 and cx23885 modules and the reload
them with modprobe everything works fine. 

Is there a way to fix this?

cheers

Allan

pci 0000:05:00.0: Boot video device
videobuf_dma_sg: disagrees about version of symbol videobuf_alloc
videobuf_dma_sg: Unknown symbol videobuf_alloc
videobuf_dma_sg: disagrees about version of symbol
videobuf_queue_core_init
videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
videobuf_dma_sg: disagrees about version of symbol videobuf_alloc
videobuf_dma_sg: Unknown symbol videobuf_alloc
videobuf_dma_sg: disagrees about version of symbol
videobuf_queue_core_init
videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
videobuf_dvb: disagrees about version of symbol videobuf_read_stop
videobuf_dvb: Unknown symbol videobuf_read_stop
videobuf_dvb: disagrees about version of symbol videobuf_waiton
videobuf_dvb: Unknown symbol videobuf_waiton
videobuf_dvb: disagrees about version of symbol
videobuf_queue_to_vmalloc
videobuf_dvb: Unknown symbol videobuf_queue_to_vmalloc
videobuf_dvb: disagrees about version of symbol videobuf_read_start
videobuf_dvb: Unknown symbol videobuf_read_start
videobuf_dma_sg: disagrees about version of symbol videobuf_alloc
videobuf_dma_sg: Unknown symbol videobuf_alloc
videobuf_dma_sg: disagrees about version of symbol
videobuf_queue_core_init
videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
Linux video capture interface: v2.00
cx23885: disagrees about version of symbol videobuf_streamoff
cx23885: Unknown symbol videobuf_streamoff
cx23885: disagrees about version of symbol videobuf_poll_stream
cx23885: Unknown symbol videobuf_poll_stream
cx23885: disagrees about version of symbol videobuf_read_stop
cx23885: Unknown symbol videobuf_read_stop
cx23885: Unknown symbol videobuf_dma_free
cx23885: disagrees about version of symbol videobuf_reqbufs
cx23885: Unknown symbol videobuf_reqbufs
cx23885: disagrees about version of symbol videobuf_waiton
cx23885: Unknown symbol videobuf_waiton
cx23885: disagrees about version of symbol videobuf_dqbuf
cx23885: Unknown symbol videobuf_dqbuf
cx23885: Unknown symbol videobuf_queue_sg_init
cx23885: Unknown symbol videobuf_dvb_unregister
cx23885: Unknown symbol videobuf_dma_unmap
cx23885: disagrees about version of symbol videobuf_read_stream
cx23885: Unknown symbol videobuf_read_stream
cx23885: Unknown symbol videobuf_dvb_register
cx23885: disagrees about version of symbol videobuf_querybuf
cx23885: Unknown symbol videobuf_querybuf
cx23885: disagrees about version of symbol videobuf_qbuf
cx23885: Unknown symbol videobuf_qbuf
cx23885: disagrees about version of symbol videobuf_read_one
cx23885: Unknown symbol videobuf_read_one
cx23885: disagrees about version of symbol videobuf_iolock
cx23885: Unknown symbol videobuf_iolock
cx23885: disagrees about version of symbol videobuf_streamon
cx23885: Unknown symbol videobuf_streamon
cx23885: disagrees about version of symbol videobuf_queue_cancel
cx23885: Unknown symbol videobuf_queue_cancel
cx23885: disagrees about version of symbol videobuf_mmap_mapper
cx23885: Unknown symbol videobuf_mmap_mapper
cx23885: Unknown symbol videobuf_to_dma
cx23885: disagrees about version of symbol videobuf_mmap_free
cx23885: Unknown symbol videobuf_mmap_free
bttv: disagrees about version of symbol videobuf_streamoff
bttv: Unknown symbol videobuf_streamoff
bttv: disagrees about version of symbol videobuf_poll_stream
bttv: Unknown symbol videobuf_poll_stream
bttv: disagrees about version of symbol __videobuf_mmap_setup
bttv: Unknown symbol __videobuf_mmap_setup
bttv: Unknown symbol videobuf_dma_free
bttv: disagrees about version of symbol videobuf_reqbufs
bttv: Unknown symbol videobuf_reqbufs
bttv: disagrees about version of symbol videobuf_waiton
bttv: Unknown symbol videobuf_waiton
bttv: disagrees about version of symbol videobuf_queue_is_busy
bttv: Unknown symbol videobuf_queue_is_busy
bttv: disagrees about version of symbol videobuf_dqbuf
bttv: Unknown symbol videobuf_dqbuf
bttv: disagrees about version of symbol videobuf_stop
bttv: Unknown symbol videobuf_stop
bttv: Unknown symbol videobuf_queue_sg_init
bttv: Unknown symbol videobuf_dma_unmap
bttv: disagrees about version of symbol videobuf_read_stream
bttv: Unknown symbol videobuf_read_stream
bttv: Unknown symbol videobuf_sg_alloc
bttv: disagrees about version of symbol videobuf_querybuf
bttv: Unknown symbol videobuf_querybuf
bttv: disagrees about version of symbol videobuf_qbuf
bttv: Unknown symbol videobuf_qbuf
bttv: disagrees about version of symbol videobuf_read_one
bttv: Unknown symbol videobuf_read_one
bttv: disagrees about version of symbol videobuf_iolock
bttv: Unknown symbol videobuf_iolock
bttv: disagrees about version of symbol videobuf_streamon
bttv: Unknown symbol videobuf_streamon
bttv: disagrees about version of symbol videobuf_next_field
bttv: Unknown symbol videobuf_next_field
bttv: disagrees about version of symbol videobuf_mmap_mapper
bttv: Unknown symbol videobuf_mmap_mapper
bttv: Unknown symbol videobuf_to_dma
bttv: disagrees about version of symbol videobuf_mmap_free
bttv: Unknown symbol videobuf_mmap_free
bttv: disagrees about version of symbol videobuf_streamoff
bttv: Unknown symbol videobuf_streamoff
bttv: disagrees about version of symbol videobuf_poll_stream
bttv: Unknown symbol videobuf_poll_stream
bttv: disagrees about version of symbol __videobuf_mmap_setup
bttv: Unknown symbol __videobuf_mmap_setup
bttv: Unknown symbol videobuf_dma_free
bttv: disagrees about version of symbol videobuf_reqbufs
bttv: Unknown symbol videobuf_reqbufs
bttv: disagrees about version of symbol videobuf_waiton
bttv: Unknown symbol videobuf_waiton
bttv: disagrees about version of symbol videobuf_queue_is_busy
bttv: Unknown symbol videobuf_queue_is_busy
bttv: disagrees about version of symbol videobuf_dqbuf
bttv: Unknown symbol videobuf_dqbuf
bttv: disagrees about version of symbol videobuf_stop
bttv: Unknown symbol videobuf_stop
bttv: Unknown symbol videobuf_queue_sg_init
bttv: Unknown symbol videobuf_dma_unmap
bttv: disagrees about version of symbol videobuf_read_stream
bttv: Unknown symbol videobuf_read_stream
bttv: Unknown symbol videobuf_sg_alloc
bttv: disagrees about version of symbol videobuf_querybuf
bttv: Unknown symbol videobuf_querybuf
bttv: disagrees about version of symbol videobuf_qbuf
bttv: Unknown symbol videobuf_qbuf
bttv: disagrees about version of symbol videobuf_read_one
bttv: Unknown symbol videobuf_read_one
bttv: disagrees about version of symbol videobuf_iolock
bttv: Unknown symbol videobuf_iolock
bttv: disagrees about version of symbol videobuf_streamon
bttv: Unknown symbol videobuf_streamon
bttv: disagrees about version of symbol videobuf_next_field
bttv: Unknown symbol videobuf_next_field
bttv: disagrees about version of symbol videobuf_mmap_mapper
bttv: Unknown symbol videobuf_mmap_mapper
bttv: Unknown symbol videobuf_to_dma
bttv: disagrees about version of symbol videobuf_mmap_free
bttv: Unknown symbol videobuf_mmap_free



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
