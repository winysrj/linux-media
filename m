Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+b9c06d2e3da2f0ede24a+1668+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JbjIW-00047A-TT
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 22:24:41 +0100
Date: Tue, 18 Mar 2008 18:23:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Albert Comerma" <albert.comerma@gmail.com>
Message-ID: <20080318182338.19dd7ff5@gaivota>
In-Reply-To: <ea4209750803181311y17782b40ib95f900b99bf6673@mail.gmail.com>
References: <ea4209750803181311y17782b40ib95f900b99bf6673@mail.gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PATCH Pinnacle 320cx Terratec Cinergy HT USB XE
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

On Tue, 18 Mar 2008 21:11:52 +0100
"Albert Comerma" <albert.comerma@gmail.com> wrote:

Hi Albert,

The patch looks sane, but I have a few comments to improve it:

> diff -crB v4l-dvb-orig/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c v4l-cyn/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c

Please, use unified diff format (diff -upr). If you're using the Mercurial
tree, the better is to use "hg diff". It will produce the patch with the proper
format.

> +        712,  // inv_gain

We shouldn't use C99 type of comments. All coments should use the standard C way:
	712, /* inv_gain */

Please use "make checkpatch" [1]. This will produce several warnings about Linux
CodingStyle violations, and you help you to fulfill the current rules, like the
above.

If you have any doubts on how to submit a patch, please read README.patches [2].

[1] If you're patching against v4l-dvb development tree, available at
http://linuxtv.org/hg/v4l-dvb. Otherwise, you'll need to run Kernel
script/checkpatch.pl by hand.

[2] http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches


> +        case XC2028_RESET_CLK:
> +                err("%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
> +                break;

There's no need anymore to implement reset_clk. Please test without it. The
only driver that currently needs this callback is tm6000.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
