Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38184 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1D0S2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 14:28:38 -0400
Received: by wwa36 with SMTP id 36so2205880wwa.1
        for <linux-media@vger.kernel.org>; Wed, 27 Apr 2011 11:28:37 -0700 (PDT)
References: <20110423005412.12978e29@darkstar> <20110424163530.2bc1b365@darkstar> <BCCEA9F4-16D7-4E63-B32C-15217AA094F3@wilsonet.com> <20110425201835.0fbb84ee@darkstar> <A4226E90-09BE-45FE-AEEF-0EA7E9414B4B@wilsonet.com> <20110425230658.22551665@darkstar> <59898A0D-573E-46E9-A3B7-9054B24E69DF@wilsonet.com> <20110427151621.5ac73e12@darkstar>
In-Reply-To: <20110427151621.5ac73e12@darkstar>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <1FB1ED64-0EEC-4E15-8178-D2CCCA915B1D@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: "mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Date: Wed, 27 Apr 2011 14:28:41 -0400
To: Heiko Baums <lists@baums-on-web.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moving this over to linux-media, this stuff is all rc-core and is
more of what I meant should be discussed over here/there. :)

On Apr 27, 2011, at 9:16 AM, Heiko Baums wrote:

> Am Wed, 27 Apr 2011 00:28:40 -0400
> schrieb Jarod Wilson <jarod@wilsonet.com>:
> 
>> Setting it as the only active protocol decoder when starting lircd
>> makes sense when using the receiver via /dev/lircX. But its rather
>> odd to me that all protocols are disabled on boot.
> 
> I added a comment to the Arch Linux feature request.
> 
>> Okay, dug a bit more... The default map for the 1400 should be NEC
>> proto. I'd enable rc-core debugging (options rc-core debug=1) and it
>> looks like the cx88 IR interrupt handler should spew some relevant
>> interesting data. However, I'm definitely leaning towards this
>> discussion moving over to the linux-media list, as the issue is
>> somewhere in drivers/media/video/cx88/.
> 
> Added "options rc-core debug=1" to /etc/modprobe.d/modprobe.conf, but I
> doubt that this helped.
> 
> In /var/log/everything I have several times
> kernel: [  295.056825] ir_update_mapping: #0: Deleting scan 0x0010
> and once
> kernel: [  295.056830] ir_resize_table: Shrinking table to 256 bytes
> then again several times things like
> kernel: [  295.056985] ir_update_mapping: #0: New scan 0x1441 with key
> 0x0066
> then
> kernel: [  295.057203] ir_resize_table: Growing table to 512 bytes
> and then a lot of
> kernel: [  322.500764] ir_rc5_decode: RC5(x) decode failed at state 1
> (8361us pulse)
> kernel: [  322.500775] ir_rc6_decode: RC6 decode failed at state 0
> (9250us pulse)
> kernel: [  322.500782] ir_jvc_decode: JVC decode failed at state 0
> (9250us pulse)
> kernel: [  322.500789] ir_sony_decode: Sony decode failed at state 0
> (9250us pulse)
> 
> I can't tell you when and by which command these log entries have been
> created.
> 
> Or are the debug outputs saved somewhere else?

If your system log is configured to log debug messages, it should all be
in there...

> Btw., I didn't read exactly enough "... should be NEC proto ..." and
> set the ir-keytable to nec_terratec_cinergy_xs. With this ir-keytable
> ir-keytable -t spit out some scancodes, but not with every button and
> not always.

Hrm, ok, so *something* is resulting in scancodes... This is progress!
(I think...) :)


> This is one line of the ir-keytable -t output:
> 1303909988.799949: event MSC: scancode = 4eb02

With rc-core debugging, there ought to be a line in all that dmesg spew
that contains that scancode, which would also give us the protocol
decoder that came up with that scancode. Based on the default protocol
listed for your board and the length of the scancode, I'd guess that it
is NEC Extended, but it could also be RC-5X or maybe Sony...


> But I'm not the only one who has this issue with a cx88 device. So I
> guess there's most likely a bug somewhere in the related kernel modules.
> 
> See: https://bugs.archlinux.org/task/23894

Yep, seems there's something slightly amiss with the cx88 IR code in
2.6.38.x. Actually, trying the latest media_tree code probably would
not be a bad thing, just in case this is already resolved:

http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers


> I'll ask on the linux-media list.

This mail I'm replying to was what really what I think needed to go
there, not the one that started the thread. ;)

-- 
Jarod Wilson
jarod@wilsonet.com



