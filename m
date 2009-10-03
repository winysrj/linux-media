Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:64531 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbZJCSQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 14:16:19 -0400
Date: Sat, 3 Oct 2009 20:15:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20091003201527.110b69e3@hyperion.delvare>
In-Reply-To: <200910031730.45021.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
	<200910031208.36524.pluto@agmk.net>
	<20091003140447.6486ed82@hyperion.delvare>
	<200910031730.45021.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Please keep the list Cc'd.

On Sat, 3 Oct 2009 17:30:44 +0200, Paweł Sikora wrote:
> On Saturday 03 October 2009 14:04:47 you wrote:
> > OK. So the bug is exactly what I said on my very first reply. And the
> > patch I pointed you to back then should have fixed it:
> > http://patchwork.kernel.org/patch/45707/
> > You said it didn't, which makes me wonder if you really tested it
> > properly...
> 
> hmm, it's possible that i've ran system with wrong initrd
> and it had loaded unpatched /lib/modules/$build.
> i've tested patch 45707 today and it works, so my fault.
> 
> moreover, with this patch i'm observing a flood in dmesg:
> 
> [  938.313245] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
> [  938.419914] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
> [  939.273249] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
> [  939.379955] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0

Different issue, and I don't know much about IR support, but these keys
aren't listed in ir_codes_pinnacle_color. Maybe you have a different
variant of this remote control with more keys and we need to add their
definitions. Which keys are triggering these messages?

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
