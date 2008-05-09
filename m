Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ppp196-18.static.internode.on.net ([59.167.196.18]
	helo=jumpgate.rods.id.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Rod@Rods.id.au>) id 1JufMG-0008Hm-Qf
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 05:02:54 +0200
Received: from jumpgate.rods.id.au (localhost [127.0.0.1])
	by jumpgate.rods.id.au (Postfix) with ESMTP id AB2DE5BAE1F
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 09:57:53 +1000 (EST)
Received: from [192.168.3.44] (shadow.rods.id.au [192.168.3.44])
	by jumpgate.rods.id.au (Postfix) with ESMTP id 837105813F4
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 09:57:53 +1000 (EST)
Message-ID: <4824E501.1060508@Rods.id.au>
Date: Sat, 10 May 2008 09:57:53 +1000
From: Rod <Rod@Rods.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------040101010203080606050102"
Subject: [linux-dvb] [Fwd: Re: Try to Make DVB-T part of Compro VideoMate
	T750 Work]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------040101010203080606050102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Forgot to cc the list ;o(

--------------040101010203080606050102
Content-Type: message/rfc822;
 name="Re: Try to Make DVB-T part of Compro VideoMate T750 Work.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="Re: Try to Make DVB-T part of Compro VideoMate T750 Work.eml"

Received: from 58.105.235.135.optusnet.com.au ([58.105.235.135])
        (SquirrelMail authenticated user yendor)
        by www.rods.id.au with HTTP;
        Fri, 9 May 2008 13:11:31 +1000 (EST)
Message-ID: <2027.58.105.235.135.1210302691.squirrel@www.rods.id.au>
In-Reply-To: <200805082312.59928.b87605214@ntu.edu.tw>
References: <200805071307.15982.b87605214@ntu.edu.tw>
    <48219F49.9090709@Rods.id.au>
    <200805082312.59928.b87605214@ntu.edu.tw>
Date: Fri, 9 May 2008 13:11:31 +1000 (EST)
Subject: Re: Try to Make DVB-T part of Compro VideoMate T750 Work
From: "Rod Smart" <Rod@Rods.id.au>
To: "lin" <b87605214@ntu.edu.tw>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
X-Priority: 3 (Normal)
Importance: Normal
Content-Transfer-Encoding: quoted-printable


> On 2008 May 7 Wednesday 20:23:37 you wrote:
>>     Hi, what I2C addresses are you using for each device?
>
> Hi, Rod:
>
> Sorry for late replying...
>
> Following is my patch to v4l-dvb (v4l-dvb-4c4fd6b8755c)
> The patch is mainly adapted from Newbigin's patch, but the case in
> saa7134_board_init2 is talltolly a nonsense guessing...    lol
>
> Ask a newbie question...  lol
> What's the role of I2C plays in between these chips?
>
> linleno
> ---
>
> diff -ru
> v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-card=
s.c
> v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-cards.c
> ---
> v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-card=
s.c
>  2008-05-02 18:51:27.000000000 +0800
> +++ v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-card=
s.c
>      2008-05-08 22:42:06.000000000 +0800
> @@ -5936,6 +5936,7 @@
>         case SAA7134_BOARD_AVERMEDIA_SUPER_007:
>         case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
>         case SAA7134_BOARD_CREATIX_CTX953:
> +       case SAA7134_BOARD_VIDEOMATE_T750:
>         {
>                 /* this is a hybrid board, initialize to analog mode
>                  * and configure firmware eeprom address
> diff -ru
> v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-dvb.=
c
> v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-dvb.c
> ---
> v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-dvb.=
c
>  2008-05-02 18:51:27.000000000 +0800
> +++ v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-dvb.=
c
>      2008-05-08 22:42:54.000000000 +0800
> @@ -40,6 +40,8 @@
>  #include "tda1004x.h"
>  #include "nxt200x.h"
>  #include "tuner-xc2028.h"
> +#include "zl10353.h"
> +#include "qt1010.h"
>
>  #include "tda10086.h"
>  #include "tda826x.h"
> @@ -937,6 +939,17 @@
>         .demod_address    =3D 0x0a,
>  };
>
> +static struct zl10353_config videomate_t750_zl10353_config =3D {
> +       .demod_address  =3D 0x0f,
> +       .no_tuner =3D 0,
> +       .parallel_ts =3D 1,
> +};
> +
> +static struct qt1010_config videomate_t750_qt1010_config =3D {
> +       .i2c_address =3D 0x62
> +};
> +
> +
>  /* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   * Core code
>   */
> @@ -1263,15 +1276,33 @@
>                         goto dettach_frontend;
>                 break;
>         case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
> -#if 0
> -       /*FIXME: What frontend does Videomate T750 use? */
> -       case SAA7134_BOARD_VIDEOMATE_T750:
> -#endif
>                 dev->dvb.frontend =3D dvb_attach(mt352_attach,
>                                                &avermedia_e506r_mt352_d=
ev,
>                                                &dev->i2c_adap);
>                 attach_xc3028 =3D 1;
>                 break;
> +#if 1
> +       /*FIXME: What frontend does Videomate T750 use? */
> +       case SAA7134_BOARD_VIDEOMATE_T750:
> +               printk("Compro VideoMate T750 DVB setup\n");
> +               dev->dvb.frontend =3D dvb_attach(zl10353_attach,
> +
> &videomate_t750_zl10353_config,
> +                                               &dev->i2c_adap);
> +               if (dev->dvb.frontend !=3D NULL) {
> +                       printk("Attaching pll\n");
> +                       // if there is a gate function then the i2c bus
> breaks.....!
> +                       dev->dvb.frontend->ops.i2c_gate_ctrl =3D 0;
> +
> +                       if (dvb_attach(qt1010_attach,
> +                                      dev->dvb.frontend,
> +                                      &dev->i2c_adap,
> +                                      &videomate_t750_qt1010_config) =3D=
=3D
> NULL)
> +                       {
> +                               wprintk("error attaching QT1010\n");
> +                       }
> +               }
> +               break;
> +#endif
>         case SAA7134_BOARD_MD7134_BRIDGE_2:
>                 dev->dvb.frontend =3D dvb_attach(tda10086_attach,
>                                                 &sd1878_4m,
> &dev->i2c_adap);
>

Ok, here is the physical electrical connections I had posted elsewhere...

 The RTC is connected to the I2C buss from the SAA7135, the INT
 output is connected thru a custom driver chip (seems like just a custom
 driver similar to a ULN2004 driver chip, I doubt its I2C, it wouldn't
 buzz out to that chip, the following addresses are the hard wired
addresses on the PCB

 I2C addresses
 QT1010 =3D 0xA0 DVB Front End (#)
 DS1337 =3D 0xD0 RTC, the Alarm out restarts the computer
 HT24LC02 =3D 0xA0 CMOS 2K 2-wire serial EEPROM (#)
 XC2028 =3D 0x Analog/Radio front End (Difficult to get
 address info, as its a BGA)
 CE6353 =3D 0x1E Nordig Unified DVB-T CDFDM Terrestrial
 Demodulator

 (#) Now, as you notice, the I2C address for the QT1010 and the EEPROM
 have the same address (0xA0) I feel (assume, could be wrong) that the
 I2C for the QT device is wired to the 2nd port of the CE6353 device

 QT1010 (module)
 DS1337 (module)
 XC2028 (CX8800 =3D module) or CX88... series modules
 CE6353 not sure of the module for this yet... not sure how
 programmable it is


 Have a PDF of the QT1010, cannot find the linky again
 DS1337 http://datasheets.maxim-ic.com/en/ds/DS1337-DS1337C.pdf
 CE6353 http://download.intel.com/design/celect/datashts/D55752.pdf



 CE6353 looks pin-for-pin compatable for the following (Zarlink Devices)
 http://www.pctuner.ru/files/pdf/zarlink_mt352.pdf
 http://www.pctuner.ru/files/pdf/zarlink_zl10353.pdf
     There is a linky on the Intel web site for cross referencing the CE
 with Zarlink

 Also the I2C address on the chip Doc refers to SADD0:4, in the doc,
 it said that "In the current TNIM evaluation application, the 2-wire bus
 address is 0001 111 R/ W with the pins connected as
 follows:"

     I actually found this rather difficult to understand, but I guess I
 sussed it...  SADD0:4 is 5 pins that are tied to Vdd or Vss, but the pin
 outs state they are N.C. (Non Connected) strange..

 For the T-750 the configuration is 0001 111r/w Strange how they
 didn't change it, but thats what happens when you follow App notes,...

 So, I hope this helps someone getting these little beasties going, I
 would love to utilise them ;o)


     Ok, that little bit above was posted on the MythTV-users listserv,
 no one replied to it  ;o(

      Ok, now for more information, I havn't found this posted on the
 Internet anywhere, so I did some probing myself, if I had the computer I
 used to have at work, I could post almost the complete circuit diagram
 gained from the PCB, and possibly got myself into some real trouble :P

     I don't know what the PRO1A does, but I feel its a port driver, or a
 masked ROM, or a Fuse link device...

     Someone did mention that the tops of the IC's were damaged, and
 difficult to read, if you live in Australia, go out and buy yourself a
 bottle of "Eucalyptus Oil" it'll clean those chips up really well for
 you, the device is something like a 74ALC74 (or is it ALC174, no matter,
 its just a simple chip, driving the switch gear to control the outputs,
 nothing really special, I think its driven a bit by the PRO1A device, if
 I had that computer (mentioned above) I'd have that figgured out

     I2C comms are as above, no more clarity needed I think..

     I think the bit that people are having a problem with is the GPIO
 connections... I'm not sure how accurate the Windoze scanner is, but
 here is what I probed...

     Format, is SAA7134 (SAA) -> CE6353 (CE)
 SAA Pin:Desig -> CE Pin:Desig
 86:GPIO0 -> 49:MDO0
 85:GPIO1 -> 50:MDO1
 84:GPIO2 -> 51:MDO2
 83:GPIO3 -> 52:MDO3
 82:GPIO4 -> 53:MDO4
 81:GPIO5 -> 56:MDO5
 80:GPIO6 -> 57:MDO6
 79:GPIO7 -> 58:MDO7

 68:GPIO16 -> 48:MOVAL

 60:GPIO19 -> 47:MOSTRT
 59:GPIO20 -> 61:MOCLK

     Next is the GPIO to the PRO1A Device from the SAA

 SAA 78:GPIO8 -> PRO1A U5:6  (U5 is the PRO1A Desig)

 77:GPIO9 -> U5:7
 76:GPIO10 -> U5:8
 77:GPIO11 -> U5:9

 61:GPIO18 -> U5:12

 56:GPIO23 -> U5:13 (or 14) strange, same resistance to either pin from
 GPIO23 200-500R (Ohms)

     Next, not 100% sure of these being No-Connect... further
 investigation (another lunch break)

 72:GPIO12
 71:GPIO13
 70:GPIO14
 69:GPIO15
 58:GPIO21
 57:GPIO22
 89:GPIO25
 88:GPIO26
 87:GPIO27

     Ok, I hope this helps get this little cart moving...

    Well, had lunch today, and probed deeper into the card, probing with
some nice sharp test probes (POGO series from ECT)

SAA:70:GPIO14 -> RT104 -> CE:9:RESET

    RT104 is missing, Reset connected to a RC circuit.

SAA:71:GPIO13 -> U5:11
SAA:72:GPIO12 -> U5:10

    There are a number of Test Points (TPx) on the back, near the Analog
can,

TP9 -> Vdd
TP8 -> SAA:69:GPIO15 (with pull-up resistor)
TP6 -> SDA (I2C on SAA)
TP5 -> SCL (I2D on SAA)
TP3 -> C93 -> SAA:106:SIF

    Guessing,

TP8 =3D Active Low signal to the XC device
TP5/6 =3D I2C comms (Given)
TP3 =3D IF signal Capactively coupled to the IF input of the SAA device

    I think thats about all..

--=20
Qn. Whats the differance between a Snake and a Onion?

Ans. No one cries when you chop up a Snake
  (SOLS - Snake Tales)

--------------040101010203080606050102
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040101010203080606050102--
