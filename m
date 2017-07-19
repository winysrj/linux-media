Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33217 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932121AbdGSSnW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 14:43:22 -0400
Received: by mail-wr0-f195.google.com with SMTP id y43so8836994wrd.0
        for <linux-media@vger.kernel.org>; Wed, 19 Jul 2017 11:43:21 -0700 (PDT)
Subject: Re: Kworld 340U (1b80:a340) kernel 4.8.0 ERROR: i2c_transfer
 returned: -6
To: Kumar Vivek <kv2000inn@gmail.com>, linux-media@vger.kernel.org
References: <CACEBzGRLchBD1wYzT5ecpbRgHZ6LhC9fgJCRZmRWHChwaWx7fQ@mail.gmail.com>
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <b794761a-2cc0-28c9-b032-eaf62e46bad9@googlemail.com>
Date: Wed, 19 Jul 2017 20:44:18 +0200
MIME-Version: 1.0
In-Reply-To: <CACEBzGRLchBD1wYzT5ecpbRgHZ6LhC9fgJCRZmRWHChwaWx7fQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Kumar,

I don't have time for the em28xx driver at the moment (and I also do not
have access to a device with tda18271 tuner).
But...

Am 08.07.2017 um 22:29 schrieb Kumar Vivek:
> New subscriber and first time poster. I have tried to read most of the
> instructions and etiquettes regarding the mailing list but there might
> still be some noob mistakes on my part.
>
> I have had this tuner for a while and I used it successfully in 2009
> (with help from Markus Rechberger - who provided me with the
> appropriate patch). I saw that the patches were included in the kernel
> drivers and this was fully supported. I tried to use it again recently
> and ran into problems and hence this mail. I have spent days trying to
> figure out the problem and have been unsuccessful.
>
> I am using kernel 4.8.0
>
> The variant of this USB ATSC device I have has vid:pid = 1b80:a340 ,
> EM2870 USB bridge, lgdt3304 demodulator/Frontend, TDA18271HDC2 tuner.
>
> I loaded the em28xx module with debugging on - including i2c bus scan
> and i2c transfer.
>
> [  320.139648] em2870 #0 at em28xx_i2c_xfer: read stop addr=1c len=0:
> [  320.139652] (pipe 0x80000280): IN:  c0 02 00 00 1c 00 01 00
> [  320.140008] <<< cf
> [  320.140038] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
>
> [  320.140732] em2870 #0: found i2c device @ 0x1c on bus 0 [lgdt330x]
>
> .....
> [  320.177163] (pipe 0x80000280): IN:  c0 02 00 00 a0 00 01 00
> [  320.177541] <<< 1a
> [  320.177547] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
>
> [  320.177663] em2870 #0: found i2c device @ 0xa0 on bus 0 [eeprom]
> .....
>
> [  320.186289] (pipe 0x80000280): IN:  c0 02 00 00 c4 00 01 00
> [  320.186659] <<< 84
> [  320.186665] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
>
> [  320.186945] em2870 #0: found i2c device @ 0xc4 on bus 0 [tuner (analog)]
>
> This is a bit strange since the tuner TDA18271HDC2 is at 0x60 (7 bit)
> or 0xC0 (8 bit) i2c address and usually - i2cbus scan doesn't reveal
> the tuner's address.
>
> And then this happens :
> [  320.203404] em2870 #0: Identified as KWorld PlusTV 340U or UB435-Q
> (ATSC) (card=76)
> [  320.203406] em28xx: Currently, V4L2 is not supported on this model
> [  320.203407] em2870 #0: dvb set to isoc mode.
> [  320.260270] em2870 #0: Binding DVB extension
> [  320.260274] em2870 #0 em28xx_alloc_urbs :em28xx: called
> em28xx_alloc_isoc in mode 2
> [  320.260276] em2870 #0 em28xx_uninit_usb_xfer :em28xx: called
> em28xx_uninit_usb_xfer in mode 2
> [  320.260279] (pipe 0x80000280): IN:  c0 00 00 00 0c 00 01 00 <<< 00
> [  320.260536] (pipe 0x80000200): OUT: 40 00 00 00 0c 00 01 00 >>> 00
> [  320.260631] (pipe 0x80000200): OUT: 40 00 00 00 12 00 01 00 >>> 27
> [  320.260833] (pipe 0x80000200): OUT: 40 00 00 00 48 00 01 00 >>> 00
> [  320.260987] (pipe 0x80000200): OUT: 40 00 00 00 12 00 01 00 >>> 37
> [  320.275990] (pipe 0x80000280): IN:  c0 00 00 00 08 00 01 00 <<< ff
> [  320.278154] (pipe 0x80000200): OUT: 40 00 00 00 08 00 01 00 >>> 7d
> [  320.337050] em2870 #0 at em28xx_i2c_xfer: write nonstop addr=1c len=2: 00 01
> [  320.337056] (pipe 0x80000200): OUT: 40 03 00 00 1c 00 02 00 >>>
> [  320.337057]  00 01
> [  320.337502] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
>
> [  320.337618] em2870 #0 at em28xx_i2c_xfer: read stop addr=1c len=1:
> [  320.337620] (pipe 0x80000280): IN:  c0 02 00 00 1c 00 01 00
> [  320.337860] <<< 30
> [  320.337867] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
> [  320.337979]  30
> [  320.337984] em2870 #0 at em28xx_i2c_xfer: write stop addr=1c len=3: 08 08 80
> [  320.337987] (pipe 0x80000200): OUT: 40 02 00 00 1c 00 03 00 >>>
> [  320.337988]  08 08 80
> [  320.338518] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
>
> [  320.338618] em2870 #0 at em28xx_i2c_xfer: write nonstop addr=1c len=2: 08 08
> [  320.338622] (pipe 0x80000200): OUT: 40 03 00 00 1c 00 02 00 >>>
> [  320.338623]  08 08
> [  320.339018] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
>
> [  320.339110] em2870 #0 at em28xx_i2c_xfer: read stop addr=1c len=1:
> [  320.339113] (pipe 0x80000280): IN:  c0 02 00 00 1c 00 01 00
> [  320.339391] <<< 80
> [  320.339397] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
> [  320.339490]  80
> [  320.339496] em2870 #0 at em28xx_i2c_xfer: write stop addr=1c len=3: 08 08 00
> [  320.339499] (pipe 0x80000200): OUT: 40 02 00 00 1c 00 03 00 >>>
> [  320.339499]  08 08 00
> [  320.340768] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 00
>
> [  320.341276] tda18271 12-0060: creating new instance
> [  320.341279] em2870 #0 at em28xx_i2c_xfer: write nonstop addr=c0 len=1: 00
> [  320.341283] (pipe 0x80000200): OUT: 40 03 00 00 c0 00 01 00 >>>
> [  320.341284]  00
> [  320.341506] (pipe 0x80000280): IN:  c0 00 00 00 05 00 01 00 <<< 10
> [  320.341637]  ERROR: -6
This means that the i2c client did not ACK the i2c transfer.

