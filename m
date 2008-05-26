Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1K0jrp-0000Cr-4S
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 23:04:29 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K0jrk-00020p-Sl
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 21:04:24 +0000
Received: from 213-140-22-66.fastres.net ([213.140.22.66])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 26 May 2008 21:04:24 +0000
Received: from kaboom by 213-140-22-66.fastres.net with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 26 May 2008 21:04:24 +0000
To: linux-dvb@linuxtv.org
From: Francesco Schiavarelli <kaboom@tiscalinet.it>
Date: Mon, 26 May 2008 23:04:13 +0200
Message-ID: <g1f8kg$upn$1@ger.gmane.org>
References: <g072jh$h25$1@ger.gmane.org> <g0sact$e6d$1@ger.gmane.org>
Mime-Version: 1.0
In-Reply-To: <g0sact$e6d$1@ger.gmane.org>
Subject: Re: [linux-dvb] dvbnet not working anymore with 2.6.25
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

I've narrowed down the problem to kernel version 2.6.24.
This is the output with
# strace ifconfig dvb0_0 10.0.0.1 promisc up

(WORKING)
...
> open("/usr/share/locale/en_US/LC_MESSAGES/net-tools.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/share/locale/en/LC_MESSAGES/net-tools.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
> ioctl(4, SIOCSIFADDR, 0xbfc8e968)       = 0
> ioctl(4, SIOCGIFFLAGS, {ifr_name="dvb0_0", ifr_flags=IFF_BROADCAST|IFF_NOARP|IFF_MULTICAST}) = 0
> ioctl(4, SIOCSIFFLAGS, 0xbfc8e85c)      = 0
> ioctl(4, SIOCGIFFLAGS, {ifr_name="dvb0_0", ifr_flags=IFF_UP|IFF_BROADCAST|IFF_RUNNING|IFF_NOARP|IFF_MULTICAST}) = 0
> ioctl(4, SIOCSIFFLAGS, 0xbfc8e85c)      = 0
> ioctl(4, SIOCGIFFLAGS, {ifr_name="dvb0_0", ifr_flags=IFF_UP|IFF_BROADCAST|IFF_RUNNING|IFF_NOARP|IFF_PROMISC|IFF_MULTICAST}) = 0
> ioctl(4, SIOCSIFFLAGS, 0xbfc8e85c)      = 0
> exit_group(0)                           = ?
> Process 24330 detached

(NOT WORKING)
...
> open("/usr/share/locale/en_US/LC_MESSAGES/net-tools.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/share/locale/en/LC_MESSAGES/net-tools.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
> ioctl(4, SIOCSIFADDR, 0xbfc59138)       = 0
> ioctl(4, SIOCGIFFLAGS, {ifr_name="dvb0_0", ifr_flags=IFF_BROADCAST|IFF_NOARP|IFF_MULTICAST}) = 0
> ioctl(4, SIOCSIFFLAGS, 0xbfc5902c)      = -1 EADDRNOTAVAIL (Cannot assign requested address)
> dup(2)                                  = 5
> fcntl64(5, F_GETFL)                     = 0x2 (flags O_RDWR)
> fstat64(5, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 1), ...}) = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f3c000
> _llseek(5, 0, 0xbfc58a88, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
> open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
> open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
> write(5, "SIOCSIFFLAGS: Cannot assign requ"..., 46SIOCSIFFLAGS: Cannot assign requested address
> ) = 46
> close(5)                                = 0
> munmap(0xb7f3c000, 4096)                = 0
> ioctl(4, SIOCGIFFLAGS, {ifr_name="dvb0_0", ifr_flags=IFF_BROADCAST|IFF_NOARP|IFF_MULTICAST}) = 0
> ioctl(4, SIOCSIFFLAGS, 0xbfc5902c)      = 0
> ioctl(4, SIOCGIFFLAGS, {ifr_name="dvb0_0", ifr_flags=IFF_BROADCAST|IFF_NOARP|IFF_PROMISC|IFF_MULTICAST}) = 0
> ioctl(4, SIOCSIFFLAGS, 0xbfc5902c)      = -1 EADDRNOTAVAIL (Cannot assign requested address)
> dup(2)                                  = 5
> fcntl64(5, F_GETFL)                     = 0x2 (flags O_RDWR)
> fstat64(5, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 1), ...}) = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f3c000
> _llseek(5, 0, 0xbfc58a88, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
> write(5, "SIOCSIFFLAGS: Cannot assign requ"..., 46SIOCSIFFLAGS: Cannot assign requested address
> ) = 46
> close(5)                                = 0
> munmap(0xb7f3c000, 4096)                = 0
> exit_group(-1)                          = ?
> Process 2778 detached

Not being a kernel hacker I was not able to investigate deeply the problem.
Can it be related to new NAPI in /net/core/dev.c? I don't have a clue.
Also no answers on this ml, so probably I'm alone with this problem.

thanks,
Francesco


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
