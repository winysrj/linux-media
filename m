Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <insomniac@slackware.it>) id 1JbJup-0000cn-JL
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 19:18:32 +0100
Date: Mon, 17 Mar 2008 19:15:44 +0100
From: insomniac <insomniac@slackware.it>
To: "Albert Comerma" <albert.comerma@gmail.com>, linux-dvb@linuxtv.org
Message-ID: <20080317191544.3bbc752c@slackware.it>
In-Reply-To: <ea4209750803170542k5750ada8hf604f587ed46a278@mail.gmail.com>
References: <20080316182618.2e984a46@slackware.it>
	<20080317025002.2fee3860@slackware.it> <47DDD009.30504@iki.fi>
	<20080317025849.49b07428@slackware.it> <47DDD817.9020605@iki.fi>
	<20080317104147.1ade57fe@slackware.it>
	<20080317114802.0df56399@slackware.it>
	<abf3e5070803170409j8be4c54r96f97eb2d3fd4dac@mail.gmail.com>
	<47DE5F42.8070005@iki.fi>
	<ea4209750803170535m36914e6bu93e39269e8c7faf3@mail.gmail.com>
	<ea4209750803170542k5750ada8hf604f587ed46a278@mail.gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] New unsupported device
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

On Mon, 17 Mar 2008 13:42:14 +0100
"Albert Comerma" <albert.comerma@gmail.com> wrote:

> wget http://www.barbak.org/v4l_for_72e_dongle.tar.bz2
> tar xvjf v4l_for_72e_dongle.tar.bz2
> cd v4l-dvb
> sudo cp firmware/dvb-usb-dib0700-1.10.fw /lib/firmware/
> make all
> sudo make install
> 
> Probably you will have to add the stuff that was being done in the
> previous patch to the source before compilation.

After patching by hand the source code from v4l_for_72e (due to one hunk
rejected) with Antti's patch, and doing small changes to match my kernel
version, drivers compiled and installed. Here is the dmesg after I
plugged the card:

dib0700: loaded with support for 5 different device-types
usbcore: registered new interface driver dvb_usb_dib0700

but nothing more. This time no /dev/dvb/ was created, so it looks like a
step backward :-(

Regards,
-- 
Andrea Barberio

a.barberio@oltrelinux.com - Linux&C.
andrea.barberio@slackware.it - Slackware Linux Project Italia
GPG key on http://insomniac.slackware.it/gpgkey.asc
2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
SIP: 5327786, Phone: 06 916503784

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