Due to the "phenomenons" you are describing, I would suspect the
tda18271 is in reset state / not yet ready.

On your device, it is reset by toggling a gpo line. See em28xx-cards.c:

/*
 * KWorld PlusTV 340U, UB435-Q and UB435-Q V2 (ATSC) GPIOs map:
 * EM_GPIO_0 - currently unknown
 * EM_GPIO_1 - LED disable/enable (1 = off, 0 = on)
 * EM_GPIO_2 - currently unknown
 * EM_GPIO_3 - currently unknown
 * EM_GPIO_4 - TDA18271HD/C1 tuner (1 = active, 0 = in reset)
 * EM_GPIO_5 - LGDT3304 ATSC/QAM demod (1 = active, 0 = in reset)
 * EM_GPIO_6 - currently unknown
 * EM_GPIO_7 - currently unknown
 */
static struct em28xx_reg_seq kworld_a340_digital[] = {
    {EM2820_R08_GPIO_CTRL,    0x6d,    ~EM_GPIO_4,    10},
    {    -1,        -1,    -1,        -1},
};


The reset sequence kworld_a340_digital is performed in fcn
em28xx_set_mode() (em28xx-core.c):

    ...
        return em28xx_gpio_set(dev, dev->board.dvb_gpio);
    ...


Maybe something is wrong with this sequence, e.g. the sleep of 10ms
could be too short.
(the datasheet should tell you how long the tda18271 requires to get
ready after a reset)
But it might be more complicating.

Hope this helps a bit,

Frank


