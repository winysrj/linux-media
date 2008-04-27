Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JqEAb-0002mY-7z
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 23:12:29 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Ian Bonham <ian.bonham@gmail.com>
In-Reply-To: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
References: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
Date: Sun, 27 Apr 2008 23:11:13 +0200
Message-Id: <1209330673.2661.33.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] HVR4000 & Heron
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

Hi Ian,

Am Sonntag, den 27.04.2008, 22:18 +0200 schrieb Ian Bonham:
> Hi All.
> 
> Ok, so just installed the shiny, spangly new Ubuntu 8.04LTS (Hardy
> Heron) on my machine with the HVR4000 in, and now, no TV! It's gone on
> with kernel 2.6.24-16 on a P4 HyperThread, and everything worked just
> fine under Gutsy. I've pulled down the v4l-dvb tree (current and
> revision 127f67dea087 as suggested in Wiki) and tried patching with
> dev.kewl.org's MFE and SFE current patches (7285) and the latest. 
> 
> Everything 'seems' to compile Ok, and installs fine. When I reboot
> however I get a huge chunk of borked stuff and no card. (Dmesg output
> at end of message)
> 
> Could anyone please give me any pointers on how (or if) they have
> their HVR4000 running under Ubuntu 8.04LTS ?
> 
> Would really appriciate it.
> Thanks in advance,
> 
> Ian

see Michael Krufky's mail from Friday regarding the Avermedia A16D.

They also built a alsa version out of tree, which should be the reason
for some previous reports about symbol mismatches on saa7134-alsa.

Cheers,
Hermann


