Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:42354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab0AKTYb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 14:24:31 -0500
Received: by fg-out-1718.google.com with SMTP id 19so9033121fgg.1
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 11:24:29 -0800 (PST)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: WinTV Radio rev-c121 remote support
References: <d49708701001051211r447f6293g59dfac2b1af2818c@mail.gmail.com>
 <op.u57s00mk6dn9rq@crni.lan>
Date: Mon, 11 Jan 2010 20:24:51 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Samuel Rakitnican" <samuel.rakitnican@gmail.com>
Message-ID: <op.u6duvn0i6dn9rq@crni.lan>
In-Reply-To: <op.u57s00mk6dn9rq@crni.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 08 Jan 2010 13:59:14 +0100, Samuel Rakitnican  
<samuel.rakitnican@gmail.com> wrote:

> On Tue, 05 Jan 2010 21:11:59 +0100, Samuel Rakitnièan  
> <samuel.rakitnican@gmail.com> wrote:
>
>> Hi,
>>
>> I have an old bt878 based analog card. It's 'Hauppauge WinTV Radio'  
>> model 44914,
>> rev C121.
>>
>> I'm trying to workout support for this shipped remote control. I have

  [...]

>> Card: http://linuxtv.org/wiki/index.php/File:Wintv-radio-C121.jpg
>> Remote: http://linuxtv.org/wiki/index.php/File:Wintv-radio-remote.jpg
>
>
> Did some investigation, maybe this can help to clarify some things.  
> Still didn't get any response in dmesg from remote.

  [...]

> i2c_scan:
> bttv0: i2c scan: found device @ 0x30  [IR (hauppauge)]
> bttv0: i2c scan: found device @ 0xa0  [eeprom]
> bttv0: i2c scan: found device @ 0xc2  [tuner (analog)]

  [...]

> modprobe ir-kbd-i2c debug=1
> ir-kbd-i2c: probe 0x1a @ bt878 #0 [sw]: no
> ir-kbd-i2c: probe 0x18 @ bt878 #0 [sw]: yes

  [...]


OK, patch http://patchwork.kernel.org/patch/70126/ did the trick for  
kernel oops and segfault. However there is still something wrong in the  
filtering code for hauppauge remotes that prevents my remote codes for  
passing through:

drivers/media/video/ir-kbd-i2c.c

  99 	/*
100 	 * Hauppauge remotes (black/silver) always use
101 	 * specific device ids. If we do not filter the
102 	 * device ids then messages destined for devices
103 	 * such as TVs (id=0) will get through causing
104 	 * mis-fired events.
105 	 *
106 	 * We also filter out invalid key presses which
107 	 * produce annoying debug log entries.
108 	 */
109 	ircode= (start << 12) | (toggle << 11) | (dev << 6) | code;
110 	if ((ircode & 0x1fff)==0x1fff)
111 		/* invalid key press */
112 		return 0;
113
114 	if (dev!=0x1e && dev!=0x1f)
115 		/* not a hauppauge remote */
116 		return 0;
117
118 	if (!range)
119 		code += 64;


When I comment in this part: if (dev!=0x1e && dev!=0x1f), my remote works  
with a hauppage=1 parameter, althought a few buttons are not mapped  
correctly.

dmesg example with an empty table (buttons CH+ and CH-):
: unknown key: key=0x20 down=1
: unknown key for scancode 0x0020
: unknown key: key=0x20 down=0
: unknown key for scancode 0x0021
: unknown key: key=0x21 down=1
: unknown key for scancode 0x0021
: unknown key: key=0x21 down=0


Can someone please take a look at this and perhaps fix the code. Thanks in  
advance.


Regards,
Samuel
