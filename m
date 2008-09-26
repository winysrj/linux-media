Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 202.7.249.79.dynamic.rev.aanet.com.au ([202.7.249.79]
	helo=home.singlespoon.org.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <paulc@singlespoon.org.au>) id 1Kj8ls-0000Xj-Ly
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 10:33:54 +0200
Message-ID: <48DC9DEA.3080707@singlespoon.org.au>
Date: Fri, 26 Sep 2008 18:31:38 +1000
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: allan k <sonofzev@iinet.net.au>
References: <1222402903.8329.4.camel@media1>	
	<48DC7EF0.3050205@singlespoon.org.au>
	<1222411185.8172.2.camel@media1>
In-Reply-To: <1222411185.8172.2.camel@media1>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] unknown v4l symbols from dmesg on reboot
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

Allan,
          the other thing you could try would be to do an lsmod before 
you reload and direct the output into a file. Do the same after the 
reload and then do a diff on the two files. This should show if there 
are modules being loaded the first time but not the second. Perhaps 
there is a rule somewhere that is loading something.

BTW Gentoo is brilliant for keeping up with the latest kernel, that is 
one thing I miss having moved to Ubuntu. I chose Gentoo to bootstrap my 
knowledge but after a while I stopped learning and then it began getting 
in the way:-P

Cheers Paul

