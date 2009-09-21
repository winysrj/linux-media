Return-path: <linux-media-owner@vger.kernel.org>
Received: from m3.goneo.de ([82.100.220.82]:59581 "EHLO m3.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbZIUObY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 10:31:24 -0400
From: Roman <lists@hasnoname.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: MSI Digivox mini III Remote Control
Date: Mon, 21 Sep 2009 16:31:19 +0200
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909202026.27086.lists@hasnoname.de> <200909211610.52856.lists@hasnoname.de> <4AB78B79.3030203@iki.fi>
In-Reply-To: <4AB78B79.3030203@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909211631.19838.lists@hasnoname.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Am Monday 21 September 2009 16:19:37 schrieb Antti Palosaari:
> > Here is the output of dmesg after reloading the module:
> > #--
> > af9015_usb_probe: interface:0
> > af9015_read_config: IR mode:4
>
> IR mode 4 disables it. I have strong feeling it should mean "polling"...
> Could you change af9015.c around line 720:
> from: if (val == AF9015_IR_MODE_DISABLED || val == 0x04) {
> to: if (val == AF9015_IR_MODE_DISABLED) {
>
> and test again.
> Antti

Ahh progress... ;)
I did as you suggested, now dmesg shows the IR-device:
#--
Sep 21 16:25:50 Seth input: IR-receiver inside an USB DVB receiver 
as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/input/input7
Sep 21 16:25:50 Seth dvb-usb: schedule remote query interval to 150 msecs
#--

And syslog shows requests like the following:
#--
Sep 21 16:26:33 Seth af9015_rc_query: 07 00 27 00 00 00 00 00
#--

If it is ok, i will mail the output to you (and not spam the ml), later this 
day or tomorrow morning, as i have to leave for the university now...


greetings,
Roman
-- 
Troubled day for virgins over 16 who are beautiful and wealthy and live
in eucalyptus trees.
