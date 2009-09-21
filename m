Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:46070 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZIUS0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 14:26:11 -0400
Received: by mail-bw0-f210.google.com with SMTP id 6so2128004bwz.37
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 11:26:14 -0700 (PDT)
Date: Mon, 21 Sep 2009 21:26:10 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Roman <lists@hasnoname.de>
Cc: Antti Palosaari <crope@iki.fi>,
	"Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: MSI Digivox mini III Remote Control
Message-ID: <20090921182610.GA16805@moon>
References: <200909202026.27086.lists@hasnoname.de> <200909211610.52856.lists@hasnoname.de> <4AB78B79.3030203@iki.fi> <200909211631.19838.lists@hasnoname.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909211631.19838.lists@hasnoname.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 21, 2009 at 04:31:19PM +0200, Roman wrote:
> Hi Antti,
> 
> Am Monday 21 September 2009 16:19:37 schrieb Antti Palosaari:
> > > Here is the output of dmesg after reloading the module:
> > > #--
> > > af9015_usb_probe: interface:0
> > > af9015_read_config: IR mode:4
> >
> > IR mode 4 disables it. I have strong feeling it should mean "polling"...
> > Could you change af9015.c around line 720:
> > from: if (val == AF9015_IR_MODE_DISABLED || val == 0x04) {
> > to: if (val == AF9015_IR_MODE_DISABLED) {
> >
> > and test again.
> > Antti
> 
> Ahh progress... ;)
> I did as you suggested, now dmesg shows the IR-device:
> #--
> Sep 21 16:25:50 Seth input: IR-receiver inside an USB DVB receiver 
> as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/input/input7
> Sep 21 16:25:50 Seth dvb-usb: schedule remote query interval to 150 msecs
> #--
> 
> And syslog shows requests like the following:
> #--
> Sep 21 16:26:33 Seth af9015_rc_query: 07 00 27 00 00 00 00 00
> #--
> 
> If it is ok, i will mail the output to you (and not spam the ml), later this 
> day or tomorrow morning, as i have to leave for the university now...
> 

Oh, tested under Windows, hardware is fine afterall.

Applied patch, removed check for val 0x04, now driver gets the scancodes!

So here we are, high-res picture of remote added to wiki at
http://www.linuxtv.org/wiki/index.php/MSI_DIGIVOX_mini_III

32 keys, left-to-right, top-to-bottom:

Sep 21 21:15:30 moon kernel: [ 5216.332334] af9015_rc_query: 07 00 13 00 00 00 00 00
Sep 21 21:15:32 moon kernel: [ 5218.308390] af9015_rc_query: 07 00 3b 00 00 00 00 00
Sep 21 21:15:33 moon kernel: [ 5219.524395] af9015_rc_query: 07 00 3e 00 00 00 00 00
Sep 21 21:15:36 moon kernel: [ 5221.956404] af9015_rc_query: 07 00 0b 00 00 00 00 00
Sep 21 21:15:39 moon kernel: [ 5225.452309] af9015_rc_query: 07 00 1e 00 00 00 00 00
Sep 21 21:15:41 moon kernel: [ 5227.428367] af9015_rc_query: 07 00 1f 00 00 00 00 00
Sep 21 21:15:42 moon kernel: [ 5228.644871] af9015_rc_query: 07 00 20 00 00 00 00 00
Sep 21 21:15:44 moon kernel: [ 5230.164338] af9015_rc_query: 07 00 52 00 00 00 00 00
Sep 21 21:15:46 moon kernel: [ 5232.292388] af9015_rc_query: 07 00 21 00 00 00 00 00
Sep 21 21:15:47 moon kernel: [ 5233.508393] af9015_rc_query: 07 00 22 00 00 00 00 00
Sep 21 21:15:48 moon kernel: [ 5234.572411] af9015_rc_query: 07 00 23 00 00 00 00 00
Sep 21 21:15:50 moon kernel: [ 5236.244373] af9015_rc_query: 07 00 51 00 00 00 00 00
Sep 21 21:15:52 moon kernel: [ 5238.524400] af9015_rc_query: 07 00 24 00 00 00 00 00
Sep 21 21:15:53 moon kernel: [ 5239.588419] af9015_rc_query: 07 00 25 00 00 00 00 00
Sep 21 21:15:54 moon kernel: [ 5240.500328] af9015_rc_query: 07 00 26 00 00 00 00 00
Sep 21 21:15:55 moon kernel: [ 5241.564350] af9015_rc_query: 07 00 50 00 00 00 00 00
Sep 21 21:15:57 moon kernel: [ 5243.084450] af9015_rc_query: 07 00 05 00 00 00 00 00
Sep 21 21:15:58 moon kernel: [ 5244.604424] af9015_rc_query: 07 00 27 00 00 00 00 00
Sep 21 21:15:59 moon kernel: [ 5245.516335] af9015_rc_query: 07 00 08 00 00 00 00 00
Sep 21 21:16:01 moon kernel: [ 5247.188419] af9015_rc_query: 07 00 4f 00 00 00 00 00
Sep 21 21:16:03 moon kernel: [ 5249.012366] af9015_rc_query: 07 00 3f 00 00 00 00 00
Sep 21 21:16:04 moon kernel: [ 5250.532340] af9015_rc_query: 07 00 16 00 00 00 00 00
Sep 21 21:16:05 moon kernel: [ 5251.448378] af9015_rc_query: 07 00 2a 00 00 00 00 00
Sep 21 21:16:06 moon kernel: [ 5252.664872] af9015_rc_query: 07 00 3c 00 00 00 00 00
Sep 21 21:16:09 moon kernel: [ 5254.944405] af9015_rc_query: 07 00 18 00 00 00 00 00
Sep 21 21:16:10 moon kernel: [ 5256.616366] af9015_rc_query: 07 00 07 00 00 00 00 00
Sep 21 21:16:11 moon kernel: [ 5257.680885] af9015_rc_query: 07 00 0f 00 00 00 00 00
Sep 21 21:16:13 moon kernel: [ 5258.896393] af9015_rc_query: 07 00 15 00 00 00 00 00
Sep 21 21:16:14 moon kernel: [ 5260.720336] af9015_rc_query: 07 00 36 00 00 00 00 00
Sep 21 21:16:16 moon kernel: [ 5261.784858] af9015_rc_query: 07 00 37 00 00 00 00 00
Sep 21 21:16:17 moon kernel: [ 5262.848378] af9015_rc_query: 07 00 2d 00 00 00 00 00
Sep 21 21:16:17 moon kernel: [ 5263.608427] af9015_rc_query: 07 00 2e 00 00 00 00 00
