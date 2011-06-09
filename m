Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41221 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1FIBZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 21:25:49 -0400
Received: by vxi39 with SMTP id 39so834269vxi.19
        for <linux-media@vger.kernel.org>; Wed, 08 Jun 2011 18:25:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307579065.2461.8.camel@localhost>
References: <BANLkTikSacfHp6ndaf8FPJi-PDu-PFSTsg@mail.gmail.com>
	<3527e900-1d63-46cc-ba72-af763111a16a@email.android.com>
	<BANLkTi=OgqhmkYLd9_YnyW8JSvZgiQWTfw@mail.gmail.com>
	<1307579065.2461.8.camel@localhost>
Date: Wed, 8 Jun 2011 19:25:48 -0600
Message-ID: <BANLkTikU0dkQwmo_akC5TUg9JP8Oa=Te1w@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Add IR Rx support for HVR-1270 boards
From: Dark Shadow <shadowofdarkness@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 8, 2011 at 6:24 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Wed, 2011-06-08 at 13:18 -0600, Dark Shadow wrote:
>> On Wed, Jun 8, 2011 at 4:19 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>> > Dark Shadow <shadowofdarkness@gmail.com> wrote:
>> >
>> >>I have a capture card that was sold as a Hauppauge HVR-1250 (according
>> >>to the box) that I am trying to use but I am having trouble getting
>> >>all it's features at once. When I leave it auto detected by the module
>> >>I have working TV in MythTV even though it thinks it is a 1270 but IR
>> >>isn't setup.
>> >>
>> >>dmesg outputs
>> >>#modprobe cx23885 enable_885_ir=1
>> >>[    7.592714] cx23885 driver version 0.0.2 loaded
>> >>[    7.592748] cx23885 0000:07:00.0: PCI INT A -> GSI 17 (level, low)
>> >>-> IRQ 17
>> >>[    7.592926] CORE cx23885[0]: subsystem: 0070:2211, board: Hauppauge
>> >>WinTV-HVR1270 [card=18,autodetected]
>> >>[    7.728163] IR JVC protocol handler initialized
>> >>[    7.738971] tveeprom 0-0050: Hauppauge model 22111, rev C2F5,
>> >>serial# 6429897
>> >>[    7.738974] tveeprom 0-0050: MAC address is 00:0d:fe:62:1c:c9
>> >>[    7.738975] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155,
>> >>type 54)
>> >>[    7.738977] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital
>> >>(eeprom 0x88)
>> >>[    7.738979] tveeprom 0-0050: audio processor is CX23888 (idx 40)
>> >>[    7.738980] tveeprom 0-0050: decoder processor is CX23888 (idx 34)
>> >>[    7.738982] tveeprom 0-0050: has no radio, has IR receiver, has no
>> >>IR transmitter
>> >>[    7.738983] cx23885[0]: hauppauge eeprom: model=22111
>> >>[    7.738985] cx23885_dvb_register() allocating 1 frontend(s)
>> >>[    7.738991] cx23885[0]: cx23885 based dvb card
>> >>[    7.961122] IR Sony protocol handler initialized
>> >>[    7.977301] tda18271 1-0060: creating new instance
>> >>[    7.979325] TDA18271HD/C2 detected @ 1-0060
>> >>[    8.209663] DVB: registering new adapter (cx23885[0])
>> >>[    8.209668] DVB: registering adapter 0 frontend 0 (LG Electronics
>> >>LGDT3305 VSB/QAM Frontend)...
>> >>[    8.210095] cx23885_dev_checkrevision() Hardware revision = 0xd0
>> >>[    8.210101] cx23885[0]/0: found at 0000:07:00.0, rev: 4, irq: 17,
>> >>latency: 0, mmio: 0xf7c00000
>> >>[    8.210109] cx23885 0000:07:00.0: setting latency timer to 64
>> >>[    8.210186] cx23885 0000:07:00.0: irq 49 for MSI/MSI-X
>
>> >>#ir-keytable -a /etc/rc_maps.cfg
>> >>Old keytable cleared
>> >>Wrote 136 keycode(s) to driver
>> >>Protocols changed to RC-5
>
>> >>I have heard this should show up as a normal keyboard to the system
>> >>but no button presses cause anything to happen to the system and
>> >>trying lirc with devinput (with devinput lircd.conf) and then opening
>> >>irw doesn't show any button presses either
>
>
>> > Don't force your card to a 1250, if the driver detects it is a 1270
>> with a CX23888 chip.  No need to use the enable_885_ir parameter with
>> a CX23888 chip, either.  It only applies for two board models with
>> actual CX23885 chips.
>> >
>> > Use of IR with the CX23888 chip should be realtively trouble free,
>> *if* the 1270's IR has been enabled in the driver code.  It likely has
>> not been.  I don't have the source code in front of me at the moment
>> to check.
>> >
>> > It shouldn't be hard for anyone to patch a few files in the cx23885
>> driver to add it.  Patches are welcome...
>> >
>
>> Under auto detect without the enable_885_ir there is no difference so
>> I can only hope someone will add support for it.
>
> I wasn't kidding when I said the patch is sholdn't be hard for anyone.
> It is really, really simple cut-and-paste job.  In fact here is an
> *untested* patch.
>
> Regards,
> Andy
>
> cx23885: Add IR Rx support for HVR-1270 boards
>
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
>
>
> diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
> index ea88722..5635588 100644
> --- a/drivers/media/video/cx23885/cx23885-cards.c
> +++ b/drivers/media/video/cx23885/cx23885-cards.c
> @@ -1097,12 +1097,19 @@ int cx23885_ir_init(struct cx23885_dev *dev)
>        case CX23885_BOARD_HAUPPAUGE_HVR1800:
>        case CX23885_BOARD_HAUPPAUGE_HVR1200:
>        case CX23885_BOARD_HAUPPAUGE_HVR1400:
> -       case CX23885_BOARD_HAUPPAUGE_HVR1270:
>        case CX23885_BOARD_HAUPPAUGE_HVR1275:
>        case CX23885_BOARD_HAUPPAUGE_HVR1255:
>        case CX23885_BOARD_HAUPPAUGE_HVR1210:
>                /* FIXME: Implement me */
>                break;
> +       case CX23885_BOARD_HAUPPAUGE_HVR1270:
> +               ret = cx23888_ir_probe(dev);
> +               if (ret)
> +                       break;
> +               dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_888_IR);
> +               v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
> +                                ir_rx_pin_cfg_count, ir_rx_pin_cfg);
> +               break;
>        case CX23885_BOARD_HAUPPAUGE_HVR1850:
>        case CX23885_BOARD_HAUPPAUGE_HVR1290:
>                ret = cx23888_ir_probe(dev);
> @@ -1156,6 +1163,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
>  void cx23885_ir_fini(struct cx23885_dev *dev)
>  {
>        switch (dev->board) {
> +       case CX23885_BOARD_HAUPPAUGE_HVR1270:
>        case CX23885_BOARD_HAUPPAUGE_HVR1850:
>        case CX23885_BOARD_HAUPPAUGE_HVR1290:
>                cx23885_irq_remove(dev, PCI_MSK_IR);
> @@ -1199,6 +1207,7 @@ int netup_jtag_io(void *device, int tms, int tdi, int read_tdo)
>  void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
>  {
>        switch (dev->board) {
> +       case CX23885_BOARD_HAUPPAUGE_HVR1270:
>        case CX23885_BOARD_HAUPPAUGE_HVR1850:
>        case CX23885_BOARD_HAUPPAUGE_HVR1290:
>                if (dev->sd_ir)
> @@ -1357,6 +1366,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>        case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
>        case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
>        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
> +       case CX23885_BOARD_HAUPPAUGE_HVR1270:
>        case CX23885_BOARD_HAUPPAUGE_HVR1850:
>        case CX23885_BOARD_MYGICA_X8506:
>        case CX23885_BOARD_MAGICPRO_PROHDTVE2:
> diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
> index e97cafd..bc28d2c 100644
> --- a/drivers/media/video/cx23885/cx23885-input.c
> +++ b/drivers/media/video/cx23885/cx23885-input.c
> @@ -82,6 +82,7 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
>                return;
>
>        switch (dev->board) {
> +       case CX23885_BOARD_HAUPPAUGE_HVR1270:
>        case CX23885_BOARD_HAUPPAUGE_HVR1850:
>        case CX23885_BOARD_HAUPPAUGE_HVR1290:
>        case CX23885_BOARD_TEVII_S470:
> @@ -133,6 +134,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
>
>        v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
>        switch (dev->board) {
> +       case CX23885_BOARD_HAUPPAUGE_HVR1270:
>        case CX23885_BOARD_HAUPPAUGE_HVR1850:
>        case CX23885_BOARD_HAUPPAUGE_HVR1290:
>        case CX23885_BOARD_HAUPPAUGE_HVR1250:
> @@ -257,6 +259,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
>                return -ENODEV;
>
>        switch (dev->board) {
> +       case CX23885_BOARD_HAUPPAUGE_HVR1270:
>        case CX23885_BOARD_HAUPPAUGE_HVR1850:
>        case CX23885_BOARD_HAUPPAUGE_HVR1290:
>        case CX23885_BOARD_HAUPPAUGE_HVR1250:
>
>
>
>
>

Thank you I just tested those changes and they work (in getting the IR
to work to the same level as forcing the card model and not cause
problems for the video)

I still can't use the remote any more then forcing the card model but
I have a guess on that. According to everything I have read the
ir-kbd-i2c module is needed but it never auto loads on my system so I
am thinking it is just not updated to know about this card and may
only need the same type of changes as the cx23885 module. (I am
guessing since I can't even program a Hello World) Is there any chance
you would be able to see if any easy changes could be done to it.
