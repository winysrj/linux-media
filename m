Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+29c84a3af63de8e07a22+1677+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jew7y-0003Cy-O6
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 18:43:02 +0100
Date: Thu, 27 Mar 2008 14:42:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080327144221.2d642590@gaivota>
In-Reply-To: <1206635698.5965.5.camel@ubuntu>
References: <1206635698.5965.5.camel@ubuntu>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
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

On Fri, 28 Mar 2008 01:34:58 +0900
timf <timf@iinet.net.au> wrote:

> [   53.141643] xc2028 2-0061: seek_firmware called, want type=F8MHZ SCODE (20000002), id 0000000100000007.
> [   53.141649] xc2028 2-0061: Selecting best matching firmware (3 bits) for type=SCODE (20000000), id 0000000100000007:
> [   53.141654] xc2028 2-0061: Found firmware for type=SCODE (20000000), id 0000000200000007.
> [   53.141658] xc2028 2-0061: Loading SCODE for type=SCODE HAS_IF_5640 (60000000), id 0000000200000007.
> [   53.233496] xc2028 2-0061: Device is Xceive 3028 version 1.0, firmware version 2.7

Unfortunately, you've suppressed the previous firmware loading lines. Up to here, everything is OK.

> [   53.445170] xc2028 2-0061: Device is Xceive 3028 version 1.0, firmware version 2.7

Still OK here.

> Mar 28 00:25:41 ubuntu kernel: [  352.902182] xc2028 2-0061: checking firmware, user requested type=F8MHZ (2), id 00000000000000ff, scode_tbl (0), scode_nr 0

Now, tvtime asked a different firmware from the previous one. tuner-xc2028 will try to load a new firmware set to match your video standard.

> Mar 28 00:25:41 ubuntu kernel: [  352.902196] xc2028 2-0061: load_firmware called
> Mar 28 00:25:41 ubuntu kernel: [  352.902199] xc2028 2-0061: seek_firmware called, want type=BASE F8MHZ (3), id 0000000000000000.
> Mar 28 00:25:41 ubuntu kernel: [  352.902203] xc2028 2-0061: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.

It is trying to load F8MHz base firmware. This firmware seemed to be already
loaded, but, since you've asked for a different standard, it will discard and
reload the firmwares.

> Mar 28 00:25:41 ubuntu kernel: [  352.902207] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
> Mar 28 00:25:41 ubuntu kernel: [  352.903020] xc2028 2-0061: i2c output error: rc = -5 (should be 64)
> Mar 28 00:25:41 ubuntu kernel: [  352.903022] xc2028 2-0061: -5 returned from send
> Mar 28 00:25:41 ubuntu kernel: [  352.903026] xc2028 2-0061: Error -22 while loading base firmware
> Mar 28 00:25:42 ubuntu kernel: [  352.955955] xc2028 2-0061: Retrying firmware load

The driver didn't like the idea of changing the firmware. Probably, the RESET
command is wrong or incomplete (i suspect the latter).

If you look on other drivers, like cx88, a reset do something like:

                cx_write(MO_GP1_IO, 0x101010);
                mdelay(250);
                cx_write(MO_GP1_IO, 0x101000);
                mdelay(250);
                cx_write(MO_GP1_IO, 0x101010);
                mdelay(250);

The first command is probably not needed, but the basic idea is to do something
like ON-OFF-ON. However, on saa7134 code is something like:

                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);

I suspect that this should be something like:

                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);
                mdelay(250);
                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0);
                mdelay(250);
                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);
                mdelay(250);

OR:
                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0);
                mdelay(250);
                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);
                mdelay(250);
                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0);

To be sure, I would need to have the regspy.exe (from Dscaler) results when a
reset occurs on your board.

Could you please try to play with those things on your board and post the results?

Another interesting test would be to not let tvtime to select a different
standard, but, instead, the same std loaded initially. This may help to see if
your tuner is ok (if you see some kind of white noise or a bad tuned channel -
this means that tuner is working - of course you'll need to disable signal detection).


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
