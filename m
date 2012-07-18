Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.masin.eu ([80.188.199.19]:49617 "EHLO mail.masin.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab2GROiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 10:38:25 -0400
From: =?utf-8?Q?Radek_Ma=C5=A1=C3=ADn?= <radek@masin.eu>
Date: Wed, 18 Jul 2012 16:38:22 +0200
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Message-ID: <1342622302269259500@masin.eu>
In-Reply-To: <CALF0-+WcRGGWzcE7eQ4h+MOYKy5+gnVPnxTas9uhyi4-b6VaqA@mail.gmail.com>
References: <1342615958949547500@masin.eu>
	<CALF0-+U7HYyuLZJzUH4_OhJ7U4X33fOAmSmYuP-xATkMVjpKcQ@mail.gmail.com>
 <CALF0-+WcRGGWzcE7eQ4h+MOYKy5+gnVPnxTas9uhyi4-b6VaqA@mail.gmail.com>
Subject: Re: CX25821 driver in kernel 3.4.4 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
with your patch driver is working properly. I see devices in /dev directory and in dmesg
is attached output:

[    5.124858] cx25821: driver version 0.0.106 loaded
[    5.124890] cx25821: Athena pci enable !
[    5.124891] cx25821:
[    5.124892] ***********************************
[    5.124893] cx25821: cx25821 set up
[    5.124894] cx25821: ***********************************
[    5.124895]
[    5.124897] cx25821: Athena Hardware device = 0x8210
[    5.125165] cx25821: cx25821[1]: subsystem: 0000:0000, board: CX25821 [card=1,autodetected]
[    5.125201] asus_wmi: ASUS WMI generic driver loaded
[    5.144539] asus_wmi: Initialization: 0x0
[    5.144566] asus_wmi: BIOS WMI version: 0.9
[    5.144616] asus_wmi: SFUN value: 0x0
[    5.144906] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input4
[    5.151580] asus_wmi: Backlight controlled by ACPI video driver
[    5.307573] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr
[    5.345621] cx25821: (1): i2c register! bus->i2c_rc = 0
[    5.424861] cx25821: cx25821_dev_checkrevision(): Hardware revision = 0x00
[    5.424864] cx25821: (1): setup done!
[    5.424872] cx25821: cx25821[1]/0: found at 0000:02:00.0, rev: 0, irq: 16, latency: 0, mmio: 0xf7c00000

Regards 
Radek Masin
radek@masin.eu

Dne St, 07/18/2012 03:24 odp., Ezequiel Garcia <elezegarcia@gmail.com> napsal(a):
> Radek,
> 
> On Wed, Jul 18, 2012 at 10:14 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > Hi Radek,
> >
> 
> I think the attached patch will solve this issue.
> 
> Please test and tell me if it did,
> Ezequiel.
> 