> [  320.341642] tda18271_read_regs: [12-0060|M] ERROR: i2c_transfer returned: -6
> [  320.341647] tda18271_dump_regs: [12-0060|M] === TDA18271 REG DUMP ===
> [  320.341648] tda18271_dump_regs: [12-0060|M] ID_BYTE            = 0x00
> [  320.341650] tda18271_dump_regs: [12-0060|M] THERMO_BYTE        = 0x00
> [  320.341651] tda18271_dump_regs: [12-0060|M] POWER_LEVEL_BYTE   = 0x00
> [  320.341652] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_1   = 0x00
> [  320.341653] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_2   = 0x00
> [  320.341655] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_3   = 0x00
> [  320.341656] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_4   = 0x00
> [  320.341657] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_5   = 0x00
> [  320.341658] tda18271_dump_regs: [12-0060|M] CAL_POST_DIV_BYTE  = 0x00
> [  320.341659] tda18271_dump_regs: [12-0060|M] CAL_DIV_BYTE_1     = 0x00
> [  320.341660] tda18271_dump_regs: [12-0060|M] CAL_DIV_BYTE_2     = 0x00
> [  320.341662] tda18271_dump_regs: [12-0060|M] CAL_DIV_BYTE_3     = 0x00
> [  320.341663] tda18271_dump_regs: [12-0060|M] MAIN_POST_DIV_BYTE = 0x00
> [  320.341664] tda18271_dump_regs: [12-0060|M] MAIN_DIV_BYTE_1    = 0x00
> [  320.341665] tda18271_dump_regs: [12-0060|M] MAIN_DIV_BYTE_2    = 0x00
> [  320.341667] tda18271_dump_regs: [12-0060|M] MAIN_DIV_BYTE_3    = 0x00
> [  320.341668] Error reading device ID @ 12-0060, bailing out.
> [  320.341670] tda18271_attach: [12-0060|M] error -5 on line 1285
> [  320.341673] tda18271 12-0060: destroying instance
> [  320.341688] em28xx: Registered (Em28xx dvb Extension) extension
>
> I read the TDA18271HD datasheet section on i2c -
>
> Remark: The I2C-bus read in the TDA18271HD must read the entire
> I2C-bus map, with required subaddress 00h. The number of bytes read is
> 16, or 39 in extended register mode; see Table 7. Reading write-only
> bits can return values that are different from the programmed values.
>
>
> And - TDA18271 module is not the problem because I tested another
> device with an Au0828 usb bridge and Au8522 demodulator and TDA18271
> tuner -
>
> [ 4552.248898] usb 1-3: New USB device found, idVendor=05e1, idProduct=0400
> [ 4552.248906] usb 1-3: New USB device strings: Mfr=1, Product=2,
> SerialNumber=10
> [ 4552.248911] usb 1-3: Product: Auvitek
> [ 4552.248914] usb 1-3: Manufacturer: Auvitek
> [ 4552.248918] usb 1-3: SerialNumber: 000000000000001
> [ 4552.656242] au0828: i2c bus registered
>
> ....
>
> [ 4552.717745] au0828: i2c_xfer(num = 1)
> [ 4552.717748] au0828: i2c_xfer(num = 1) addr = 0x47  len = 0x0
> [ 4552.717749] au0828: i2c_readbytes()
> [ 4552.718115] au0828:  RECV:
> [ 4552.844998] au0828: au0828: i2c scan: found device @ 0x8e  [au8522]
> ....
> [ 4552.850466] au0828: i2c_xfer(num = 1)
> [ 4552.850469] au0828: i2c_xfer(num = 1) addr = 0x50  len = 0x0
> [ 4552.850470] au0828: i2c_readbytes()
> [ 4552.850836] au0828:  RECV:
> [ 4552.978809] au0828: au0828: i2c scan: found device @ 0xa0  [eeprom]
> ....
>
> [ 4553.876897] au0828: i2c_xfer(num = 1)
> [ 4553.876900] au0828: i2c_xfer(num = 1) addr = 0x5f  len = 0x0
> [ 4553.876900] au0828: i2c_readbytes()
> [ 4553.877251] au0828:  RECV:
> [ 4553.877509] au0828: i2c_xfer(num = 1)
> [ 4553.877511] au0828: i2c_xfer(num = 1) addr = 0x60  len = 0x0
> [ 4553.877512] au0828: i2c_readbytes()
> [ 4553.877878] au0828:  RECV:
> [ 4553.878130] au0828: i2c_xfer(num = 1)
> [ 4553.878133] au0828: i2c_xfer(num = 1) addr = 0x61  len = 0x0
> [ 4553.878134] au0828: i2c_readbytes()
> [ 4553.878503] au0828:  RECV:
> ....
> *Tuner not "detected" during i2c_scan*
> ....
> [ 4554.089719] tda18271 12-0060: creating new instance
> [ 4554.089723] au0828: i2c_xfer(num = 1)
> [ 4554.089726] au0828: i2c_xfer(num = 1) addr = 0x47  len = 0x3
> [ 4554.089728] au0828: i2c_sendbytes()
> [ 4554.090108] au0828: SEND: 47
> [ 4554.090110] au0828:  81
> [ 4554.090187] au0828:  06
> [ 4554.090361] au0828:  01
> [ 4554.090856] au0828:
> [ 4554.090865] au0828: i2c_xfer(num = 2)
> [ 4554.090868] au0828: i2c_xfer(num = 2) addr = 0x60  len = 0x1
> [ 4554.090870] au0828: i2c_sendbytes()
> [ 4554.091221] au0828: SEND: 60
> [ 4554.091224] au0828:  00
> [ 4554.092849] au0828:
> [ 4554.092852] au0828: i2c_readbytes()
> [ 4554.093212] au0828:  RECV:
> [ 4554.093588] au0828:  84
> [ 4554.093959] au0828:  c8
> [ 4554.094336] au0828:  80
> [ 4554.094709] au0828:  46
> [ 4554.095087] au0828:  df
> [ 4554.095461] au0828:  92
> [ 4554.096088] au0828:  60
> [ 4554.096463] au0828:  30
> [ 4554.096834] au0828:  00
> [ 4554.097212] au0828:  00
> [ 4554.097584] au0828:  00
> [ 4554.097971] au0828:  00
> [ 4554.098335] au0828:  00
> [ 4554.098709] au0828:  00
> [ 4554.099086] au0828:  00
> [ 4554.099458] au0828:  00
> [ 4554.099871] au0828:
> [ 4554.099876] au0828: i2c_xfer(num = 1)
> [ 4554.099878] au0828: i2c_xfer(num = 1) addr = 0x47  len = 0x3
> [ 4554.099879] au0828: i2c_sendbytes()
> [ 4554.100212] au0828: SEND: 47
> [ 4554.100214] au0828:  81
> [ 4554.100335] au0828:  06
> [ 4554.100458] au0828:  00
> [ 4554.101082] au0828:
> [ 4554.101090] tda18271_dump_regs: [12-0060|M] === TDA18271 REG DUMP ===
> [ 4554.101092] tda18271_dump_regs: [12-0060|M] ID_BYTE            = 0x84
> [ 4554.101093] tda18271_dump_regs: [12-0060|M] THERMO_BYTE        = 0xc8
> [ 4554.101095] tda18271_dump_regs: [12-0060|M] POWER_LEVEL_BYTE   = 0x80
> [ 4554.101096] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_1   = 0x46
> [ 4554.101097] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_2   = 0xdf
> [ 4554.101098] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_3   = 0x92
> [ 4554.101100] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_4   = 0x60
> [ 4554.101101] tda18271_dump_regs: [12-0060|M] EASY_PROG_BYTE_5   = 0x30
> [ 4554.101102] tda18271_dump_regs: [12-0060|M] CAL_POST_DIV_BYTE  = 0x00
> [ 4554.101104] tda18271_dump_regs: [12-0060|M] CAL_DIV_BYTE_1     = 0x00
> [ 4554.101105] tda18271_dump_regs: [12-0060|M] CAL_DIV_BYTE_2     = 0x00
> [ 4554.101106] tda18271_dump_regs: [12-0060|M] CAL_DIV_BYTE_3     = 0x00
> [ 4554.101108] tda18271_dump_regs: [12-0060|M] MAIN_POST_DIV_BYTE = 0x00
> [ 4554.101109] tda18271_dump_regs: [12-0060|M] MAIN_DIV_BYTE_1    = 0x00
> [ 4554.101110] tda18271_dump_regs: [12-0060|M] MAIN_DIV_BYTE_2    = 0x00
> [ 4554.101111] tda18271_dump_regs: [12-0060|M] MAIN_DIV_BYTE_3    = 0x00
> [ 4554.101112] TDA18271HD/C2 detected @ 12-0060
>
> And this Auvitek device works just fine.
>
> Another strange behavior - on removing and re-attaching the Kworld 340U device -
>
> Now the i2cscan shows -
>
> [ 7349.417593] em2870 #0 at em28xx_i2c_xfer: read stop addr=c0 len=0:
> [ 7349.417595] (pipe 0x80000380): IN:  c0 02 00 00 c0 00 01 00
> [ 7349.417844] <<< 10
> [ 7349.417850] (pipe 0x80000380): IN:  c0 00 00 00 05 00 01 00 <<< 10
> [ 7349.417959]  no device
> [ 7349.417963] em2870 #0 at em28xx_i2c_xfer: read stop addr=c2 len=0:
> [ 7349.417965] (pipe 0x80000380): IN:  c0 02 00 00 c2 00 01 00
> [ 7349.418343] <<< 84
> [ 7349.418349] (pipe 0x80000380): IN:  c0 00 00 00 05 00 01 00 <<< 00
>
> [ 7349.418468] em2870 #0: found i2c device @ 0xc2 on bus 0 [tuner (analog)]
> [ 7349.418470] em2870 #0 at em28xx_i2c_xfer: read stop addr=c4 len=0:
> [ 7349.418472] (pipe 0x80000380): IN:  c0 02 00 00 c4 00 01 00
> [ 7349.418718] <<< 00
> [ 7349.418724] (pipe 0x80000380): IN:  c0 00 00 00 05 00 01 00 <<< 10
> [ 7349.418834]  no device
> ..
> So the tuner address changed from 0xC4 to 0xC4 by removing and re-attaching?
>
> EEPROM info..
>
> [ 7349.369253] eeprom 00000000: 1a eb 67 95 80 1b 40 a3 c0 13 6b 10 6a
> 22 00 00  ..g...@...k.j"..
> [ 7349.369256] eeprom 00000010: 00 00 04 57 00 0d 00 00 00 00 00 00 00
> 00 00 00  ...W............
> [ 7349.369260] eeprom 00000020: 44 00 00 00 f0 10 01 00 00 00 00 00 5b
> 1c c0 00  D...........[...
> [ 7349.369263] eeprom 00000030: 00 00 20 40 20 80 02 20 01 01 00 00 00
> 00 00 00  .. @ .. ........
> [ 7349.369265] eeprom 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369268] eeprom 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369270] eeprom 00000060: 00 00 00 00 00 00 00 00 00 00 22 03 55
> 00 53 00  ..........".U.S.
> [ 7349.369272] eeprom 00000070: 42 00 20 00 32 00 38 00 37 00 30 00 20
> 00 44 00  B. .2.8.7.0. .D.
> [ 7349.369275] eeprom 00000080: 65 00 76 00 69 00 63 00 65 00 00 00 00
> 00 00 00  e.v.i.c.e.......
> [ 7349.369277] eeprom 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369279] eeprom 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369282] eeprom 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369284] eeprom 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369287] eeprom 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369289] eeprom 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369291] eeprom 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00  ................
> [ 7349.369297] em2870 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x2888a312
> [ 7349.369299] em2870 #0: EEPROM info:
> [ 7349.369301] em2870 #0: No audio on board.
> [ 7349.369302] em2870 #0: 500mA max power
> [ 7349.369306] em2870 #0: Table at offset 0x04, strings=0x226a, 0x0000, 0x0000
>
> I have hit a wall trying to figure this out and will appreciate any help.
>
> I did try to use the Kworld device on windows XP once - using the
> driver provided by the manufacturer- could that have caused an
> irreparable damage ? changed something?
> is it the em28xx_i2c_xfer call not following the "read entire i2c bus
> map" remark from the TDA18271 datasheet?
> I have tried probing the bus at 0x60 with i2cdetect and i2cdump with no success.
>
> This error (ERROR:i2c_transfer returned:-X) is widely prevalent on
> google search-mostly appearing after a kernel upgrade so I am inclined
> to think that this is a software issue rather than a faulty hardware
> Any help/pointer would be appreciated.
>
> Thank you!
