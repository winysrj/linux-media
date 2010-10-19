Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o9JLsoI5014870
	for <video4linux-list@redhat.com>; Tue, 19 Oct 2010 17:54:50 -0400
Received: from mail.suremessenger.com (mail.suremessenger.com [12.5.48.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9JLsZEv011704
	for <video4linux-list@redhat.com>; Tue, 19 Oct 2010 17:54:35 -0400
Received: from [206.248.194.3] (account freds@adiengineering.com HELO
	[192.0.0.58]) by mail.suremessenger.com (CommuniGate Pro SMTP 4.1.8)
	with ESMTP id 205106066 for video4linux-list@redhat.com;
	Tue, 19 Oct 2010 17:54:34 -0400
Message-ID: <4CBE139C.8000508@adiengineering.com>
Date: Tue, 19 Oct 2010 17:54:36 -0400
From: Fred Seward <fred.seward@adiengineering.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: cx23888 board setup
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

We have a custom x86 board with:

    - A soldered down cx23888

    - Four composite inputs feeding the cx23888. No tuner.
      We're only looking at the four composite inputs.

    - FC13 with a 2.6.33.4 kernel.

The cx23885 driver loads and I get /dev/video0 but when I try to
cat /dev/video0 I get data but it's not an mpeg file.

Can anyone point me to some documentation which tells how to set
up the cx23885_board board structure and what other
initialization might need to be done?


In the cx23885 driver I modified cx23885-cards.c to add an
entry for our hardware.

struct cx23885_board cx23885_boards[] = {

   [CX23885_BOARD_ECU] = {
       .name       = "custom board",
       .porta      = CX23885_ANALOG_VIDEO,
       .portb      = CX23885_MPEG_ENCODER,
       .clk_freq   = 50000000,
       .input          = {{
           .type   = CX23885_VMUX_COMPOSITE1,
           .vmux   = 0,
       }, {
           .type   = CX23885_VMUX_COMPOSITE2,
           .vmux   = 1,
       }, {
           .type   = CX23885_VMUX_COMPOSITE3,
           .vmux   = 2,
       }, {
           .type   = CX23885_VMUX_COMPOSITE4,
           .vmux   = 3,
       } },
   },

cx23885_subids

   }, {
       .subvendor = 0x0000,
       .subdevice = 0x0000,
       .card      = CX23885_BOARD_ECU,
   }, {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
