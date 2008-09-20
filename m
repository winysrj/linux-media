Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.j.buxton@gmail.com>) id 1Kh7Ye-0004aM-9T
	for linux-dvb@linuxtv.org; Sat, 20 Sep 2008 20:51:54 +0200
Received: by fg-out-1718.google.com with SMTP id e21so946454fga.25
	for <linux-dvb@linuxtv.org>; Sat, 20 Sep 2008 11:51:48 -0700 (PDT)
Message-ID: <3d374d00809201151w543e17cdm4ca67e5940667f2b@mail.gmail.com>
Date: Sat, 20 Sep 2008 19:51:48 +0100
From: "Alistair Buxton" <a.j.buxton@gmail.com>
To: "Michael Sanders" <msanders@fenza.com>
In-Reply-To: <5926395e0809200414m186da966g62b4f0f975b46633@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <5926395e0809182212k1454836dq1585f56048ae5404@mail.gmail.com>
	<3d374d00809190659r123651ffwec3a326367e248e7@mail.gmail.com>
	<5926395e0809200414m186da966g62b4f0f975b46633@mail.gmail.com>
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

2008/9/20 Michael Sanders <msanders@fenza.com>:

> Thanks for you ideas. I have attached the full dmesg as suggested.
>
> I don't think the problem is a cold/warm state issue. When I used the
> device for the first time, I saw a warning that it (correct name was
> given) was it its cold state and that firmware was not found. Adding
> the firmware fixed the problem and then it worked fine. i.e. in the
> cold state, it did not show the EZ-USB id.

That's odd. However, there is no difference between cold state and the
current state. EZ-USB devices usually have a very small I2C eeprom
which holds nothing except for the device IDs. It looks like that chip
has either been wiped or has blown.

You should still be able to force the firmware loading, after which it
should go into warm state as normal. There are two ways you could do
that. There is a tool called "fxload" which can load the firmware, but
it uses a different format to the kernel drivers for the firmware
file. It needs intel hex format (ihx). You could alternatively add the
EZ-USB development ID to the list of IDs for the kernel driver.

Unfortunately neither of those methods will be a permanent fix. You
will need to reprogram the I2C eeprom with the correct USB IDs in
order to do that. That can be done with fxload and a special firmware
or there is a tool available from Cypress which can do it - although
it is Windows only.

To the list: Does anyone know how to convert the *.fw files into ihx
format for use with fxload?

-- 
Alistair Buxton
a.j.buxton@gmail.com

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