> DMESG Output: 
> cx88xx: disagrees about version of symbol videobuf_waiton 
> [   37.790909] cx88xx: Unknown symbol videobuf_waiton 
> [   37.791431] cx88xx: disagrees about version of symbol videobuf_dma_unmap 
> [   37.791433] cx88xx: Unknown symbol videobuf_dma_unmap 
> [   37.791607] cx88xx: disagrees about version of symbol video_device_alloc 
> [   37.791609] cx88xx: Unknown symbol video_device_alloc 
> [   37.791991] cx88xx: disagrees about version of symbol video_device_release 
> [   37.791993] cx88xx: Unknown symbol video_device_release 
> [   37.792279] cx88xx: disagrees about version of symbol videobuf_to_dma 
> [   37.792281] cx88xx: Unknown symbol videobuf_to_dma 
> [   37.793072] cx8800: disagrees about version of symbol videobuf_streamoff 
> [   37.793075] cx8800: Unknown symbol videobuf_streamoff 
> [   37.793167] cx8800: Unknown symbol cx88_reset 
> [   37.793206] cx8800: disagrees about version of symbol videobuf_poll_stream 
> [   37.793208] cx8800: Unknown symbol videobuf_poll_stream 
> [   37.793294] cx8800: Unknown symbol cx88_call_i2c_clients 
> [   37.793343] cx8800: Unknown symbol cx88_wakeup 
> [   37.793409] cx8800: Unknown symbol cx88_risc_stopper 
> [   37.793511] cx8800: Unknown symbol cx88_print_irqbits 
> [   37.793560] cx8800: Unknown symbol cx88_set_scale 
> [   37.793627] cx8800: Unknown symbol cx88_shutdown 
> [   37.793665] cx8800: disagrees about version of symbol videobuf_reqbufs 
> [   37.793668] cx8800: Unknown symbol videobuf_reqbufs 
> [   37.793716] cx8800: Unknown symbol cx88_vdev_init 
> [   37.793794] cx8800: Unknown symbol cx88_core_put 
> [   37.793865] cx8800: Unknown symbol cx88_audio_thread 
> [   37.793903] cx8800: disagrees about version of symbol videobuf_dqbuf 
> [   37.793906] cx8800: Unknown symbol videobuf_dqbuf 
> [   37.793954] cx8800: Unknown symbol cx88_core_irq 
> [   37.794023] cx8800: Unknown symbol cx88_core_get 
> [   37.794071] cx8800: Unknown symbol cx88_get_stereo 
> [   37.794120] cx8800: Unknown symbol cx88_ir_stop 
> [   37.794176] cx8800: Unknown symbol cx88_set_tvnorm 
> [   37.794232] cx8800: Unknown symbol cx88_ir_start 
> [   37.794316] cx8800: disagrees about version of symbol videobuf_stop 
> [   37.794318] cx8800: Unknown symbol videobuf_stop 
> [   37.794401] cx8800: Unknown symbol videobuf_queue_pci_init 
> [   37.794450] cx8800: Unknown symbol cx88_risc_buffer 
> [   37.794523] cx8800: disagrees about version of symbol videobuf_read_stream 
> [   37.794525] cx8800: Unknown symbol videobuf_read_stream 
> [   37.794590] cx8800: disagrees about version of symbol videobuf_querybuf 
> [   37.794592] cx8800: Unknown symbol videobuf_querybuf 
> [   37.794640] cx8800: Unknown symbol cx88_set_stereo 
> [   37.794678] cx8800: disagrees about version of symbol video_unregister_device 
> [   37.794681] cx8800: Unknown symbol video_unregister_device 
> [   37.794718] cx8800: disagrees about version of symbol videobuf_qbuf 
> [   37.794720] cx8800: Unknown symbol videobuf_qbuf 
> [   37.794780] cx8800: disagrees about version of symbol videobuf_read_one 
> [   37.794783] cx8800: Unknown symbol videobuf_read_one 
> [   37.794848] cx8800: Unknown symbol cx88_sram_channels 
> [   37.794886] cx8800: disagrees about version of symbol video_register_device 
> [   37.794888] cx8800: Unknown symbol video_register_device 
> [   37.794937] cx8800: Unknown symbol cx88_set_tvaudio 
> [   37.794985] cx8800: Unknown symbol cx88_sram_channel_dump 
> [   37.795060] cx8800: Unknown symbol cx88_sram_channel_setup 
> [   37.795106] cx8800: disagrees about version of symbol videobuf_iolock 
> [   37.795108] cx8800: Unknown symbol videobuf_iolock 
> [   37.795157] cx8800: Unknown symbol cx88_free_buffer 
> [   37.795194] cx8800: disagrees about version of symbol videobuf_streamon 
> [   37.795196] cx8800: Unknown symbol videobuf_streamon 
> [   37.795233] cx8800: disagrees about version of symbol videobuf_queue_cancel 
> [   37.795235] cx8800: Unknown symbol videobuf_queue_cancel 
> [   37.795305] cx8800: disagrees about version of symbol video_device_release 
> [   37.795307] cx8800: Unknown symbol video_device_release 
> [   37.795344] cx8800: disagrees about version of symbol videobuf_mmap_mapper 
> [   37.795346] cx8800: Unknown symbol videobuf_mmap_mapper 
> [   37.795390] cx8800: disagrees about version of symbol videobuf_cgmbuf 
> [   37.795393] cx8800: Unknown symbol videobuf_cgmbuf 
> [   37.795444] cx8800: Unknown symbol cx88_newstation 
> [   37.795502] cx8800: disagrees about version of symbol videobuf_to_dma 
> [   37.795504] cx8800: Unknown symbol videobuf_to_dma 
> [   37.795540] cx8800: disagrees about version of symbol videobuf_mmap_free 
> [   37.795542] cx8800: Unknown symbol videobuf_mmap_free 
> [   37.796563] cx88xx: disagrees about version of symbol videobuf_waiton 
> [   37.796566] cx88xx: Unknown symbol videobuf_waiton 
> [   37.797085] cx88xx: disagrees about version of symbol videobuf_dma_unmap 
> [   37.797087] cx88xx: Unknown symbol videobuf_dma_unmap 
> [   37.797260] cx88xx: disagrees about version of symbol video_device_alloc 
> [   37.797263] cx88xx: Unknown symbol video_device_alloc 
> [   37.797644] cx88xx: disagrees about version of symbol video_device_release 
> [   37.797646] cx88xx: Unknown symbol video_device_release 
> [   37.798242] cx88xx: disagrees about version of symbol videobuf_to_dma 
> [   37.798245] cx88xx: Unknown symbol videobuf_to_dma 
> [   37.799488] cx8802: Unknown symbol cx88_reset 
> [   37.799604] cx8802: Unknown symbol cx88_wakeup 
> [   37.799757] cx8802: Unknown symbol cx88_risc_stopper 
> [   37.799911] cx8802: Unknown symbol cx88_print_irqbits 
> [   37.800067] cx8802: Unknown symbol cx88_shutdown 
> [   37.800204] cx8802: Unknown symbol cx88_core_put 
> [   37.800368] cx8802: Unknown symbol cx88_core_irq 
> [   37.800521] cx8802: Unknown symbol cx88_core_get 
> [   37.800867] cx8802: Unknown symbol cx88_sram_channels 
> [   37.800979] cx8802: Unknown symbol cx88_sram_channel_dump 
> [   37.801108] cx8802: Unknown symbol cx88_sram_channel_setup 
> [   37.801216] cx8802: disagrees about version of symbol videobuf_iolock 
> [   37.801221] cx8802: Unknown symbol videobuf_iolock 
> [   37.801333] cx8802: Unknown symbol cx88_free_buffer 
> [   37.801526] cx8802: Unknown symbol cx88_risc_databuffer 
> [   37.801562] cx8802: disagrees about version of symbol videobuf_to_dma 
> [   37.801564] cx8802: Unknown symbol videobuf_to_dma 
> [   37.802526] cx88xx: disagrees about version of symbol videobuf_waiton 
> [   37.802528] cx88xx: Unknown symbol videobuf_waiton 
> [   37.803047] cx88xx: disagrees about version of symbol videobuf_dma_unmap 
> [   37.803049] cx88xx: Unknown symbol videobuf_dma_unmap 
> [   37.803223] cx88xx: disagrees about version of symbol video_device_alloc 
> [   37.803225] cx88xx: Unknown symbol video_device_alloc 
> [   37.803606] cx88xx: disagrees about version of symbol video_device_release 
> [   37.803609] cx88xx: Unknown symbol video_device_release 
> [   37.803899] cx88xx: disagrees about version of symbol videobuf_to_dma 
> [   37.803902] cx88xx: Unknown symbol videobuf_to_dma 
> [   37.805146] cx88_alsa: Unknown symbol cx88_print_irqbits 
> [   37.805345] cx88_alsa: Unknown symbol cx88_core_put 
> [   37.805435] cx88_alsa: Unknown symbol videobuf_pci_alloc 
> [   37.805484] cx88_alsa: Unknown symbol cx88_core_irq 
> [   37.805550] cx88_alsa: Unknown symbol cx88_core_get 
> [   37.805973] cx88_alsa: Unknown symbol cx88_sram_channels 
> [   37.806021] cx88_alsa: Unknown symbol cx88_sram_channel_dump 
> [   37.806088] cx88_alsa: Unknown symbol cx88_sram_channel_setup 
> [   37.806201] cx88_alsa: Unknown symbol videobuf_pci_dma_unmap 
> [   37.806301] cx88_alsa: Unknown symbol videobuf_pci_dma_map 
> [   37.806365] cx88_alsa: Unknown symbol cx88_risc_databuffer 
> [   37.806401] cx88_alsa: disagrees about version of symbol videobuf_to_dma 
> [   37.806404] cx88_alsa: Unknown symbol videobuf_to_dma 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
