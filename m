Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3IQQZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 12:25:20 -0400
Date: Tue, 17 Sep 2013 18:25:18 +0200 (CEST)
From: remi <remi@remis.cc>
Reply-To: remi <remi@remis.cc>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Message-ID: <1373709848.211147.1379435118175.open-xchange@email.1and1.fr>
In-Reply-To: <CALzAhNVvz4zoBDAPw609_c+NuPc8JXFj+HqgKWzonEO9oAOMig@mail.gmail.com>
References: <1152216514.26450.1378910904534.open-xchange@email.1and1.fr> <CALzAhNVvz4zoBDAPw609_c+NuPc8JXFj+HqgKWzonEO9oAOMig@mail.gmail.com>
Subject: Re: avermedia A306 / PCIe-minicard (laptop) / CX23885
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello :)

Thnx for the reply !


Well, I do not have the cables ... it's a laptop card, orginally for a Dell,

I am doing my tests on an Acer,


The Video0 dev , composite/s-video is showing an analog signal, i guess a
"noise" picture because not hooked-up,

but bottom half is sometimes green .

Analog scanning/reception = NULL , I might have to check again the antenna
connexion,


For the Mpeg, negative, it's a 9013 chip, I still have to discecte the 9015
driver and pull-out

the 9013 spcific data , iguess .


What I need the most, Is a big picture of the V4L API , like an organigram of
what is where ( initialising this or that,

handeling setups - and controls)


I code, but going thru others Code, is always like playing Maze ... :)
especially an API in a whole System Package...


But I am searching on my side :)


I there a dummy /test driver for PCIe cards I can study ?


Best regards


Rémi.


> Le 17 septembre 2013 à 15:38, Steven Toth <stoth@kernellabs.com> a écrit :
>
>
> > Hello
>
> Hello Remi!
>
> Thank you for looking at the Avercard with the CX23885 driver.
>
> >
> > Antti, redirected me toward you,
>
> What exactly is your question?
>
> > And
> >
> > If it's at the least at the same "stage" as the HC81 , I think it deserve's
> > to
> > be listed in "cards".h
>
> Possibly. Tell us again 1) what you have working reliably 2) what
> isn't working but the driver is exposing and 3) what the driver is
> exposing but has not been tested.
>
> > So people will know right away, that this card has been identified by the
> > V4L
> > community, and dont have
>
> Anyone working on that card would arrive here on the mailing list, I
> don't think that's going to be an issue. I suggest you focus on
> getting feature of the card working reliably, produce a patchset and
> I'm sure it will get reviewed, refined then eventually merged.
>
> Other comments below.
>
> > > +       [CX23885_BOARD_AVERMEDIA_A306] = {
> > > +                .name           = "AVerTV Hybrid Minicard PCIe A306",
> > > +                .tuner_type     = TUNER_XC2028,
> > > +                .tuner_addr     = 0x61, /* 0xc2 >> 1 */
> > > +                .tuner_bus      = 1,
> > > +                .porta          = CX23885_ANALOG_VIDEO,
> > > +               .portb          = CX23885_MPEG_ENCODER,
> > > +                .input          = {{
> > > +                        .type   = CX23885_VMUX_TELEVISION,
> > > +                        .vmux   = CX25840_VIN2_CH1 |
> > > +                                  CX25840_VIN5_CH2 |
> > > +                                  CX25840_NONE0_CH3 |
> > > +                                  CX25840_NONE1_CH3,
> > > +                        .amux   = CX25840_AUDIO8,
> > > +                }, {
> > > +                        .type   = CX23885_VMUX_SVIDEO,
> > > +                        .vmux   = CX25840_VIN8_CH1 |
> > > +                                  CX25840_NONE_CH2 |
> > > +                                  CX25840_VIN7_CH3 |
> > > +                                  CX25840_SVIDEO_ON,
> > > +                        .amux   = CX25840_AUDIO6,
> > > +                }, {
> > > +                        .type   = CX23885_VMUX_COMPONENT,
> > > +                        .vmux   = CX25840_VIN1_CH1 |
> > > +                                  CX25840_NONE_CH2 |
> > > +                                  CX25840_NONE0_CH3 |
> > > +                                  CX25840_NONE1_CH3,
> > > +                        .amux   = CX25840_AUDIO6,
> > > +                }},
> > > +
> > > +       }
>
> Does the card have a MPEG2 hardware compressor and is it functioning
> properly? (/dev/video1)
>
> Are both svideo and component inputs working correctly in tvtime?
>
> What about audio inputs? Does the card have any audio inputs and is
> the driver acting and exposing those features correctly?
>
> If not then please remove any of these sections.
>
> > > +        case CX23885_BOARD_AVERMEDIA_A306:
> > > +                cx_clear(MC417_CTL, 1);
> > > +                /* GPIO-0,1,2 setup direction as output */
> > > +                cx_set(GP0_IO, 0x00070000);
> > > +                mdelay(10);
> > > +                /* AF9013 demod reset */
> > > +                cx_set(GP0_IO, 0x00010001);
> > > +                mdelay(10);
> > > +                cx_clear(GP0_IO, 0x00010001);
> > > +                mdelay(10);
> > > +                cx_set(GP0_IO, 0x00010001);
> > > +                mdelay(10);
> > > +                /* demod tune? */
> > > +                cx_clear(GP0_IO, 0x00030003);
> > > +                mdelay(10);
> > > +                cx_set(GP0_IO, 0x00020002);
> > > +                mdelay(10);
> > > +                cx_set(GP0_IO, 0x00010001);
> > > +                mdelay(10);
> > > +                cx_clear(GP0_IO, 0x00020002);
> > > +                /* XC3028L tuner reset */
> > > +                cx_set(GP0_IO, 0x00040004);
> > > +                cx_clear(GP0_IO, 0x00040004);
> > > +                cx_set(GP0_IO, 0x00040004);
> > > +                mdelay(60);
> > > +                break;
>
> You're setting and clearing the GPIO direction enable registers (upper
> 16 bits), this isn't a good idea.
>
> If you want to drive a GPIO in a specific direction (lower 8 bits),
> perhaps for a reset, instead do this:
>
> /* AF9013 demod reset */
> cx_set(GP0_IO, 0x00010001); /* Establish the direction of the GPIO and
> it's signal level)
> mdelay(10);
> cx_clear(GP0_IO, 0x00000001); /* change the signal level, drive to low */
> mdelay(10);
> cx_set(GP0_IO, 0x00000001); /* back to high */
> mdelay(10);
>
> Repeat this example for other other 'demod tune' and 3028 resets you
> are doing, don't toggle the upper 16bits, else you leave the GPIO
> floating, a bad idea.
>
> - Steve
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
