Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8M62n8C008688
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 02:02:49 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8M62Oco002972
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 02:02:24 -0400
Received: by fk-out-0910.google.com with SMTP id e30so1444905fke.3
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 23:02:24 -0700 (PDT)
Date: Mon, 22 Sep 2008 16:02:58 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080922160258.758bfaef@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [REGRESSION] I2C remote controls on saa7134
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi All

I received information from our customers that before 3 Sept I2C remote controls in our new TV cards
not working more. This remote controls works in old repo more than 1 month.
This is dmesg when remote control works and not.

Remote control is working dmesg

tveeprom: no version for "i2c_master_recv" found: kernel tainted.
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 32, mmio: 0xe0002000
saa7133[0]: subsystem: 5ace:6290, board: Beholder BeholdTV H6 [card=142,autodetected]
saa7133[0]: board init: gpio is 800000
I2C attach_inform start
I2C address = 0x2d
I2C attach_inform stop
input: BeholdTV as /class/input/input4
ir-kbd-i2c: BeholdTV detected at i2c-0/0-002d/ir0 [saa7133[0]]
saa7133[0]: i2c eeprom 00: ce 5a 90 62 54 20 00 00 00 00 00 00 00 00 00 01
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ae 01 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
tuner' 0-0043: chip found @ 0x86 (saa7133[0])
tda9887 0-0043: creating new instance
tda9887 0-0043: tda988[5/6/7] found
I2C attach_inform start
I2C address = 0x43
I2C attach_inform stop
tuner' 0-0061: chip found @ 0xc2 (saa7133[0])
I2C attach_inform start
I2C address = 0x61
I2C attach_inform stop
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0

Remote control bad dmesg

tveeprom: no version for "i2c_master_recv" found: kernel tainted.
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 32, mmio: 0xe0002000
saa7133[0]: subsystem: 5ace:6290, board: Beholder BeholdTV H6 [card=142,autodetected]
saa7133[0]: board init: gpio is 800000
saa7133[0]: i2c eeprom 00: ce 5a 90 62 54 20 00 00 00 00 00 00 00 00 00 01
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ae 01 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
tuner' 0-0043: chip found @ 0x86 (saa7133[0])
tda9887 0-0043: creating new instance
tda9887 0-0043: tda988[5/6/7] found
I2C attach_inform start
Device addr = 0x43
I2C attach_inform stop
tuner' 0-0061: chip found @ 0xc2 (saa7133[0])
I2C attach_inform start
Device addr = 0x61
I2C attach_inform stop
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...

As I see, In newest repo didn't send I2C address of remote controller on the board to attach_inform (saa7134-i2c.c) function for generate
input interface.

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
