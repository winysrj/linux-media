Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:57979 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbZBOUxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 15:53:05 -0500
Received: from [195.4.92.13] (helo=3.mx.freenet.de)
	by mout2.freenet.de with esmtpa (ID ruedigerDohmhardt@freenet.de) (port 25) (Exim 4.69 #76)
	id 1LYnz2-0003qs-93
	for linux-media@vger.kernel.org; Sun, 15 Feb 2009 21:53:00 +0100
Received: from 91-64-66-95-dynip.superkabel.de ([91.64.66.95]:62697 helo=[192.168.2.112])
	by 3.mx.freenet.de with esmtpa (ID ruedigerDohmhardt@freenet.de) (port 25) (Exim 4.69 #76)
	id 1LYnyf-0002iE-39
	for linux-media@vger.kernel.org; Sun, 15 Feb 2009 21:53:00 +0100
Message-ID: <49988041.4060801@freenet.de>
Date: Sun, 15 Feb 2009 21:51:13 +0100
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Mantis Update was Re: Twinhan DTV Ter-CI (3030 Mantis)
 ???
References: <4984E294.6020401@gmail.com>	<498B7945.4060200@gmail.com>	<498F0667.50000@gmail.com>	<49947655.5040904@gmail.com> <49968351.50703@gmail.com> <49969186.8030009@gmail.com>
In-Reply-To: <49969186.8030009@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020506040507040002050400"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020506040507040002050400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Yupp Manu,

attached you find my /var/log/messages with verbose=5.

Yes, the GPIO Values are different!

Ciao Ruediger D.


--------------020506040507040002050400
Content-Type: text/plain;
 name="messages_verboseLevel_5"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages_verboseLevel_5"

Feb 15 21:31:14 mt40 syslog-ng[1844]: syslog-ng starting up; version='2.0.9'
Feb 15 21:31:16 mt40 SuSEfirewall2: batch committing...
Feb 15 21:31:17 mt40 SuSEfirewall2: Firewall rules set to CLOSE.
Feb 15 21:31:19 mt40 kernel: klogd 1.4.1, log source = /proc/kmsg started.
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.344:2): operation="profile_load" name="/bin/ping" name2="default" pid=1626
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.376:3): operation="profile_load" name="/sbin/klogd" name2="default" pid=1627
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.436:4): operation="profile_load" name="/sbin/syslog-ng" name2="default" pid=1628
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.508:5): operation="profile_load" name="/sbin/syslogd" name2="default" pid=1629
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.576:6): operation="profile_load" name="/usr/sbin/avahi-daemon" name2="default" pid=1633
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.644:7): operation="profile_load" name="/usr/sbin/identd" name2="default" pid=1638
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.708:8): operation="profile_load" name="/usr/sbin/mdnsd" name2="default" pid=1640
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.800:9): operation="profile_load" name="/usr/sbin/nscd" name2="default" pid=1645
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.900:10): operation="profile_load" name="/usr/sbin/ntpd" name2="default" pid=1654
Feb 15 21:31:19 mt40 kernel: type=1505 audit(1234729872.964:11): operation="profile_load" name="/usr/sbin/traceroute" name2="default" pid=1662
Feb 15 21:31:19 mt40 kernel: powernow-k8: Found 1 AMD Turion(tm) 64 Mobile Technology MT-40 processors (1 cpu cores) (version 2.20.00)
Feb 15 21:31:19 mt40 kernel: powernow-k8:    0 : fid 0xe (2200 MHz), vid 0xa
Feb 15 21:31:19 mt40 kernel: powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xc
Feb 15 21:31:19 mt40 kernel: powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xe
Feb 15 21:31:19 mt40 kernel: powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0x10
Feb 15 21:31:19 mt40 kernel: powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x16
Feb 15 21:31:19 mt40 kernel: Clocksource tsc unstable (delta = -136356549 ns)
Feb 15 21:31:19 mt40 kernel: NET: Registered protocol family 10
Feb 15 21:31:19 mt40 kernel: lo: Disabled Privacy Extensions
Feb 15 21:31:19 mt40 kernel: ip6_tables: (C) 2000-2006 Netfilter Core Team
Feb 15 21:31:19 mt40 kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Feb 15 21:31:19 mt40 kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Feb 15 21:31:19 mt40 kernel: CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
Feb 15 21:31:19 mt40 kernel: nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
Feb 15 21:31:19 mt40 kernel: sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Feb 15 21:31:20 mt40 kdm_config[2139]: Multiple occurrences of key 'UseTheme' in section [X-*-Greeter] of /usr/share/kde4/config/kdm/kdmrc
Feb 15 21:31:21 mt40 ifup:     lo        
Feb 15 21:31:21 mt40 ifup:     lo        
Feb 15 21:31:21 mt40 ifup: IP address: 127.0.0.1/8  
Feb 15 21:31:21 mt40 ifup:  
Feb 15 21:31:21 mt40 ifup:               
Feb 15 21:31:21 mt40 ifup: IP address: 127.0.0.2/8  
Feb 15 21:31:21 mt40 ifup:  
Feb 15 21:31:22 mt40 ifup:     eth0      device: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
Feb 15 21:31:24 mt40 kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
Feb 15 21:31:24 mt40 ifup-dhcp:     eth0      Starting DHCP4 client
Feb 15 21:31:24 mt40 dhcpcd[2474]: eth0: dhcpcd 3.2.3 starting
Feb 15 21:31:24 mt40 dhcpcd[2474]: eth0: hardware address = 00:13:d3:c0:ec:20
Feb 15 21:31:25 mt40 kernel: NET: Registered protocol family 17
Feb 15 21:31:25 mt40 dhcpcd[2474]: eth0: broadcasting for a lease
Feb 15 21:31:25 mt40 dhcpcd[2474]: eth0: offered 192.168.2.112 from 192.168.2.1
Feb 15 21:31:25 mt40 dhcpcd[2474]: eth0: checking 192.168.2.112 is available on attached networks
Feb 15 21:31:25 mt40 ifup-dhcp: . 
Feb 15 21:31:26 mt40 dhcpcd[2474]: eth0: leased 192.168.2.112 for 86400 seconds
Feb 15 21:31:26 mt40 dhcpcd[2474]: eth0: adding IP address 192.168.2.112/24
Feb 15 21:31:26 mt40 dhcpcd[2474]: eth0: adding default route via 192.168.2.1 metric 0
Feb 15 21:31:26 mt40 ifup-dhcp:  
Feb 15 21:31:26 mt40 ifup-dhcp:     eth0      IP address: 192.168.2.112/24
Feb 15 21:31:27 mt40 syslog-ng[1844]: Configuration reload request received, reloading configuration;
Feb 15 21:31:27 mt40 syslog-ng[1844]: New configuration initialized;
Feb 15 21:31:27 mt40 ifdown:     eth0      device: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
Feb 15 21:31:27 mt40 ifup:     eth0      device: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
Feb 15 21:31:28 mt40 SuSEfirewall2: /var/lock/SuSEfirewall2.booting exists which means system boot in progress, exit.
Feb 15 21:31:28 mt40 dhcpcd[2474]: eth0: Failed to lookup hostname via DNS: Name or service not known
Feb 15 21:31:28 mt40 dhcpcd[2474]: eth0: exiting
Feb 15 21:31:30 mt40 auditd[3304]: Started dispatcher: /sbin/audispd pid: 3306
Feb 15 21:31:30 mt40 audispd: priority_boost_parser called with: 4
Feb 15 21:31:30 mt40 audispd: af_unix plugin initialized
Feb 15 21:31:30 mt40 audispd: audispd initialized with q_depth=80 and 1 active plugins
Feb 15 21:31:30 mt40 auditd[3304]: Init complete, auditd 1.7.7 listening for events (startup state disable)
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Found user 'avahi' (UID 103) and group 'avahi' (GID 104).
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Successfully dropped root privileges.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: avahi-daemon 0.6.23 starting up.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Loading service file /etc/avahi/services/sftp-ssh.service.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Loading service file /etc/avahi/services/ssh.service.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Joining mDNS multicast group on interface eth0.IPv4 with address 192.168.2.112.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: New relevant interface eth0.IPv4 for mDNS.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Network interface enumeration completed.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Registering new address record for fe80::213:d3ff:fec0:ec20 on eth0.*.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Registering new address record for 192.168.2.112 on eth0.IPv4.
Feb 15 21:31:31 mt40 avahi-daemon[3326]: Registering HINFO record with values 'X86_64'/'LINUX'.
Feb 15 21:31:32 mt40 avahi-daemon[3326]: Server startup complete. Host name is mt40.local. Local service cookie is 139416848.
Feb 15 21:31:32 mt40 lircd-0.8.4[3422]: lircd(default) ready
Feb 15 21:31:33 mt40 avahi-daemon[3326]: Service "mt40" (/etc/avahi/services/ssh.service) successfully established.
Feb 15 21:31:33 mt40 avahi-daemon[3326]: Service "SFTP File Transfer on mt40" (/etc/avahi/services/sftp-ssh.service) successfully established.
Feb 15 21:31:34 mt40 kernel: eth0: no IPv6 routers present
Feb 15 21:31:34 mt40 kernel: klogd 1.4.1, ---------- state change ----------
Feb 15 21:31:35 mt40 /usr/sbin/cron[3693]: (CRON) STARTUP (V5.0)
Feb 15 21:31:36 mt40 smartd[3716]: smartd 5.39 2008-10-24 22:33 [x86_64-suse-linux-gnu] (openSUSE RPM) Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net
Feb 15 21:31:36 mt40 smartd[3716]: Opened configuration file /etc/smartd.conf
Feb 15 21:31:36 mt40 smartd[3716]: Drive: DEVICESCAN, implied '-a' Directive on line 26 of file /etc/smartd.conf
Feb 15 21:31:36 mt40 smartd[3716]: Configuration file /etc/smartd.conf was parsed, found DEVICESCAN, scanning devices
Feb 15 21:31:36 mt40 smartd[3716]: Device: /dev/sda, type changed from 'scsi' to 'sat'
Feb 15 21:31:36 mt40 smartd[3716]: Device: /dev/sda [SAT], opened
Feb 15 21:31:36 mt40 smartd[3716]: Device: /dev/sda [SAT], found in smartd database.
Feb 15 21:31:36 mt40 smartd[3716]: Device: /dev/sda [SAT], is SMART capable. Adding to "monitor" list.
Feb 15 21:31:36 mt40 smartd[3716]: Device: /dev/sda [SAT], state read from /var/lib/smartmontools/smartd.SAMSUNG_SP2004C-S07GJ1OL206923.ata.state
Feb 15 21:31:36 mt40 smartd[3716]: Monitoring 1 ATA and 0 SCSI devices
Feb 15 21:31:36 mt40 smartd[3716]: Device: /dev/sda [SAT], state written to /var/lib/smartmontools/smartd.SAMSUNG_SP2004C-S07GJ1OL206923.ata.state
Feb 15 21:31:36 mt40 smartd[3718]: smartd has fork()ed into background mode. New PID=3718.
Feb 15 21:31:37 mt40 sshd[3750]: Server listening on 0.0.0.0 port 22.
Feb 15 21:31:37 mt40 sshd[3750]: Server listening on :: port 22.
Feb 15 21:31:40 mt40 kernel: vboxdrv: Trying to deactivate the NMI watchdog permanently...
Feb 15 21:31:40 mt40 kernel: vboxdrv: Successfully done.
Feb 15 21:31:40 mt40 kernel: vboxdrv: Found 1 processor cores.
Feb 15 21:31:40 mt40 kernel: VBoxDrv: dbg - g_abExecMemory=ffffffffa0b61960
Feb 15 21:31:40 mt40 kernel: vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
Feb 15 21:31:40 mt40 kernel: vboxdrv: Successfully loaded version 2.1.0 (interface 0x000a0008).
Feb 15 21:31:41 mt40 SuSEfirewall2: Setting up rules from /etc/sysconfig/SuSEfirewall2 ...
Feb 15 21:31:42 mt40 SuSEfirewall2: batch committing...
Feb 15 21:31:42 mt40 SuSEfirewall2: Firewall rules successfully set
Feb 15 21:32:09 mt40 python: hp-systray(init)[4050]: warning: No hp: or hpfax: devices found in any installed CUPS queue. Exiting.
Feb 15 21:32:18 mt40 su: (to root) rudi on /dev/pts/1
Feb 15 21:32:32 mt40 su: (to root) rudi on /dev/pts/2
Feb 15 21:32:41 mt40 kernel: found a VP-2033 PCI DVB-C device on (02:01.0),
Feb 15 21:32:41 mt40 kernel: vendor=1002 device=4371
Feb 15 21:32:41 mt40 kernel: Mantis 0000:02:01.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Feb 15 21:32:41 mt40 kernel:     Mantis Rev 1 [1822:0008], irq: 21, latency: 64
Feb 15 21:32:41 mt40 kernel:     memory: 0x0, mmio: 0xffffc20000366000
Feb 15 21:32:41 mt40 kernel: mantis_stream_control (0): Set stream to HIF
Feb 15 21:32:41 mt40 kernel: mantis_i2c_init (0): Initializing I2C ..
Feb 15 21:32:41 mt40 kernel: mantis_i2c_init (0): Disabling I2C interrupt
Feb 15 21:32:41 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb 15 21:32:41 mt40 kernel:         mantis_i2c_write: Address=[0x50] <W>[ 08 ]
Feb 15 21:32:41 mt40 kernel:         mantis_i2c_read:  Address=[0x50] <R>[ 00 08 ca 19 e9 b6 ]
Feb 15 21:32:41 mt40 kernel:     MAC Address=[00:08:ca:19:e9:b6]
Feb 15 21:32:41 mt40 kernel: mantis_dma_init (0): Mantis DMA init
Feb 15 21:32:41 mt40 kernel: mantis_alloc_buffers (0): DMA=0x619c0000 cpu=0xffff8800619c0000 size=65536
Feb 15 21:32:41 mt40 kernel: mantis_alloc_buffers (0): RISC=0x61984000 cpu=0xffff880061984000 size=1000
Feb 15 21:32:41 mt40 kernel: mantis_calc_lines (0): Mantis RISC block bytes=[4096], line bytes=[2048], line count=[32]
Feb 15 21:32:41 mt40 kernel: mantis_dvb_init (0): dvb_register_adapter
Feb 15 21:32:41 mt40 kernel: DVB: registering new adapter (Mantis DVB adapter)
Feb 15 21:32:41 mt40 kernel: mantis_dvb_init (0): dvb_dmx_init
Feb 15 21:32:41 mt40 kernel: mantis_dvb_init (0): dvb_dmxdev_init
Feb 15 21:32:41 mt40 kernel: mantis_frontend_power (0): Power ON
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): Set Bit <12> to <1>
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): GPIO Value <1000>
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): Set Bit <12> to <1>
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): GPIO Value <1000>
Feb 15 21:32:41 mt40 kernel: mantis_frontend_soft_reset (0): Frontend RESET
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): Set Bit <13> to <0>
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): GPIO Value <1000>
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): Set Bit <13> to <0>
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): GPIO Value <1000>
Feb 15 21:32:41 mt40 kernel: gpio_set_bits (0): Set Bit <13> to <1>
Feb 15 21:32:42 mt40 kernel: gpio_set_bits (0): GPIO Value <3000>
Feb 15 21:32:42 mt40 kernel: gpio_set_bits (0): Set Bit <13> to <1>
Feb 15 21:32:42 mt40 kernel: gpio_set_bits (0): GPIO Value <3000>
Feb 15 21:32:42 mt40 kernel: vp2033_frontend_init (0): Probing for CU1216 (DVB-C)
Feb 15 21:32:42 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb 15 21:32:42 mt40 kernel:         mantis_i2c_write: Address=[0x50] <W>[ ff ]
Feb 15 21:32:42 mt40 kernel:         mantis_i2c_read:  Address=[0x50] <R>[ 22 ]
Feb 15 21:32:42 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb 15 21:32:42 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 1a ]
Feb 15 21:32:42 mt40 kernel:         mantis_i2c_read:  Address=[0x0c] <R>[ 7c ]
Feb 15 21:32:42 mt40 kernel: TDA10021: i2c-addr = 0x0c, id = 0x7c
Feb 15 21:32:42 mt40 kernel: vp2033_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10021) @ 0x0c
Feb 15 21:32:42 mt40 kernel: vp2033_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
Feb 15 21:32:42 mt40 kernel: vp2033_frontend_init (0): Done!
Feb 15 21:32:42 mt40 kernel: DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
Feb 15 21:32:57 mt40 vdr: [4271] cTimeMs: using monotonic clock (resolution is 1 ns)
Feb 15 21:32:57 mt40 vdr: [4271] VDR version 1.7.0 started
Feb 15 21:32:57 mt40 vdr: [4271] codeset is 'UTF-8' - known
Feb 15 21:32:57 mt40 vdr: [4271] ERROR: ./locale: Datei oder Verzeichnis nicht gefunden
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'deu,ger'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'slv,slo'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'ita'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'dut,nla,nld'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'por'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'fra,fre'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'nor'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'fin,smi'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'pol'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'esl,spa'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'ell,gre'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'sve,swe'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'rom,rum'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'hun'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'cat,cln'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'rus'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'hrv'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'est'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'dan'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'cze,ces'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'tur'
Feb 15 21:32:57 mt40 vdr: [4271] no locale for language code 'ukr'
Feb 15 21:32:57 mt40 vdr: [4271] loading plugin: /GIGA1/SOURCES/DVB/VDR/vdr/PLUGINS/lib/libvdr-xineliboutput.so.1.7.0
Feb 15 21:32:57 mt40 vdr: [4271] loading /video/setup.conf
Feb 15 21:32:57 mt40 vdr: [4271] ERROR: unknown config parameter: MenuButtonCloses = 0
Feb 15 21:32:57 mt40 vdr: [4271] unknown locale: '0'
Feb 15 21:32:57 mt40 vdr: [4271] ERROR: unknown config parameter: SortTimers = 1
Feb 15 21:32:57 mt40 vdr: [4271] loading /video/sources.conf
Feb 15 21:32:57 mt40 vdr: [4271] loading /video/diseqc.conf
Feb 15 21:32:58 mt40 vdr: [4271] loading /video/channels.conf
Feb 15 21:32:58 mt40 vdr: [4271] loading /video/timers.conf
Feb 15 21:32:58 mt40 vdr: [4271] loading /video/commands.conf
Feb 15 21:32:58 mt40 vdr: [4271] loading /video/svdrphosts.conf
Feb 15 21:32:58 mt40 vdr: [4271] loading /video/remote.conf
Feb 15 21:32:58 mt40 vdr: [4271] loading /video/keymacros.conf
Feb 15 21:32:58 mt40 vdr: [4272] video directory scanner thread started (pid=4271, tid=4272)
Feb 15 21:32:58 mt40 vdr: [4273] video directory scanner thread started (pid=4271, tid=4273)
Feb 15 21:32:58 mt40 vdr: [4271] reading EPG data from /video/epg.data
Feb 15 21:32:58 mt40 vdr: [4271] probing /dev/dvb/adapter0/frontend0
Feb 15 21:32:58 mt40 vdr: [4273] video directory scanner thread ended (pid=4271, tid=4273)
Feb 15 21:32:59 mt40 vdr: [4272] video directory scanner thread ended (pid=4271, tid=4272)
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 00 73 ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 01 6a ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 02 23 ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 03 0a ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 04 02 ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 05 37 ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 06 77 ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 07 1a ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 08 37 ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 09 6a ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 0a 17 ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 0b 8a ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 0c 1e ]
Feb 15 21:32:59 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:32:59 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 0d 86 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 0e 43 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 0f 40 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 10 b8 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 11 3f ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 12 a1 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 13 00 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 14 cd ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 15 01 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 16 00 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 17 ff ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 18 11 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 19 00 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 1a 7c ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 1b 31 ]
Feb 15 21:33:00 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:00 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 1c 30 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 1d 20 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 1e 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 1f 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 20 02 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 21 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 22 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 23 7d ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 24 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 25 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 26 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 27 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 28 07 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 29 00 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 2a 33 ]
Feb 15 21:33:01 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:01 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 2b 11 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 2c 0d ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 2d 95 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 2e 08 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 2f 58 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 30 00 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 31 00 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 32 80 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 33 00 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 34 80 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 35 ff ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 36 00 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 37 00 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 38 04 ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 39 2d ]
Feb 15 21:33:02 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:02 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 3a 2f ]
Feb 15 21:33:03 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:03 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 3b ff ]
Feb 15 21:33:03 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:03 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 3c 00 ]
Feb 15 21:33:03 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:03 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 3d 00 ]
Feb 15 21:33:03 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:03 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 3e 00 ]
Feb 15 21:33:03 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:03 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 3f 00 ]
Feb 15 21:33:01 mt40 vdr: [4271] device 1 provides: DVBS
Feb 15 21:33:03 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:03 mt40 vdr: [4276] tuner on device 1 thread started (pid=4271, tid=4276)
Feb 15 21:33:03 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 34 22 ]
Feb 15 21:33:03 mt40 kernel: mantis_i2c_xfer (0): Messages:1
Feb 15 21:33:03 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 2a 23 ]
Feb 15 21:33:03 mt40 vdr: [4277] section handler thread started (pid=4271, tid=4277)
Feb 15 21:33:03 mt40 vdr: [4271] found 1 video device
Feb 15 21:33:03 mt40 vdr: [4271] initializing plugin: xineliboutput (1.0.0): X11/xine-lib output plugin
Feb 15 21:33:03 mt40 kernel: mantis_i2c_xfer (0): Messages:2
Feb 15 21:33:04 mt40 kernel:         mantis_i2c_write: Address=[0x0c] <W>[ 11 ]
Feb 15 21:33:04 mt40 kernel:         mantis_i2c_read:  Address=[0x0c] <R>[ 00 ]
Feb 15 21:33:03 mt40 vdr: [4271] [xine..put] cTimePts: clock_gettime(CLOCK_MONOTONIC): clock resolution 0 us
Feb 15 21:33:04 mt40 vdr: [4271] [xine..put] cTimePts: using monotonic clock
Feb 15 21:33:04 mt40 vdr: [4271] [xine..put] cTimePts: clock_gettime(CLOCK_MONOTONIC): clock resolution 0 us
Feb 15 21:33:04 mt40 vdr: [4271] [xine..put] cTimePts: using monotonic clock
Feb 15 21:33:04 mt40 vdr: [4271] [xine..put] RTP SSRC: 0x2615d2e5
Feb 15 21:33:04 mt40 vdr: [4278] ERROR (thread.c,236): Keine Berechtigung
Feb 15 21:33:04 mt40 vdr: [4271] setting primary device to 1
Feb 15 21:33:04 mt40 vdr: [4271] device 1 has no MPEG decoder
Feb 15 21:33:04 mt40 vdr: [4271] trying device number 2 instead
Feb 15 21:33:04 mt40 vdr: [4271] setting primary device to 2
Feb 15 21:33:04 mt40 vdr: [4271] assuming manual start of VDR
Feb 15 21:33:04 mt40 vdr: [4271] SVDRP listening on port 2001
Feb 15 21:33:04 mt40 vdr: [4271] setting current skin to "classic"
Feb 15 21:33:04 mt40 vdr: [4271] loading /video/themes/classic-default.theme
Feb 15 21:33:04 mt40 vdr: [4271] starting plugin: xineliboutput
Feb 15 21:33:04 mt40 vdr: [4279] Remote decoder/display server (cXinelibServer) thread started (pid=4271, tid=4279)
Feb 15 21:33:04 mt40 vdr: [4279] ERROR (thread.c,236): Keine Berechtigung
Feb 15 21:33:04 mt40 vdr: [4279] [xine..put] cXinelibServer: Can't set priority to SCHED_RR 2 [1,99]
Feb 15 21:33:04 mt40 vdr: [4279] [xine..put] Listening on port 37890
Feb 15 21:33:04 mt40 vdr: [4279] [xine..put] Listening for UDP broadcasts on port 37890
Feb 15 21:33:04 mt40 vdr: [4271] [xine..put] cXinelibDevice::StartDevice(): Device started
Feb 15 21:33:04 mt40 lircd-0.8.4[3422]: accepted new client on /var/run/lirc/lircd
Feb 15 21:33:04 mt40 vdr: [4280] LIRC remote control thread started (pid=4271, tid=4280)
Feb 15 21:33:04 mt40 vdr: [4271] remote control LIRC - keys known
Feb 15 21:33:04 mt40 vdr: [4271] switching to channel 1
Feb 15 21:33:04 mt40 kernel: mantis_dvb_start_feed (0): Mantis DVB Start feed
Feb 15 21:33:04 mt40 kernel: mantis_dvb_start_feed (0): mantis start feed, feeds=1
Feb 15 21:33:04 mt40 kernel: mantis_dvb_start_feed (0): mantis start feed & dma
Feb 15 21:33:04 mt40 vdr: [4281] transfer thread started (pid=4271, tid=4281)
Feb 15 21:33:05 mt40 kernel: mantis start feed & dma
Feb 15 21:33:04 mt40 vdr: [4282] receiver on device 1 thread started (pid=4271, tid=4282)
Feb 15 21:33:05 mt40 kernel: mantis_dma_start (0): Mantis Start DMA engine
Feb 15 21:33:05 mt40 vdr: [4283] TS buffer on device 1 thread started (pid=4271, tid=4283)
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): Mantis create RISC program
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): risc len lines 32, bytes per line 2048
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[0]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[1]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[2]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[3]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[4]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[5]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[6]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[7]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[8]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[9]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[10]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[11]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[12]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[13]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[14]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[15]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[16]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[17]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[18]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[19]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[20]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[21]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[22]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[23]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[24]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[25]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[26]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[27]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[28]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[29]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[30]
Feb 15 21:33:05 mt40 kernel: mantis_risc_program (0): RISC PROG line=[31]
Feb 15 21:33:05 mt40 kernel: 
Feb 15 21:33:06 mt40 kernel: -- Stat=<fc000003> Mask=<02> --<DMA><RISCI><RACK><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[15]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[15]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[15]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[15]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[15]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[15]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[15]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[15]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[15]
Feb 15 21:33:05 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[15]
Feb 15 21:33:06 mt40 kernel: 
Feb 15 21:33:06 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[0]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[0]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[0]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[0]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[0]
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:06 mt40 kernel: 
Feb 15 21:33:06 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:06 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:06 mt40 kernel: wn> Stat=<20000000> Mask=<02>
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:06 mt40 kernel: 
Feb 15 21:33:06 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:06 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:06 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:06 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:07 mt40 kernel: 
Feb 15 21:33:07 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:07 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:08 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:07 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:08 mt40 kernel: 
Feb 15 21:33:08 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:08 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:08 mt40 kernel: 
Feb 15 21:33:08 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:08 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:08 mt40 kernel: 
Feb 15 21:33:08 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:08 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:08 mt40 kernel: 
Feb 15 21:33:08 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:08 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:08 mt40 kernel: 
Feb 15 21:33:08 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:08 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:08 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:08 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:08 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:08 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:08 mt40 kernel: 
Feb 15 21:33:08 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:08 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:08 mt40 kernel: 
Feb 15 21:33:08 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:08 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:08 mt40 kernel: 
Feb 15 21:33:08 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:08 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:09 mt40 kernel: 
Feb 15 21:33:09 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:09 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:10 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:10 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:10 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:10 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:10 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:10 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:08 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:10 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:10 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:10 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:10 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:10 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:10 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:11 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:11 mt40 kernel: 
Feb 15 21:33:11 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:12 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:12 mt40 kernel: 
Feb 15 21:33:12 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:12 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:12 mt40 kernel: 
Feb 15 21:33:12 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:12 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:12 mt40 kernel: 
Feb 15 21:33:12 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:12 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:12 mt40 kernel: 
Feb 15 21:33:12 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:12 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:12 mt40 kernel: 
Feb 15 21:33:12 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:12 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:12 mt40 kernel: 
Feb 15 21:33:12 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:12 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:12 mt40 kernel: 
Feb 15 21:33:10 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:13 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:13 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:13 mt40 kernel: 
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:13 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 kernel: 
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:13 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:13 mt40 kernel: 
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:13 mt40 kernel: 
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:13 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:14 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:14 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:14 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:15 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:15 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:15 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:15 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:14 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:15 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:15 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:15 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:15 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:15 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:15 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:15 mt40 kernel: 
Feb 15 21:33:15 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:15 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:15 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:16 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:16 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:16 mt40 kernel: 
Feb 15 21:33:16 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:16 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:17 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:17 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:17 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:17 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:18 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:18 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:18 mt40 kernel: 
Feb 15 21:33:19 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:19 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:19 mt40 kernel: 
Feb 15 21:33:19 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:19 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:18 mt40 vdr: [4281] TS continuity error (15)
Feb 15 21:33:19 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:19 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:19 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:19 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:19 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:19 mt40 kernel: 
Feb 15 21:33:19 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:19 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:19 mt40 kernel: 
Feb 15 21:33:19 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:19 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:19 mt40 kernel: 
Feb 15 21:33:19 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:19 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:19 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:19 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:19 mt40 kernel: 
Feb 15 21:33:19 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:19 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:19 mt40 kernel: 
Feb 15 21:33:19 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:19 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:19 mt40 kernel: 
Feb 15 21:33:19 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:20 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:20 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:20 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:20 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:20 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:19 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:20 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:20 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:20 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:20 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:20 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:20 mt40 kernel: 
Feb 15 21:33:21 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:21 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:21 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:21 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:21 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:21 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:21 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:21 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:20 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:21 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:21 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:21 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:21 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:21 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:21 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:22 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:22 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:22 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:22 mt40 kernel: 
Feb 15 21:33:22 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:22 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:22 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:22 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:23 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:23 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:23 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:23 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:23 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:23 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:23 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:22 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:23 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:23 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:23 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:23 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:23 mt40 kernel: 
Feb 15 21:33:24 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:24 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:24 mt40 kernel: 
Feb 15 21:33:24 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:24 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:24 mt40 kernel: 
Feb 15 21:33:24 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:24 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:24 mt40 kernel: 
Feb 15 21:33:24 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:24 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:24 mt40 kernel: 
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:24 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:24 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:25 mt40 kernel: 
Feb 15 21:33:25 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:25 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:26 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:26 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:26 mt40 kernel: 
Feb 15 21:33:26 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:26 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:27 mt40 kernel: 
Feb 15 21:33:27 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:27 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:27 mt40 kernel: 
Feb 15 21:33:27 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:26 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:27 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:27 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:27 mt40 kernel: 
Feb 15 21:33:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:27 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:27 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:27 mt40 kernel: 
Feb 15 21:33:27 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:27 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:27 mt40 kernel: 
Feb 15 21:33:27 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:27 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:27 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:27 mt40 kernel: 
Feb 15 21:33:27 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:27 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:27 mt40 kernel: 
Feb 15 21:33:27 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:27 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:27 mt40 kernel: 
Feb 15 21:33:27 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:28 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:28 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:27 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:28 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:28 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:28 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:28 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:28 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:28 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:28 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:28 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:28 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:28 mt40 kernel: 
Feb 15 21:33:28 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:28 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:29 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:29 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:29 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:29 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:29 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:29 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:29 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:29 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:29 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:29 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:29 mt40 kernel: 
Feb 15 21:33:30 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:30 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:30 mt40 kernel: 
Feb 15 21:33:30 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:30 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:30 mt40 kernel: 
Feb 15 21:33:30 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:30 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:30 mt40 kernel: 
Feb 15 21:33:30 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:30 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:30 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:30 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:30 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:30 mt40 kernel: 
Feb 15 21:33:30 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:30 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:30 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:30 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:30 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:30 mt40 kernel: 
Feb 15 21:33:30 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:30 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:30 mt40 kernel: 
Feb 15 21:33:30 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:30 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:30 mt40 kernel: 
Feb 15 21:33:30 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:31 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:31 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:31 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:30 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:31 mt40 kernel: 
Feb 15 21:33:31 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:31 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:31 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:32 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:32 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:32 mt40 kernel: 
Feb 15 21:33:32 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:33 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:33 mt40 kernel: 
Feb 15 21:33:33 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:33 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:33 mt40 kernel: 
Feb 15 21:33:33 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:33 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:33 mt40 kernel: 
Feb 15 21:33:33 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:33 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:32 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:33 mt40 kernel: 
Feb 15 21:33:33 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:33 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:33 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:33 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:33 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:33 mt40 kernel: 
Feb 15 21:33:33 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:33 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:33 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:33 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:33 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:33 mt40 kernel: 
Feb 15 21:33:33 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:33 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:33 mt40 kernel: 
Feb 15 21:33:33 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:33 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:33 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:33 mt40 kernel: 
Feb 15 21:33:34 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:34 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 kernel: 
Feb 15 21:33:34 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:34 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:34 mt40 kernel: 
Feb 15 21:33:34 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:34 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:34 mt40 kernel: 
Feb 15 21:33:34 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:34 mt40 kernel: 
Feb 15 21:33:34 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:34 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:34 mt40 kernel: 
Feb 15 21:33:35 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:35 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:35 mt40 kernel: 
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:35 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:35 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:35 mt40 kernel: 
Feb 15 21:33:35 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:35 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:35 mt40 kernel: 
Feb 15 21:33:35 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:35 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:35 mt40 kernel: 
Feb 15 21:33:35 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:35 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:35 mt40 kernel: 
Feb 15 21:33:35 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:35 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:35 mt40 kernel: 
Feb 15 21:33:35 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:35 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:35 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:36 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:35 mt40 kernel: 
Feb 15 21:33:36 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:36 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:36 mt40 kernel: 
Feb 15 21:33:36 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:36 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:36 mt40 kernel: 
Feb 15 21:33:36 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:36 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:36 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:36 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:36 mt40 kernel: 
Feb 15 21:33:36 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:36 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:36 mt40 kernel: 
Feb 15 21:33:36 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:36 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:36 mt40 kernel: 
Feb 15 21:33:36 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:36 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:36 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:36 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:36 mt40 kernel: 
Feb 15 21:33:36 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:36 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:36 mt40 kernel: 
Feb 15 21:33:36 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:36 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:36 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:37 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:36 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:37 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:37 mt40 kernel: 
Feb 15 21:33:37 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:37 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:38 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:38 mt40 kernel: 
Feb 15 21:33:38 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:38 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:38 mt40 kernel: 
Feb 15 21:33:38 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:38 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:38 mt40 kernel: 
Feb 15 21:33:38 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:38 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:38 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:38 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:38 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:38 mt40 kernel: 
Feb 15 21:33:38 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:38 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:38 mt40 kernel: 
Feb 15 21:33:38 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:38 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:38 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:38 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:38 mt40 kernel: 
Feb 15 21:33:38 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:38 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:38 mt40 kernel: 
Feb 15 21:33:38 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:38 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:38 mt40 kernel: 
Feb 15 21:33:38 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:38 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:39 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:39 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:39 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:39 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:39 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:39 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:39 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:39 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:39 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:39 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:39 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:39 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:39 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:39 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:39 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:40 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:40 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:40 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:40 mt40 kernel: 
Feb 15 21:33:40 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:41 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:41 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:41 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:40 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:41 mt40 kernel: 
Feb 15 21:33:41 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:41 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:41 mt40 kernel: 
Feb 15 21:33:41 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:41 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:41 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:41 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:41 mt40 kernel: 
Feb 15 21:33:41 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:41 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:41 mt40 kernel: 
Feb 15 21:33:41 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:41 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:41 mt40 kernel: 
Feb 15 21:33:41 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:41 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:41 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:41 mt40 kernel: 
Feb 15 21:33:41 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:41 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:41 mt40 kernel: 
Feb 15 21:33:41 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:41 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:41 mt40 kernel: 
Feb 15 21:33:41 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:41 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:42 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:42 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:42 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:42 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:42 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:42 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:41 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:42 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:42 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:42 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:42 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:42 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:42 mt40 kernel: 
Feb 15 21:33:43 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:43 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:43 mt40 kernel: 
Feb 15 21:33:43 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:43 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:43 mt40 kernel: 
Feb 15 21:33:43 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:43 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:43 mt40 kernel: 
Feb 15 21:33:42 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:43 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:43 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:43 mt40 kernel: 
Feb 15 21:33:43 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:43 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:43 mt40 kernel: 
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:43 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:43 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:43 mt40 kernel: 
Feb 15 21:33:43 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:43 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:43 mt40 kernel: 
Feb 15 21:33:44 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:44 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:44 mt40 kernel: 
Feb 15 21:33:44 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:44 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:44 mt40 kernel: 
Feb 15 21:33:44 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:44 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:44 mt40 kernel: 
Feb 15 21:33:43 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:44 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:44 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:44 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:44 mt40 kernel: 
Feb 15 21:33:44 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:44 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:44 mt40 kernel: 
Feb 15 21:33:44 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:44 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:44 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:45 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:44 mt40 kernel: 
Feb 15 21:33:45 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:45 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:45 mt40 kernel: 
Feb 15 21:33:45 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:45 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:45 mt40 kernel: 
Feb 15 21:33:45 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:45 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:45 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:45 mt40 kernel: 
Feb 15 21:33:45 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:45 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:45 mt40 kernel: 
Feb 15 21:33:45 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:45 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:45 mt40 kernel: 
Feb 15 21:33:45 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:45 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:45 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:46 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:46 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:46 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:46 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:47 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:47 mt40 kernel: 
Feb 15 21:33:47 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:48 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:48 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:48 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:49 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:48 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:49 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:49 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:49 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:49 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:49 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:49 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:50 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:50 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:50 mt40 kernel: 
Feb 15 21:33:50 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:51 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:51 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:51 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:50 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:51 mt40 kernel: 
Feb 15 21:33:51 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:51 mt40 kernel: 
Feb 15 21:33:51 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:51 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:51 mt40 kernel: 
Feb 15 21:33:51 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:51 mt40 kernel: 
Feb 15 21:33:51 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:51 mt40 kernel: 
Feb 15 21:33:51 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:51 mt40 kernel: 
Feb 15 21:33:51 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:51 mt40 kernel: 
Feb 15 21:33:51 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:51 mt40 kernel: 
Feb 15 21:33:51 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:51 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:51 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:52 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:52 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:52 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:52 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:52 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:52 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:52 mt40 kernel: 
Feb 15 21:33:52 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:53 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:52 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:53 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:53 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:53 mt40 kernel: 
Feb 15 21:33:53 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:53 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:54 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:54 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:54 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:54 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:54 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:54 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:54 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:54 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:54 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:54 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:54 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:54 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:54 mt40 kernel: 
Feb 15 21:33:54 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:55 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:55 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:55 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:56 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:55 mt40 kernel: 
Feb 15 21:33:56 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:56 mt40 kernel: 
Feb 15 21:33:56 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:56 mt40 kernel: 
Feb 15 21:33:56 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:56 mt40 kernel: 
Feb 15 21:33:56 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:56 mt40 kernel: 
Feb 15 21:33:56 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:56 mt40 kernel: 
Feb 15 21:33:56 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:56 mt40 kernel: 
Feb 15 21:33:56 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:56 mt40 kernel: 
Feb 15 21:33:56 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:56 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:56 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:56 mt40 kernel: 
Feb 15 21:33:56 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:56 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:56 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:56 mt40 vdr: [4281] TS continuity error (15)
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:57 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:57 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:57 mt40 kernel: 
Feb 15 21:33:57 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:57 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:33:58 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:33:58 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:58 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:33:58 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:33:58 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:59 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:59 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:59 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:33:58 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:33:59 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:59 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:59 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:33:59 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:33:59 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:33:59 mt40 kernel: 
Feb 15 21:34:00 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:00 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:00 mt40 kernel: 
Feb 15 21:34:00 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:00 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:00 mt40 kernel: 
Feb 15 21:34:00 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:00 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:00 mt40 kernel: 
Feb 15 21:34:00 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:00 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:00 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:00 mt40 kernel: 
Feb 15 21:34:00 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:00 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:00 mt40 kernel: 
Feb 15 21:34:00 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:00 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:00 mt40 kernel: 
Feb 15 21:34:00 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:00 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:00 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:00 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:00 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:00 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:00 mt40 kernel: 
Feb 15 21:34:00 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:00 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:00 mt40 kernel: 
Feb 15 21:34:01 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:01 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:01 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:00 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:01 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:01 mt40 kernel: 
Feb 15 21:34:01 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:01 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:02 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:02 mt40 kernel: 
Feb 15 21:34:02 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:02 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:02 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:03 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:03 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:03 mt40 kernel: 
Feb 15 21:34:03 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:03 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:04 mt40 kernel: 
Feb 15 21:34:04 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:04 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:04 mt40 kernel: 
Feb 15 21:34:04 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:04 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:04 mt40 kernel: 
Feb 15 21:34:04 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:04 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:03 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:04 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:04 mt40 kernel: 
Feb 15 21:34:04 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:04 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:04 mt40 kernel: 
Feb 15 21:34:04 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:04 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:04 mt40 kernel: 
Feb 15 21:34:04 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:04 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:04 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:04 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:04 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:04 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:04 mt40 kernel: 
Feb 15 21:34:04 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:04 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:04 mt40 kernel: 
Feb 15 21:34:04 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:04 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:04 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:05 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:05 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:05 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:05 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:05 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:05 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:05 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:05 mt40 kernel: 
Feb 15 21:34:06 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:06 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:06 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:06 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:06 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:06 mt40 kernel: 
Feb 15 21:34:06 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:06 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:06 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:06 mt40 kernel: 
Feb 15 21:34:06 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:06 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:06 mt40 kernel: 
Feb 15 21:34:06 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:06 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:06 mt40 kernel: 
Feb 15 21:34:06 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:06 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:06 mt40 kernel: 
Feb 15 21:34:06 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:06 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:06 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:06 mt40 kernel: 
Feb 15 21:34:06 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:06 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:06 mt40 kernel: 
Feb 15 21:34:06 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:06 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:06 mt40 kernel: 
Feb 15 21:34:06 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:07 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:07 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:07 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:07 mt40 vdr: [4281] TS continuity error (15)
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:07 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:07 mt40 kernel: 
Feb 15 21:34:07 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:08 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:08 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:08 mt40 kernel: 
Feb 15 21:34:08 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:08 mt40 kernel: 
Feb 15 21:34:08 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:08 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:08 mt40 kernel: 
Feb 15 21:34:08 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:08 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:08 mt40 kernel: 
Feb 15 21:34:08 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:08 mt40 kernel: 
Feb 15 21:34:08 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:08 mt40 kernel: 
Feb 15 21:34:08 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:08 mt40 kernel: 
Feb 15 21:34:08 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:08 mt40 kernel: 
Feb 15 21:34:08 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:08 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:09 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:09 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:09 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:09 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:09 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:09 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:10 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:10 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:10 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:10 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:10 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:10 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:10 mt40 kernel: 
Feb 15 21:34:10 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:10 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:11 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:11 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:11 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:11 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:11 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:11 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:11 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:11 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:11 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:11 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:11 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:11 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:11 mt40 kernel: 
Feb 15 21:34:12 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:12 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:12 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:12 mt40 kernel: 
Feb 15 21:34:12 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:12 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:12 mt40 kernel: 
Feb 15 21:34:12 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:12 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:12 mt40 kernel: 
Feb 15 21:34:12 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:12 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:12 mt40 kernel: 
Feb 15 21:34:12 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:12 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:12 mt40 kernel: 
Feb 15 21:34:12 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:12 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:12 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:12 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:12 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:12 mt40 kernel: 
Feb 15 21:34:12 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:12 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:12 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:12 mt40 kernel: 
Feb 15 21:34:12 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:12 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:12 mt40 kernel: 
Feb 15 21:34:12 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:12 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:13 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:13 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:13 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:13 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:13 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:13 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:13 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:13 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:13 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:13 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:13 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:14 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:13 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:14 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:14 mt40 kernel: 
Feb 15 21:34:14 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:14 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:15 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:15 mt40 kernel: 
Feb 15 21:34:15 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:15 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:15 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:16 mt40 vdr: [4281] TS continuity error (2)
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:16 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:16 mt40 kernel: 
Feb 15 21:34:16 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:16 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:17 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:17 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:17 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:17 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:17 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:17 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:17 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:17 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:17 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:17 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:17 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:17 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:17 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:17 mt40 kernel: 
Feb 15 21:34:18 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:18 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:18 mt40 kernel: 
Feb 15 21:34:18 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:18 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:18 mt40 kernel: 
Feb 15 21:34:18 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:18 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:18 mt40 kernel: 
Feb 15 21:34:18 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:18 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:18 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:18 mt40 kernel: 
Feb 15 21:34:18 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:18 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:18 mt40 kernel: 
Feb 15 21:34:18 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:18 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:18 mt40 kernel: 
Feb 15 21:34:18 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:19 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:19 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:19 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:19 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:19 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:19 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:19 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:19 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:19 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:19 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:19 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:19 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:19 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:19 mt40 kernel: 
Feb 15 21:34:20 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:20 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:20 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:20 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:20 mt40 kernel: 
Feb 15 21:34:20 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:21 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:21 mt40 kernel: 
Feb 15 21:34:21 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:21 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:21 mt40 kernel: 
Feb 15 21:34:21 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:21 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:21 mt40 kernel: 
Feb 15 21:34:21 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:20 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:21 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:21 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:21 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:21 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:21 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:21 mt40 kernel: 
Feb 15 21:34:21 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:21 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:21 mt40 kernel: 
Feb 15 21:34:21 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:21 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:21 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:21 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:21 mt40 kernel: 
Feb 15 21:34:21 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:21 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:21 mt40 kernel: 
Feb 15 21:34:21 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:21 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:21 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:22 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:21 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:22 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:22 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:22 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:22 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:22 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:22 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:22 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:22 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:23 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:23 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:23 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:23 mt40 kernel: 
Feb 15 21:34:24 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:24 mt40 kernel: 
Feb 15 21:34:24 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:24 mt40 kernel: 
Feb 15 21:34:24 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:24 mt40 kernel: 
Feb 15 21:34:24 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:24 mt40 kernel: 
Feb 15 21:34:24 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:24 mt40 kernel: 
Feb 15 21:34:24 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:24 mt40 kernel: 
Feb 15 21:34:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:24 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:24 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:24 mt40 kernel: 
Feb 15 21:34:24 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:24 mt40 kernel: 
Feb 15 21:34:24 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:24 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:25 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:25 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:25 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:25 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:25 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:25 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:25 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:25 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:25 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:25 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:25 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:25 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:24 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:25 mt40 vdr: [4281] TS continuity error (13)
Feb 15 21:34:25 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:25 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:25 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:25 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:25 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:25 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:25 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:25 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:26 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:25 mt40 kernel: 
Feb 15 21:34:26 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:26 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:26 mt40 kernel: 
Feb 15 21:34:26 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:26 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:26 mt40 kernel: 
Feb 15 21:34:26 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:26 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:26 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:26 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:26 mt40 kernel: 
Feb 15 21:34:26 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:26 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:26 mt40 kernel: 
Feb 15 21:34:26 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:26 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:26 mt40 kernel: 
Feb 15 21:34:26 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:26 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:26 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:26 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:26 mt40 kernel: 
Feb 15 21:34:26 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:26 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:26 mt40 kernel: 
Feb 15 21:34:26 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:26 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:26 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:27 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:27 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:27 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:28 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:28 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:27 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:28 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:28 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:28 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:28 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:28 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:28 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:28 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:28 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:28 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:28 mt40 kernel: 
Feb 15 21:34:28 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:28 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:29 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:28 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:29 mt40 kernel: 
Feb 15 21:34:29 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:29 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:29 mt40 kernel: 
Feb 15 21:34:29 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:29 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:29 mt40 kernel: 
Feb 15 21:34:29 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:29 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:29 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:29 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:29 mt40 kernel: 
Feb 15 21:34:29 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:29 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:29 mt40 kernel: 
Feb 15 21:34:29 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:29 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:29 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:29 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:29 mt40 kernel: 
Feb 15 21:34:29 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:29 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:29 mt40 kernel: 
Feb 15 21:34:29 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:29 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:29 mt40 kernel: 
Feb 15 21:34:29 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:29 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:30 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:29 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:30 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:30 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:30 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:30 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:30 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:30 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:30 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:30 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:30 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:30 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:30 mt40 kernel: 
Feb 15 21:34:30 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:30 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:31 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:31 mt40 kernel: 
Feb 15 21:34:31 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:31 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:31 mt40 kernel: 
Feb 15 21:34:31 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:31 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:31 mt40 kernel: 
Feb 15 21:34:31 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:31 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:31 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:31 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:31 mt40 kernel: 
Feb 15 21:34:31 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:31 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:31 mt40 kernel: 
Feb 15 21:34:31 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>
Feb 15 21:34:31 mt40 kernel: mantis_dma_xfer (0): last block=[6] finished block=[7]
Feb 15 21:34:31 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:31 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:31 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:31 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:31 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:31 mt40 kernel: 
Feb 15 21:34:31 mt40 kernel: -- Stat=<8c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<80000000> Mask=<02>
Feb 15 21:34:31 mt40 kernel: mantis_dma_xfer (0): last block=[7] finished block=[8]
Feb 15 21:34:31 mt40 kernel: 
Feb 15 21:34:31 mt40 kernel: -- Stat=<9c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<90000000> Mask=<02>
Feb 15 21:34:31 mt40 kernel: mantis_dma_xfer (0): last block=[8] finished block=[9]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<ac000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<a0000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[9] finished block=[10]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<bc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<b0000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[10] finished block=[11]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<cc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<c0000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[11] finished block=[12]
Feb 15 21:34:31 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:32 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:32 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<dc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<d0000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[12] finished block=[13]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<ec000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<e0000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[13] finished block=[14]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:32 mt40 kernel: -- Stat=<fc000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<f0000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[14] finished block=[15]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<c000002> Mask=<02> --<DMA><RISCI>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[15] finished block=[0]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<1c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<10000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[0] finished block=[1]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 vdr: [4281] TS continuity error (1)
Feb 15 21:34:32 mt40 vdr: [4281] TS continuity error (9)
Feb 15 21:34:32 mt40 kernel: -- Stat=<2c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<20000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[1] finished block=[2]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<3c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<30000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[2] finished block=[3]
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:32 mt40 kernel: -- Stat=<4c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<40000000> Mask=<02>
Feb 15 21:34:32 mt40 kernel: mantis_dma_xfer (0): last block=[3] finished block=[4]
Feb 15 21:34:33 mt40 vdr: [4281] TS continuity error (13)
Feb 15 21:34:32 mt40 kernel: 
Feb 15 21:34:33 mt40 kernel: -- Stat=<5c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<50000000> Mask=<02>
Feb 15 21:34:33 mt40 kernel: mantis_dma_xfer (0): last block=[4] finished block=[5]
Feb 15 21:34:33 mt40 kernel: 
Feb 15 21:34:33 mt40 kernel: -- Stat=<6c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<60000000> Mask=<02>
Feb 15 21:34:33 mt40 kernel: mantis_dma_xfer (0): last block=[5] finished block=[6]
Feb 15 21:34:33 mt40 kernel: 
Feb 15 21:34:33 mt40 kernel: -- Stat=<7c000002> Mask=<02> --<DMA><RISCI><Unknown> Stat=<70000000> Mask=<02>

--------------020506040507040002050400--
