Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1L101A-0004mF-9I
	for linux-dvb@linuxtv.org; Fri, 14 Nov 2008 15:51:29 +0100
Received: by ey-out-2122.google.com with SMTP id 25so577451eya.17
	for <linux-dvb@linuxtv.org>; Fri, 14 Nov 2008 06:51:24 -0800 (PST)
Message-ID: <37219a840811140651l8bbe3cay6878a06bee3330aa@mail.gmail.com>
Date: Fri, 14 Nov 2008 09:51:24 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "William Melgaard" <piobair@mindspring.com>
In-Reply-To: <25596270.1226673543483.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <25596270.1226673543483.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] FusionHDTV7 RT Gold
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

On Fri, Nov 14, 2008 at 9:39 AM, William Melgaard
<piobair@mindspring.com> wrote:
> -----Original Message-----
>>From: Michael Krufky <mkrufky@linuxtv.org>
>>Sent: Nov 13, 2008 6:24 PM
>>To: CityK <cityk@rogers.com>
>>Cc: linux-dvb@linuxtv.org
>>Subject: Re: [linux-dvb] FusionHDTV7 RT Gold
>>
>>On Thu, Nov 13, 2008 at 6:20 PM, CityK <cityk@rogers.com> wrote:
>>> Michael Krufky wrote:
>>>> On Tue, Nov 11, 2008 at 9:24 PM, CityK <cityk@rogers.com> wrote:
>>>>
>>>> I added analog support for this card on Feb 25 of this year.  Digital
>>>> support was merged shortly thereafter.
>>>>
>>>> ...  If you check your
>>>> kernel logs, it is more than likely that this will be mentioned there.
>>>
>>> Ahh, very good.  Didn't see anything on the kernel submit logs, but did
>>> indeed find both of the above mentioned on the maintainer list
>>>
>>
>>You misquoted me.
>>
>>I was talking about the firmware problem.......
>>
>>"Most likely, you are simply missing the firmware.  If you check your
>>kernel logs, it is more than likely that this will be mentioned there."
>>
>>-Mike
>>
>>_______________________________________________
>>linux-dvb mailing list
>>linux-dvb@linuxtv.org
>>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> I downloaded the firmware file & extracted it.
> There was no folder "/lib/firmware/2.6.18-6-amd64", so I created one.
> I copied the extracted firmware file into both /lib/firmware and /lib/firmware/2.6.18-6-amd64
> The tuner is not recognized:
> Nov 14 09:22:58 localhost kernel: cx2388x v4l2 driver version 0.0.6 loaded
> Nov 14 09:22:58 localhost kernel: ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 9
> Nov 14 09:22:58 localhost kernel: ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKB] -> GSI 9 (level, low) -> IRQ 9
> Nov 14 09:22:58 localhost kernel: cx88[0]: Your board isn't known (yet) to the driver.  You can
> Nov 14 09:22:58 localhost kernel: cx88[0]: try to pick one of the existing card configs via
> Nov 14 09:22:58 localhost kernel: cx88[0]: card=<n> insmod option.  Updating to the latest
> Nov 14 09:22:58 localhost kernel: cx88[0]: version might help as well.
> Nov 14 09:22:58 localhost kernel: cx88[0]: Here is a list of valid choices for the card=<n> insmod option:
> Nov 14 09:22:58 localhost kernel: cx88[0]:    card=0 -> UNKNOWN/GENERIC
[...]
> Nov 14 09:22:58 localhost kernel: cx88[0]:    card=52 -> Geniatech DVB-S
> Nov 14 09:22:58 localhost kernel: CORE cx88[0]: subsystem: 18ac:d610, board: UNKNOWN/GENERIC [card=0,autodetected]
> Nov 14 09:22:58 localhost kernel: TV tuner -1 at 0x1fe, Radio tuner -1 at 0x1fe
> Nov 14 09:22:58 localhost kernel: cx2388x alsa driver version 0.0.6 loaded
> Nov 14 09:22:58 localhost kernel: cx2388x dvb driver version 0.0.6 loaded
> Nov 14 09:22:58 localhost kernel: cx88[0]/0: found at 0000:02:07.0, rev: 5, irq: 9, latency: 64, mmio: 0xfb000000
> Nov 14 09:22:58 localhost kernel: ts: Compaq touchscreen protocol output
> Nov 14 09:22:58 localhost kernel: tuner 2-006b: chip found @ 0xd6 (cx88[0])
> Nov 14 09:22:58 localhost kernel: tuner 2-006f: chip found @ 0xde (cx88[0])
> Nov 14 09:22:58 localhost kernel: cx88[0]/0: registered device video0 [v4l2]
> Nov 14 09:22:58 localhost kernel: cx88[0]/0: registered device vbi0
> Nov 14 09:22:58 localhost kernel: tuner 2-006b: tuner type not set
> Nov 14 09:22:58 localhost kernel: ACPI: PCI Interrupt 0000:02:07.1[A] -> Link [LNKB] -> GSI 9 (level, low) -> IRQ 9
> Nov 14 09:22:58 localhost kernel: cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
> Nov 14 09:22:58 localhost kernel: ACPI: PCI Interrupt Link [LAUI] enabled at IRQ 11
> Nov 14 09:22:58 localhost kernel: ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LAUI] -> GSI 11 (level, low) -> IRQ 11
> Nov 14 09:22:58 localhost kernel: PCI: Setting latency timer of device 0000:00:06.0 to 64
> Nov 14 09:22:58 localhost kernel: cx2388x blackbird driver version 0.0.6 loaded

Upgrade to the newer modules on linuxtv.org.

Follow the instructions here:

http://linuxtv.org/repo

...and please don't drop cc to the mailing list -- I usually ignore
private tech-support emails.


-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