allan k wrote:
> Thanks Paul 
>
> Unfortuately removing all the drivers and doing 'make install' again,
> didn't work. 
>
> For the meantime, I have added the relevant modprobe -r and modprobe
> lines into my /etc/conf.d/local.start file. This is a nice gentoo
> facility that provides a workaround for problems like this
>
> Hopefully before too long the driver I need will be in-kernel. 
>
> cheers
>
> Allan 
>
>
> On Fri, 2008-09-26 at 16:19 +1000, Paul Chubb wrote:
>   
>> Hi Allan,
>> this is caused by mismatch between components of the v4l-dvb drivers. 
>> You see this behaviour when part of the compiled code is replaced by a 
>> new version but some of the old code is still there. Specifically you 
>> generally see this if the kernel has some of the v4l stuff compiled in 
>> and not as modules. The other cause that I personally have seen is where 
>> a driver is removed from the newer code because it is no longer needed 
>> however when you do the make install, the old driver remains. In that 
>> case what I did was to remove everything in the module video directory 
>> before doing a make install.
>>
>> HTH
>>
>> Cheers Paul
>>
>> allan k wrote:
>>     
>>> Hi 
>>>
>>> After upgrading to 2.6.26 and updating my v4l-dvb modules last night. I
>>> get alot of messages about unknown symbols and the driver fails to
>>> start. (at end of message)
>>>
>>> IF I do a modprobe -r on my bt878 and cx23885 modules and the reload
>>> them with modprobe everything works fine. 
>>>
>>> Is there a way to fix this?
>>>
>>> cheers
>>>
>>> Allan
>>>
>>> pci 0000:05:00.0: Boot video device
>>> videobuf_dma_sg: disagrees about version of symbol videobuf_alloc
>>> videobuf_dma_sg: Unknown symbol videobuf_alloc
>>> videobuf_dma_sg: disagrees about version of symbol
>>> videobuf_queue_core_init
>>> videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
>>> videobuf_dma_sg: disagrees about version of symbol videobuf_alloc
>>> videobuf_dma_sg: Unknown symbol videobuf_alloc
>>> videobuf_dma_sg: disagrees about version of symbol
>>> videobuf_queue_core_init
>>> videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
>>> videobuf_dvb: disagrees about version of symbol videobuf_read_stop
>>> videobuf_dvb: Unknown symbol videobuf_read_stop
>>> videobuf_dvb: disagrees about version of symbol videobuf_waiton
>>> videobuf_dvb: Unknown symbol videobuf_waiton
>>> videobuf_dvb: disagrees about version of symbol
>>> videobuf_queue_to_vmalloc
>>> videobuf_dvb: Unknown symbol videobuf_queue_to_vmalloc
>>> videobuf_dvb: disagrees about version of symbol videobuf_read_start
>>> videobuf_dvb: Unknown symbol videobuf_read_start
>>> videobuf_dma_sg: disagrees about version of symbol videobuf_alloc
>>> videobuf_dma_sg: Unknown symbol videobuf_alloc
>>> videobuf_dma_sg: disagrees about version of symbol
>>> videobuf_queue_core_init
>>> videobuf_dma_sg: Unknown symbol videobuf_queue_core_init
>>> Linux video capture interface: v2.00
>>> cx23885: disagrees about version of symbol videobuf_streamoff
>>> cx23885: Unknown symbol videobuf_streamoff
>>> cx23885: disagrees about version of symbol videobuf_poll_stream
>>> cx23885: Unknown symbol videobuf_poll_stream
>>> cx23885: disagrees about version of symbol videobuf_read_stop
>>> cx23885: Unknown symbol videobuf_read_stop
>>> cx23885: Unknown symbol videobuf_dma_free
>>> cx23885: disagrees about version of symbol videobuf_reqbufs
>>> cx23885: Unknown symbol videobuf_reqbufs
>>> cx23885: disagrees about version of symbol videobuf_waiton
>>> cx23885: Unknown symbol videobuf_waiton
>>> cx23885: disagrees about version of symbol videobuf_dqbuf
>>> cx23885: Unknown symbol videobuf_dqbuf
>>> cx23885: Unknown symbol videobuf_queue_sg_init
>>> cx23885: Unknown symbol videobuf_dvb_unregister
>>> cx23885: Unknown symbol videobuf_dma_unmap
>>> cx23885: disagrees about version of symbol videobuf_read_stream
>>> cx23885: Unknown symbol videobuf_read_stream
>>> cx23885: Unknown symbol videobuf_dvb_register
>>> cx23885: disagrees about version of symbol videobuf_querybuf
>>> cx23885: Unknown symbol videobuf_querybuf
>>> cx23885: disagrees about version of symbol videobuf_qbuf
>>> cx23885: Unknown symbol videobuf_qbuf
>>> cx23885: disagrees about version of symbol videobuf_read_one
>>> cx23885: Unknown symbol videobuf_read_one
>>> cx23885: disagrees about version of symbol videobuf_iolock
>>> cx23885: Unknown symbol videobuf_iolock
>>> cx23885: disagrees about version of symbol videobuf_streamon
>>> cx23885: Unknown symbol videobuf_streamon
>>> cx23885: disagrees about version of symbol videobuf_queue_cancel
>>> cx23885: Unknown symbol videobuf_queue_cancel
>>> cx23885: disagrees about version of symbol videobuf_mmap_mapper
>>> cx23885: Unknown symbol videobuf_mmap_mapper
>>> cx23885: Unknown symbol videobuf_to_dma
>>> cx23885: disagrees about version of symbol videobuf_mmap_free
>>> cx23885: Unknown symbol videobuf_mmap_free
>>> bttv: disagrees about version of symbol videobuf_streamoff
>>> bttv: Unknown symbol videobuf_streamoff
>>> bttv: disagrees about version of symbol videobuf_poll_stream
>>> bttv: Unknown symbol videobuf_poll_stream
>>> bttv: disagrees about version of symbol __videobuf_mmap_setup
>>> bttv: Unknown symbol __videobuf_mmap_setup
>>> bttv: Unknown symbol videobuf_dma_free
>>> bttv: disagrees about version of symbol videobuf_reqbufs
>>> bttv: Unknown symbol videobuf_reqbufs
>>> bttv: disagrees about version of symbol videobuf_waiton
>>> bttv: Unknown symbol videobuf_waiton
>>> bttv: disagrees about version of symbol videobuf_queue_is_busy
>>> bttv: Unknown symbol videobuf_queue_is_busy
>>> bttv: disagrees about version of symbol videobuf_dqbuf
>>> bttv: Unknown symbol videobuf_dqbuf
>>> bttv: disagrees about version of symbol videobuf_stop
>>> bttv: Unknown symbol videobuf_stop
>>> bttv: Unknown symbol videobuf_queue_sg_init
>>> bttv: Unknown symbol videobuf_dma_unmap
>>> bttv: disagrees about version of symbol videobuf_read_stream
>>> bttv: Unknown symbol videobuf_read_stream
>>> bttv: Unknown symbol videobuf_sg_alloc
>>> bttv: disagrees about version of symbol videobuf_querybuf
>>> bttv: Unknown symbol videobuf_querybuf
>>> bttv: disagrees about version of symbol videobuf_qbuf
>>> bttv: Unknown symbol videobuf_qbuf
>>> bttv: disagrees about version of symbol videobuf_read_one
>>> bttv: Unknown symbol videobuf_read_one
>>> bttv: disagrees about version of symbol videobuf_iolock
>>> bttv: Unknown symbol videobuf_iolock
>>> bttv: disagrees about version of symbol videobuf_streamon
>>> bttv: Unknown symbol videobuf_streamon
>>> bttv: disagrees about version of symbol videobuf_next_field
>>> bttv: Unknown symbol videobuf_next_field
>>> bttv: disagrees about version of symbol videobuf_mmap_mapper
>>> bttv: Unknown symbol videobuf_mmap_mapper
>>> bttv: Unknown symbol videobuf_to_dma
>>> bttv: disagrees about version of symbol videobuf_mmap_free
>>> bttv: Unknown symbol videobuf_mmap_free
>>> bttv: disagrees about version of symbol videobuf_streamoff
>>> bttv: Unknown symbol videobuf_streamoff
>>> bttv: disagrees about version of symbol videobuf_poll_stream
>>> bttv: Unknown symbol videobuf_poll_stream
>>> bttv: disagrees about version of symbol __videobuf_mmap_setup
>>> bttv: Unknown symbol __videobuf_mmap_setup
>>> bttv: Unknown symbol videobuf_dma_free
>>> bttv: disagrees about version of symbol videobuf_reqbufs
>>> bttv: Unknown symbol videobuf_reqbufs
>>> bttv: disagrees about version of symbol videobuf_waiton
>>> bttv: Unknown symbol videobuf_waiton
>>> bttv: disagrees about version of symbol videobuf_queue_is_busy
>>> bttv: Unknown symbol videobuf_queue_is_busy
>>> bttv: disagrees about version of symbol videobuf_dqbuf
>>> bttv: Unknown symbol videobuf_dqbuf
>>> bttv: disagrees about version of symbol videobuf_stop
>>> bttv: Unknown symbol videobuf_stop
>>> bttv: Unknown symbol videobuf_queue_sg_init
>>> bttv: Unknown symbol videobuf_dma_unmap
>>> bttv: disagrees about version of symbol videobuf_read_stream
>>> bttv: Unknown symbol videobuf_read_stream
>>> bttv: Unknown symbol videobuf_sg_alloc
>>> bttv: disagrees about version of symbol videobuf_querybuf
>>> bttv: Unknown symbol videobuf_querybuf
>>> bttv: disagrees about version of symbol videobuf_qbuf
>>> bttv: Unknown symbol videobuf_qbuf
>>> bttv: disagrees about version of symbol videobuf_read_one
>>> bttv: Unknown symbol videobuf_read_one
>>> bttv: disagrees about version of symbol videobuf_iolock
>>> bttv: Unknown symbol videobuf_iolock
>>> bttv: disagrees about version of symbol videobuf_streamon
>>> bttv: Unknown symbol videobuf_streamon
>>> bttv: disagrees about version of symbol videobuf_next_field
>>> bttv: Unknown symbol videobuf_next_field
>>> bttv: disagrees about version of symbol videobuf_mmap_mapper
>>> bttv: Unknown symbol videobuf_mmap_mapper
>>> bttv: Unknown symbol videobuf_to_dma
>>> bttv: disagrees about version of symbol videobuf_mmap_free
>>> bttv: Unknown symbol videobuf_mmap_free
>>>
>>>
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>   
>>>       
>>     
>
>   


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
