Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+4dc86fa686558c999142+1636+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JQ710-0002w8-B1
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 21:18:34 +0100
Date: Fri, 15 Feb 2008 18:18:15 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Albert Comerma" <albert.comerma@gmail.com>
Message-ID: <20080215181815.2583a2e5@gaivota>
In-Reply-To: <ea4209750802141220s2402e94bvbd1479037d48cfc8@mail.gmail.com>
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802141220s2402e94bvbd1479037d48cfc8@mail.gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
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

Hi Albert,

On Thu, 14 Feb 2008 21:20:32 +0100
"Albert Comerma" <albert.comerma@gmail.com> wrote:

> [ 2251.856000] xc2028 4-0061: Error on line 1063: -5

The above error is really weird. It seems to be related to something that
happened before xc2028, since firmware load didn't start on that point of the
code.


> [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
This message means that xc3028 firmware were successfully loaded and it is
running ok. 

> [ 2282.504000] xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
> [ 2289.104000] xc2028 4-0061: Loading firmware for type=D2620 DTV8 (208), id 0000000000000000.
> [ 2289.224000] xc2028 4-0061: Loading SCODE for type=DTV8 SCODE HAS_IF_5400 (60000200), id 0000000000000000.

The above messages state what firmware you've loaded.

xc3028 version 2.7 has 80 different firmwares. If you load a wrong one, your
device won't work.

>From the above, the driver is assuming that you're on an area with 8MHz video
channels. Also, your demod should be using IF = 5.4 MHz:

Firmware 64, type: DTV8 CHINA SCODE HAS IF (0x64000200), IF = 5.40 MHz id: (0000000000000000), size: 192

Does the above firmware correspond to your configuration?

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
