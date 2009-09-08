Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44242 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZIHRbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 13:31:41 -0400
Received: by fxm17 with SMTP id 17so2814013fxm.37
        for <linux-media@vger.kernel.org>; Tue, 08 Sep 2009 10:31:43 -0700 (PDT)
Date: Tue, 08 Sep 2009 19:31:42 +0200
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
From: "Samuel Rakitnican" <samuel.rakitnican@gmail.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-2
MIME-Version: 1.0
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com>
 <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com>
 <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.uzx8a4nr6dn9rq@crni>
In-Reply-To: <4AA683BD.6070601@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 08 Sep 2009 18:18:05 +0200, Morvan Le Meut <mlemeut@gmail.com>  
wrote:

[...]

Since it doesn't work with thoses keycodes, i'm trying it with  
"ir_codes_adstech_dvb_t_pci". I'm sure it won't work ( it would be toot  
easy otherwise  ) but since the remote looks the same ...
If by chance it work, i'll try to better document what i did for someone  
to write a patch. ( Or at least, to serve as a reminder the next time i'll  
encounter the problem  )


Hi,

If gpio's are correct, than all you need to do is write a new keymap.

These is how I did it: If codes from original keymap are wrong erase the  
keycodes in ir-keymaps.c, but leave the header, pointer or whatever is  
called. In your case like that:

/* Sylvain Vignaud <sylvain@vignaud.org */
static IR_KEYTAB_TYPE AdsInstantTvPci_codes[IR_KEYTAB_SIZE] = {
	// Buttons are in the top to bottom physical order
	// Some buttons return the same raw code, so they are currently
	

};

   Compile/install/load the drivers. You should get something like these in  
dmesg:

dmesg example for a single button pressed (my card):
saa7134 IR (Compro Videomate DV: unknown key: key=0x29 raw=0x29 down=1
saa7134 IR (Compro Videomate DV: unknown key: key=0x29 raw=0x29 down=0

The keycode (0x29) must be unique for every button pressed, and this is  
what you write in ir-keymaps.c e.g.

	[0x29] = KEY_POWER,     /* power       */
	
There has been standardization of keys recently, so this is how things  
must be mapped now:
	(http://linuxtv.org/wiki/index.php/Remote_Controllers)

Read also:
	(http://linuxtv.org/wiki/index.php/Remote_controllers-V4L)

