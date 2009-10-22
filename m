Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32708.mail.mud.yahoo.com ([68.142.207.252]:33527 "HELO
	web32708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751612AbZJVEoX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 00:44:23 -0400
Message-ID: <759651.95734.qm@web32708.mail.mud.yahoo.com>
Date: Wed, 21 Oct 2009 21:44:27 -0700 (PDT)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: Kworld 315U help?
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <829197380910212116k7c14069fuebecd6bf3075983@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin, 


> c4 and c6 are probably also the tuner.  I know that
> K-World makes some
> products with the same name but different regions.  Is
> your version of
> the 315U an ATSC hybrid tuner?  If so, then one of
> those addresses is
> probably the demod.

I believe the device I have is a hybrid tuner since it does both digital and analog.

> 
> Also, the trace you sent is just an excerpt, but it's
> possible that
> the driver is probing for devices and the requests are
> failing because
> the hardware isn't present (the Windows driver supports a
> variety of
> different hardware combinations).  Usually you can
> tell by looking for
> a read from register 0x05 immediately after the i2c
> read.  If register
> 0x05 is nonzero, then the i2c read operation failed.

This is good information to know.  Here are the list of components that are on the board along with the address..  

   1. LG LGDT3303   - 0x1c
   2. Lattice ISP2032VE  - ?? don't know the address
   3. Phillips SAA7113H  - 0x4a
   4. Empia EMP202
   5. Empia EM2882
   6. Thomson DTT 7611A  - 0xc2

In addition there is a TDA at 0x86 and we also know the eeprom is at 0xa0. 
I'm attaching the output that I parsed the using the updated parse1b_sniffusb2.pl script as well as the output from a slightly modified parse_em28xx.pl.  I modified the parse_em28xx.pl to output the stuff it did not decode.  

In the tar ball are 2 files.  emparse1new.out (obtained using parse_em28xx.pl) and newlog.out (obtained using the updated script)

These traces are for the component inputs of the kworld 315U device.  I have other traces as well for the TV and Svideo inputs.  You can find pictures of the device here..  http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_315U

In the source this I added this information that has been commented out. I believe this is how the the board is configured according to what I decoded out of the traces some time ago.  

               /* Analog mode - still not ready */
                /*.input        = { {
                        .type = EM28XX_VMUX_TELEVISION,
                        .vmux = SAA7115_COMPOSITE2,
                        .amux = EM28XX_AMUX_VIDEO,
                        .gpio = em2882_kworld_315u_analog,
                        .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,
                }, {
                        .type = EM28XX_VMUX_COMPOSITE1,
                        .vmux = SAA7115_COMPOSITE0,
                        .amux = EM28XX_AMUX_LINE_IN,
                        .gpio = em2882_kworld_315u_analog1,
                        .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,
                }, {
                        .type = EM28XX_VMUX_SVIDEO,
                        .vmux = SAA7115_SVIDEO3,
                        .amux = EM28XX_AMUX_LINE_IN,
                        .gpio = em2882_kworld_315u_analog1,
                        .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,
                } }, */


can you double check this to see if I got things correct?  I think all I need is the correct GPIO sequence but I am not sure.  

Thanks,
Franklin Meng


      
