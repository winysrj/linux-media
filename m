Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1LaLSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:18:00 -0500
Received: by iaeh11 with SMTP id h11so26653414iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 03:17:59 -0800 (PST)
Message-ID: <4EFEEF65.6040703@gmail.com>
Date: Sat, 31 Dec 2011 05:17:57 -0600
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Dorozel Csaba <mrjuuzer@upcmail.hu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ir-kbd-i2c / rc-hauppauge / linux-3.x broken
References: <20111230120658.DXPH19694.viefep13-int.chello.at@edge04.upcmail.net> <4EFDF229.8090103@redhat.com> <20111231101532.GHMQ11861.viefep20-int.chello.at@edge04.upcmail.net> <4EFEECF4.3010709@redhat.com>
In-Reply-To: <4EFEECF4.3010709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/31/2011 05:07 AM, Mauro Carvalho Chehab wrote:
> On 31-12-2011 08:15, Dorozel Csaba wrote:
>>> Basically, the bridge driver is not sending the complete RC-5 
>>> keycode to the IR core, but just the 8 least siginificant
>>> bits. So, it is loosing the 0x1e00 code for the Hauppauge grey
>>> remote.
>>> 
>>> The fix should be at saa7134-input. It should be something
>>> like the enclosed patch (I'm just guessing there that code3
>>> contains the MSB bits - you may need to adjust it to match the
>>> IR decoder there):
>> 
>> I'm absolutly not a programer but an unhappy linux user who want
>> his working remote back. Know nothing about c code, MSB bits ...
>> After apply your fix looks what happening but remote is still
>> broken.
>> 
>> user juuzer # ir-keytable -t Testing events. Please, press CTRL-C
>> to abort. 1325324726.066129: event MSC: scancode = de3d 
>> 1325324726.066131: event sync 1325324726.169132: event MSC:
>> scancode = de3d 1325324726.169134: event sync 1325324727.508129:
>> event MSC: scancode = fe3d 1325324727.508131: event sync 
>> 1325324727.611132: event MSC: scancode = fe3d 1325324727.611134:
>> event sync 1325324730.084132: event MSC: scancode = de3d 
>> 1325324730.084134: event sync 1325324730.187132: event MSC:
>> scancode = de3d
>> 
>> It seems the code3 sometimes return with de (11011110) sometimes
>> fe (11111110). Is it possible to bitwise left 3 then bitwise
>> right 3 so the result in both case is 1e (00011110) ? Or its
>> totaly wrong ?
> 
> An RC-5 code is just 14 bits. I found some Hauppauge decoders
> returning just 12 bits on some places. It seems that all it needs
> is to do a code3 | 0x3f, in order to discard the two most
> significant bits (MSB).
> 
> So, the enclosed patch should fix the issues. Please test.
> 
> Regards, Mauro -
> 
> saa7134-input: Fix get_key_hvr1110() handling
> 
> Instead of returning just 8 bits, return the full RC-5 code
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/saa7134/saa7134-input.c
> b/drivers/media/video/saa7134/saa7134-input.c index
> d4ee24b..29c8efd 100644 ---
> a/drivers/media/video/saa7134/saa7134-input.c +++
> b/drivers/media/video/saa7134/saa7134-input.c @@ -249,8 +249,8 @@
> static int get_key_hvr1110(struct IR_i2c *ir, u32 *ir_key, u32
> *ir_raw) return 0;
> 
> /* return key */ -	*ir_key = code4; -	*ir_raw = code4; +	*ir_key =
> 0x3fff & (code4 | code3 << 8); +	*ir_raw = *ir_key; return 1; }
> 
> 
> Regards, Mauro
>> 
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Will this work regardless of what remote is being used?  Currently I'm
using a Windows Media Center Remote (Hauppauge HVR-1600 provided it)
with a combination of saa7134 (MSI TV@nywhere Plus) and Hauppauge
HVR-1600 tuners. Right now, the Hauppauge works fine (all of this is
in Mythtv 0.24), but the MSI crashes when I change channels.

Have a great day:)
Patrick.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7+72UACgkQMp6rvjb3CAR2tQCgqSAc55bQyDEe3Z4vu0sUYAne
RrQAoIU89vMVzI8UBH8v+dJxl3RsHj44
=3joI
-----END PGP SIGNATURE-----
