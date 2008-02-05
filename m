Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+542baf0462bae6c57a94+1626+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JMKSD-0001bd-BH
	for linux-dvb@linuxtv.org; Tue, 05 Feb 2008 10:51:01 +0100
Date: Tue, 5 Feb 2008 07:50:14 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Richard (MQ)" <osl2008@googlemail.com>
Message-ID: <20080205075014.6b7091d9@gaivota>
In-Reply-To: <47A5D8AF.2090800@googlemail.com>
References: <47A5D8AF.2090800@googlemail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Richard,

On Sun, 03 Feb 2008 15:07:27 +0000
"Richard (MQ)" <osl2008@googlemail.com> wrote:

> I tried contacting Markus with the following but no response - probably
> one of you experienced coders on this list will know what's wrong
> though? As I say below, the 'standard' v4l-dvb builds fine but is no use
> with this card.

I've ported Markus patch for cx88 and saa7134 xc3028-based boards into this
tree:

http://linuxtv.org/hg/~mchehab/cx88-xc2028

Some adjustments may be needed for this to work, since tuner-xc2028 needs
to know what firmware it will load for dvb. This is done by those lines, at
the end of saa7134-cards.c:

                /* FIXME: This should be device-dependent */
                ctl.demod = XC3028_FE_OREN538;
                ctl.mts = 1;

ctl.demod should have the IF of the used tuner. Most current boards use
IF=5.380 MHz. XC3028_FE_OREN538 is an alias for 5380.
Another possible value is XC3028_FE_ZARLINK456 (IF = 4560 KHz).

ctl.mts affects audio decoding. If you don't have audio on
analog mode, you may try to change this to 0.

For the driver to work, you'll need to extract xc3028 firmware. Most devices
works fine with Xceive firmware version 2.7. In order to extract, you should
follow the following procedure:

      1) Download the windows driver with something like:
              wget http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip

      2) Extract the file hcw85bda.sys from the zip into the current dir:
              unzip -j HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys

      3) run the script:
	      ./linux/Documentation/video4linux/extract_xc3028.pl

      4) copy the generated file:
              cp xc3028-v27.fw /lib/firmware

Could you please test it and give us some feedback?

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
