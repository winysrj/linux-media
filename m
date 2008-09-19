Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.j.buxton@gmail.com>) id 1KggW7-0002tR-TY
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 15:59:29 +0200
Received: by ug-out-1314.google.com with SMTP id 39so2444470ugf.16
	for <linux-dvb@linuxtv.org>; Fri, 19 Sep 2008 06:59:24 -0700 (PDT)
Message-ID: <3d374d00809190659r123651ffwec3a326367e248e7@mail.gmail.com>
Date: Fri, 19 Sep 2008 14:59:24 +0100
From: "Alistair Buxton" <a.j.buxton@gmail.com>
To: Michael <m72@fenza.com>
In-Reply-To: <5926395e0809182212k1454836dq1585f56048ae5404@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <5926395e0809182212k1454836dq1585f56048ae5404@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB USB receiver stopped reporting correct USB ID
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

2008/9/19 Michael <m72@fenza.com>:
> Hi,
>
> I have a Kworld USB DVB-T receiver that used to work on Mythbuntu 8.04. The
> driver loaded the firmware correctly (dvb-usb-adstech-usb2-02.fw) and
> everything worked OK.
>
> Suddenly, without me having made any config changes, it is not being found
> anymore, presumably because it is now reporting a USB ID of 04b4:8613
> [CY7C68013 EZ-USB FX2 USB 2.0 Development Kit].
>
> When it worked, it used to report an ID of 06e1:a334 [ADS Technologies,
> Inc]. I confirmed the same behavior is the same on another PC (also
> mythbuntu 8.04)
>
> I think it is not a linux driver problem - the device actually has a
> CY7C68013 in it, so I'm guessing it has somehow "lost" its factory
> configuration that tells it is should present an ID of 06e1:a334.
>
> Does this mean it is dead or is there some way to reinitialise it?

It is normal for sticks that require firmware loading to have two USB
IDs. The ID changes after the firmware is loaded and the stick goes
into warm mode. EZ-USB is the controller chip that the card is based
on. It looks like the firmware is no longer being loaded for some
reason. Did you do an automatic update of mythbuntu recently? This may
have updated your kernel in which case you might have to copy the
firmware into the firmware directory of the new kernel and/or rename
it and/or recompile and install dvb modules again if you installed
from source. Full dmesg output would be more informative...



-- 
Alistair Buxton
a.j.buxton@gmail.com

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
