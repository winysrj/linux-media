Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <msanders@fenza.com>) id 1KhKRJ-0002Pb-GV
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 10:37:11 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1061287fga.25
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 01:37:05 -0700 (PDT)
Message-ID: <5926395e0809210137y7a89a887xa7ca54218d09b1e@mail.gmail.com>
Date: Sun, 21 Sep 2008 18:07:05 +0930
From: Michael <m72@fenza.com>
To: "Alistair Buxton" <a.j.buxton@gmail.com>
In-Reply-To: <3d374d00809201151w543e17cdm4ca67e5940667f2b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <5926395e0809182212k1454836dq1585f56048ae5404@mail.gmail.com>
	<3d374d00809190659r123651ffwec3a326367e248e7@mail.gmail.com>
	<5926395e0809200414m186da966g62b4f0f975b46633@mail.gmail.com>
	<3d374d00809201151w543e17cdm4ca67e5940667f2b@mail.gmail.com>
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

On Sun, Sep 21, 2008 at 4:21 AM, Alistair Buxton <a.j.buxton@gmail.com> wrote:
> 2008/9/20 Michael Sanders <msanders@fenza.com>:
>
>> Thanks for you ideas. I have attached the full dmesg as suggested.
>>
>> I don't think the problem is a cold/warm state issue. When I used the
>> device for the first time, I saw a warning that it (correct name was
>> given) was it its cold state and that firmware was not found. Adding
>> the firmware fixed the problem and then it worked fine. i.e. in the
>> cold state, it did not show the EZ-USB id.
>
> That's odd. However, there is no difference between cold state and the
> current state. EZ-USB devices usually have a very small I2C eeprom
> which holds nothing except for the device IDs. It looks like that chip
> has either been wiped or has blown.
>
> You should still be able to force the firmware loading, after which it
> should go into warm state as normal. There are two ways you could do
> that. There is a tool called "fxload" which can load the firmware, but
> it uses a different format to the kernel drivers for the firmware
> file. It needs intel hex format (ihx). You could alternatively add the
> EZ-USB development ID to the list of IDs for the kernel driver.

Thats very encouraging - sounds like there is hope to fix it. I did
some googling and concluded that the cold ID for my device should be
eb2a:17de and that the kernel module that it requires is
"dvb-usb-dibusb-mb". At the moment, the generic 04b4:8613 seems to
load the "usbtest" module - how do I force it to load
dvb-usb-dibusb-mb instead? At least then I can confirm the matter is
worth pursuing.

> Unfortunately neither of those methods will be a permanent fix. You
> will need to reprogram the I2C eeprom with the correct USB IDs in
> order to do that. That can be done with fxload and a special firmware
> or there is a tool available from Cypress which can do it - although
> it is Windows only.

So I looked that this path too and downloaded the SuiteUSB 1.0 - USB
Development tools for Visual C++ 6.0 from
http://www.cypress.com/design/RD1076. That had a utility called
CyConsole. That recognised that Cypress a USB device was plugged in
and allows data be be manually changed, but unfortunately the
documentation is written for people who have a better understanding of
these things than me. There wasn't any obvious way just enter new
vendor and product IDs. I looked through the datasheet of the
cy7c68013 (http://download.cypress.com.edgesuite.net/design_resources/datasheets/contents/cy7c68013_8.pdf),
but didn't see anything obvious. Anyone out there able/willing to give
me some instructions on how to use the cypress tool to do that?

On my linux machine, I installed fxload, but that also didn't provide
any obvious way to change the IDs (I guess it only for loading the
firmware)

Thanks for all the help so far.

- Michael

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
