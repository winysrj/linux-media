Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8T1S0hO023916
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 21:28:00 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m8T1Rl3n031496
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 21:27:47 -0400
From: Andy Walls <awalls@radix.net>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"ivtv-users@ivtvdriver.org" <ivtv-users@ivtvdriver.org>,
	"linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Content-Type: text/plain
Date: Sun, 28 Sep 2008 21:22:37 -0400
Message-Id: <1222651357.2640.21.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "ivtv-devel@ivtvdriver.org" <ivtv-devel@ivtvdriver.org>
Subject: cx18: Fix needs test: more robust solution to get CX23418 based
	cards to work reliably
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

cx18 driver users:

In this repository:

http://linuxtv.org/hg/~awalls/cx18-mmio-fixes/

is a change to the cx18 driver to (hopefully) improve reliability of
CX23418 based cards operation in linux.  If all goes will, this change
will supersede the "mmio_ndelay" hack, which I hope to phase out.

This change adds checks and retries to all PCI MMIO access to the
CX23418 chip and adds a new module parameter 'retry_mmio' which is
enabled by default.

With this change, the module defaults are set so the following
statements are equivalent:

	# modprobe cx18
	# modprobe cx18 retry_mmio=1 mmio_ndelay=0


With checks and retries enabled, limited experiments have shown a card
operates properly in my old Intel 82801AA based motherboard with this
fix in place. I found that the mmio_ndelay parameter has little or no
effect with these checks and retires enabled.

Experiments have also shown that, if you have previously had a problem
with the cx18 driver/CX23418 in your system, then

	# modprobe cx18 retry_mmio=0 mmio_delay=(something)

can put the CX23418 in a state, such that a reset is required to have
the unit respond properly again when trying to reload cx18 driver
another time.  (So my advice is don't turn off retry_mmio.)

If you've had to use the mmio_ndelay parameter in the past to get the
card to work for you, or your card has never worked for you, please let
me know how this patch works for you.

Regards,
Andy


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
