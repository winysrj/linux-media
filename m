Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:35564 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbZHWXYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 19:24:06 -0400
Subject: Re: [DVB] Sticky module dvb_pll
From: hermann pitton <hermann-pitton@arcor.de>
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4A913FE4.8040003@cadsoft.de>
References: <4A913FE4.8040003@cadsoft.de>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 01:20:29 +0200
Message-Id: <1251069629.3272.13.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 23.08.2009, 15:11 +0200 schrieb Klaus Schmidinger:
> When I use the latest driver from http://linuxtv.org/hg/v4l-dvb (4d727d223236)
> and load all the modules I need, as in
> 
> /sbin/modprobe firmware_class
> /sbin/modprobe i2c-core
> /sbin/insmod ./v4l1-compat.ko
> /sbin/insmod ./cx24113.ko
> /sbin/insmod ./s5h1420.ko
> /sbin/insmod ./videobuf-core.ko
> /sbin/insmod ./ttpci-eeprom.ko
> /sbin/insmod ./cx24123.ko
> /sbin/insmod ./saa7146.ko
> /sbin/insmod ./videodev.ko
> /sbin/insmod ./videobuf-dma-sg.ko
> /sbin/insmod ./saa7146_vv.ko
> /sbin/insmod ./mt352.ko
> /sbin/insmod ./ves1x93.ko
> /sbin/insmod ./dvb-core.ko
> /sbin/insmod ./stv0299.ko
> /sbin/insmod ./dvb-ttpci.ko
> /sbin/insmod ./budget-core.ko
> /sbin/insmod ./budget.ko
> /sbin/insmod ./b2c2-flexcop.ko
> /sbin/insmod ./b2c2-flexcop-pci.ko
> 
> lsmod shows
> 
> Module                  Size  Used by
> dvb_pll                16392  1
> b2c2_flexcop_pci       14484  0
> b2c2_flexcop           37004  1 b2c2_flexcop_pci
> budget                 21508  0
> budget_core            15748  1 budget
> dvb_ttpci             351180  0
> stv0299                14984  1
> dvb_core               95724  5 b2c2_flexcop,budget,budget_core,dvb_ttpci,stv0299
> ves1x93                10884  2
> mt352                  10756  1
> saa7146_vv             52352  1 dvb_ttpci
> videobuf_dma_sg        18948  1 saa7146_vv
> videodev               44704  1 saa7146_vv
> saa7146                23816  4 budget,budget_core,dvb_ttpci,saa7146_vv
> cx24123                18824  1 b2c2_flexcop
> ttpci_eeprom            6656  2 budget_core,dvb_ttpci
> videobuf_core          23556  2 saa7146_vv,videobuf_dma_sg
> s5h1420                16388  1 b2c2_flexcop
> cx24113                12420  1 b2c2_flexcop
> v4l1_compat            18052  1 videodev
> w83781d                34984  0
> hwmon_vid               7040  1 w83781d
> iptable_filter          7552  0
> ip_tables              17936  1 iptable_filter
> ip6_tables             19088  0
> x_tables               21380  2 ip_tables,ip6_tables
> nfs                   266964  1
> lockd                  72312  2 nfs
> nfs_acl                 7680  1 nfs
> sunrpc                197372  13 nfs,lockd,nfs_acl
> af_packet              26368  0
> fuse                   54044  1
> loop                   23044  0
> dm_mod                 66388  0
> ppdev                  13060  0
> rtc_cmos               14752  0
> rtc_core               24860  1 rtc_cmos
> rtc_lib                 7040  1 rtc_core
> parport_pc             42428  0
> parport                40660  2 ppdev,parport_pc
> 8139too                30976  0
> sr_mod                 21160  0
> cdrom                  38300  1 sr_mod
> i2c_ali1535            11268  0
> 8139cp                 27392  0
> i2c_ali15x3            12036  0
> firmware_class         13696  3 b2c2_flexcop,budget,dvb_ttpci
> ali_agp                11136  1
> mii                     9600  2 8139too,8139cp
> shpchp                 37780  0
> i2c_core               28820  15 dvb_pll,b2c2_flexcop,budget,budget_core,dvb_ttpci,stv0299,ves1x93,mt352,cx24123,ttpci_eeprom,s5h1420,cx24113,w83781d,i2c_ali1535,i2c_ali15x3
> agpgart                38580  1 ali_agp
> pci_hotplug            33828  1 shpchp
> alim7101_wdt           11928  0
> sg                     39732  0
> sd_mod                 33048  4
> ohci_hcd               27396  0
> usbcore               152268  2 ohci_hcd
> edd                    14152  0
> ext3                  143880  2
> mbcache                13060  1 ext3
> jbd                    61216  1 ext3
> pata_ali               15620  3
> libata                164316  1 pata_ali
> scsi_mod              156404  4 sr_mod,sg,sd_mod,libata
> dock                   15248  1 libata
> 
> If immediately after that I do
> 
> /sbin/rmmod dvb_ttpci
> /sbin/rmmod saa7146_vv
> /sbin/rmmod budget
> /sbin/rmmod b2c2_flexcop_pci
> /sbin/rmmod budget_core
> /sbin/rmmod stv0299
> /sbin/rmmod b2c2_flexcop
> /sbin/rmmod videodev
> /sbin/rmmod videobuf_dma_sg
> /sbin/rmmod cx24113
> /sbin/rmmod saa7146
> /sbin/rmmod ttpci_eeprom
> /sbin/rmmod ves1x93
> /sbin/rmmod s5h1420
> /sbin/rmmod mt352
> /sbin/rmmod v4l1_compat
> /sbin/rmmod dvb_core
> /sbin/rmmod dvb_pll
> ERROR: Module dvb_pll is in use
> /sbin/rmmod videobuf_core
> /sbin/rmmod cx24123
> 
> I get an error when trying to rmmod dvb_pll.
> lsmod then shows
> 
> Module                  Size  Used by
> dvb_pll                16392  1
> w83781d                34984  0
> hwmon_vid               7040  1 w83781d
> iptable_filter          7552  0
> ip_tables              17936  1 iptable_filter
> ip6_tables             19088  0
> x_tables               21380  2 ip_tables,ip6_tables
> nfs                   266964  1
> lockd                  72312  2 nfs
> nfs_acl                 7680  1 nfs
> sunrpc                197372  13 nfs,lockd,nfs_acl
> af_packet              26368  0
> fuse                   54044  1
> loop                   23044  0
> dm_mod                 66388  0
> ppdev                  13060  0
> rtc_cmos               14752  0
> rtc_core               24860  1 rtc_cmos
> rtc_lib                 7040  1 rtc_core
> parport_pc             42428  0
> parport                40660  2 ppdev,parport_pc
> 8139too                30976  0
> sr_mod                 21160  0
> cdrom                  38300  1 sr_mod
> i2c_ali1535            11268  0
> 8139cp                 27392  0
> i2c_ali15x3            12036  0
> firmware_class         13696  0
> ali_agp                11136  1
> mii                     9600  2 8139too,8139cp
> shpchp                 37780  0
> i2c_core               28820  4 dvb_pll,w83781d,i2c_ali1535,i2c_ali15x3
> agpgart                38580  1 ali_agp
> pci_hotplug            33828  1 shpchp
> alim7101_wdt           11928  0
> sg                     39732  0
> sd_mod                 33048  4
> ohci_hcd               27396  0
> usbcore               152268  2 ohci_hcd
> edd                    14152  0
> ext3                  143880  2
> mbcache                13060  1 ext3
> jbd                    61216  1 ext3
> pata_ali               15620  3
> libata                164316  1 pata_ali
> scsi_mod              156404  4 sr_mod,sg,sd_mod,libata
> dock                   15248  1 libata
> 
> Only an explicit
> 
> rmmod -f dvb_pll
> 
> removes the dvb_pll module and lsmod goes to
> 
> Module                  Size  Used by
> w83781d                34984  0
> hwmon_vid               7040  1 w83781d
> iptable_filter          7552  0
> ip_tables              17936  1 iptable_filter
> ip6_tables             19088  0
> x_tables               21380  2 ip_tables,ip6_tables
> nfs                   266964  1
> lockd                  72312  2 nfs
> nfs_acl                 7680  1 nfs
> sunrpc                197372  13 nfs,lockd,nfs_acl
> af_packet              26368  0
> fuse                   54044  1
> loop                   23044  0
> dm_mod                 66388  0
> ppdev                  13060  0
> rtc_cmos               14752  0
> rtc_core               24860  1 rtc_cmos
> rtc_lib                 7040  1 rtc_core
> parport_pc             42428  0
> parport                40660  2 ppdev,parport_pc
> 8139too                30976  0
> sr_mod                 21160  0
> cdrom                  38300  1 sr_mod
> i2c_ali1535            11268  0
> 8139cp                 27392  0
> i2c_ali15x3            12036  0
> firmware_class         13696  0
> ali_agp                11136  1
> mii                     9600  2 8139too,8139cp
> shpchp                 37780  0
> i2c_core               28820  3 w83781d,i2c_ali1535,i2c_ali15x3
> agpgart                38580  1 ali_agp
> pci_hotplug            33828  1 shpchp
> alim7101_wdt           11928  0
> sg                     39732  0
> sd_mod                 33048  4
> ohci_hcd               27396  0
> usbcore               152268  2 ohci_hcd
> edd                    14152  0
> ext3                  143880  2
> mbcache                13060  1 ext3
> jbd                    61216  1 ext3
> pata_ali               15620  3
> libata                164316  1 pata_ali
> scsi_mod              156404  4 sr_mod,sg,sd_mod,libata
> dock                   15248  1 libata
> 
> 
> Is this normal behavior, or should dvb_pll be removed with a
> plain rmmod?
> 
> 
> Klaus
> 

Hm, dvb-pll was some most conflicting stuff, when it came to happen,
that all sort of multiple hybrid devices de facto appeared on the
markets.

IIRC, Manu suggested just to wait until such is gone, anyway.

It depends on nothing currently, but is still the key to get some same
shared "simple" tuners working for analog and digital at once.

This is the best we have so far, not to duplicate tuner code anymore on
hybrid devices.

Any closer point, what eventually makes it to be an annoyance to you?

Cheers,
Hermann




