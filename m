Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L7f41-0004Cn-DK
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 00:53:59 +0100
Received: by ug-out-1314.google.com with SMTP id x30so3174977ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 15:53:54 -0800 (PST)
Message-ID: <412bdbff0812021553n69f6d59aq2bd9182367e3b465@mail.gmail.com>
Date: Tue, 2 Dec 2008 18:53:54 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: cl@qgenuity.com
In-Reply-To: <427d6fd3d8cc5242de113141bc51aae6.squirrel@webmail.qgenuity.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <427d6fd3d8cc5242de113141bc51aae6.squirrel@webmail.qgenuity.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppage HVR-950 on Opensuse 10.3
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

On Tue, Dec 2, 2008 at 6:49 PM,  <cl@qgenuity.com> wrote:
> I recently tried to install an Hauppage HVR-950 on opensuse 10.3 the
> system is an AMD64 with kernel 2.6.22.19 using the v4l-dvb software.
>
> What I did:
>
> 1) Firmware:
> wget
> http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
>
> unzip HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys
> ./extract_xc3028.pl
> cp xc3028-v27.fw /lib/firmware
>
> (The firmware is there in the /lib/firmware directory)
>
> 2) Downloaded drivers with hg clone http://linuxtv.org/hg/v4l-dvb
>
> 3) make & make install in v4l-dvb directory
>
> 4) Plugged usb dongle into machine
>
> The result that I get is:
>
> au0828: disagrees about version of symbol tveeprom_read
> au0828: Unknown symbol tveeprom_read
> au0828: disagrees about version of symbol tveeprom_hauppauge_analog
> au0828: Unknown symbol tveeprom_hauppauge_analog
> au0828: disagrees about version of symbol tveeprom_read
> au0828: Unknown symbol tveeprom_read
> au0828: disagrees about version of symbol tveeprom_hauppauge_analog
> au0828: Unknown symbol tveeprom_hauppauge_analog
> au0828: disagrees about version of symbol tveeprom_read
> au0828: Unknown symbol tveeprom_read
> au0828: disagrees about version of symbol tveeprom_hauppauge_analog
> au0828: Unknown symbol tveeprom_hauppauge_analog
>
> no /dev/video0 device is created and it looks as if the hardware is not
> installed. What am I doing wrong?
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

First off, this is a HVR-950Q not a HVR-950, so you don't need to
follow the 950's instructions.

The symbol errors are because of the mix of already running modules
and the modules you just installed by building the v4l-dvb codebase.
Just reboot your box.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
