Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm28-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.22]:36186 "EHLO
	nm28-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172Ab3EST7x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 May 2013 15:59:53 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com>
Message-ID: <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com>
Date: Sun, 19 May 2013 12:59:51 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
To: =?iso-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <51990B63.5090402@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----

> Hmm... that's weird. Are you sure about that ? Is this really a 3.9.2 vanilla kernel ?

Quite sure, although it turns out that there's a bit more to it. Here is the dmesg output with my debugging messages in:

[ 6263.496794] em28174 #0: Calling em28xx_ir_change_protocol...
[ 6263.533332] em28174 #0: Calling em2874_ir_change_protocol...(type=1)
[ 6263.576099] Registered IR keymap rc-pinnacle-pctv-hd
[ 6263.607181] input: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.7/usb10/10-4/rc/rc6/input22
[ 6263.608329] ir-keytable[30882]: segfault at 0 ip 0000000000401cc0 sp 00007fff7ca22dd0 error 4 in ir-keytable[400000+8000]
[ 6263.756019] rc6: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.7/usb10/10-4/rc/rc6
[ 6263.816551] em28174 #0: Calling em28xx_ir_change_protocol...
[ 6263.853024] em28174 #0: Calling em2874_ir_change_protocol...(type=8)
[ 6263.895796] Em28xx: Initialized (Em28xx Input Extension) extension

This is the state after I have loaded my em28xx_rc modue. But then I need to call ir-keytable:

# ir-keytable -a /etc/rc_maps.cfg -s rc6

[ 6284.491992] em28174 #0: Calling em28xx_ir_change_protocol...
[ 6284.528492] em28174 #0: Calling em2874_ir_change_protocol...(type=1)

And this seems to reset the protocol back to "unknown". (But I need to use this other remote control to use VDR - the PCTV one just doesn't have enough buttons).

Cheers,
Chris

