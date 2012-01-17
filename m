Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-us.gmx.com ([74.208.5.67]:37879 "HELO
	mailout-us.mail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753336Ab2AQSqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 13:46:06 -0500
Content-Type: text/plain; charset="utf-8"
Date: Tue, 17 Jan 2012 13:46:03 -0500
From: "Dream HTPC" <dreamhtpc@gmx.com>
Message-ID: <20120117184603.71800@gmx.com>
MIME-Version: 1.0
Subject: Re: DM04 USB DVB-S TUNER
To: "Malcolm Priestley" <tvboxspy@gmail.com>,
	linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>On Sat, 2011-06-25 at 22:10 +0100, Malcolm Priestley wrote:
>> On Wed, 2011-06-08 at 16:20 +0100, Malcolm Priestley wrote:
>> > On Wed, 2011-06-08 at 14:18 +0300, Mehmet Altan Pire wrote:
>> > > 07-06-2011 22:34, Malcolm Priestley yazmis:
>> > > > On Tue, 2011-06-07 at 06:31 +0100, Malcolm Priestley wrote:
>> > > > > On Tue, 2011-06-07 at 02:28 +0300, Mehmet Altan Pire wrote:
>> > > > > > 06-06-2011 00:47, Malcolm Priestley yazmis:
>> > > > > > > On Sun, 2011-06-05 at 21:42 +0100, Malcolm Priestley wrote:
>> > > > > > > > On Sun, 2011-06-05 at 19:34 +0300, Mehmet Altan Pire wrote:
>> > > > > > > > > 05-06-2011 17:16, Malcolm Priestley yazmis:
>> > > > > > > > > > On Sun, 2011-06-05 at 03:35 +0300, Mehmet Altan Pire wrote:
>> > > > > > > > > > > Hi,
>> > > > > > > > > > > I have "DM04 USB DVBS TUNER", using ubuntu with v4l media-build
>> > > > > > > > > > > drivers/modules but device  doesn't working (unknown device).
>> > > > > > > > > > >
>> > > > > > > > > > > lsusb message:
>> > > > > > > > > > > ID 3344:22f0
>> > > > > > > > > > >
>> > > > > > > > > > > under of the box:
>> > > > > > > > > > > DM04P2011050176
>> > > > > > > > > Yes, i have windows xp driver, name is "US2B0D.sys" I sending it,
>> > > > > > > > > attached in this mail. Thanks.
>> > > > > > > > Here is a modified lmedm04.c and lme2510b_fw.sh using the US2B0D.sys
>> > > > > > > >
>> > > > > > to modify the interrupt return.
>> > > > > > Ok, i tested it. Device recognized on WinXP with original driver, but tv
>> > > > > > application says "no lock".
>> > > > > > I'm not sure it worked on WinXP but driver cd is original and
>> > > > > > succesfully loaded and recognized.
>> > > > > > Again tested on ubuntu with new lmedm04.c and lme2510b_fw.sh than make,
>> > > > > > make install, and restart.
>> > > > > >
>> > > > > > lsusb says:
>> > > > > > Bus 001 Device 008: ID 3344:1120  (changes 22f0 to 1120)
>> > > > > > dmesg says:
>> > > > > Yes this should happen. The firmware will reboot with the correct id.
>> > > > > > My device different or chip is damaged? Label, box and driver cd title
>> > > > > > writes "DM04P". DM04 and DM04P different devices?
>> > > > > I think the id of the chip is faulty or default.
>> > > > >
>> > > > > I will test the firmware with LG tuner later.
>> > > > It is not the LG, s7395 or S0194 tuner.
>> > > >
>> > > > So the id is intentional.
>> > > >
>> > > > How does it identify itself in windows?
>> > > >
>> > > >
>> > > > tvboxspy
>> > > >
>> > > 3. Tests
>> > >
>> > > :WinXP Test:
>> > >
>> > > I'm sure it worked on WinXP now. Tested with ProgDVB application.
>> > > Signal, channel search and watching tv as succesfully.
>> > > My Device working without problems on WinXP and it's not damaged.
>> > > When device running on stream, green led is active, if not running,
>> > > green led is passive (red led is power led and it's always active).
>> > > Driver Info: LME_PCTV_DVBS_RS2000 "VID3344 PID22F0" 22f0 this number
>> > > correct...
>> >
>> > I need to find out what exactly the RS2000 tuner is. So currently the
>> > linux driver is not supported with your device.
>>
>> A little update...
>>
>> I now have one of these devices. The chip is actually a M8BRS2000 which
>> is a combi frontend/tuner device.
>>
>> The ID is confirmed as 3344:22f0, it appears to be patched by the
>> Windows Driver as 3344:1120 devices try wrongly to use the RS2000
>> driver.
>>
>> There is no Linux frontend driver for this device. I will start to write
>> one shortly, so support could be several months away.
>>
>I have written the M8BRS2000 frontend, which has been on test for the
>last two weeks.
>
>Unfortunately, on Friday my device has partially failed, in that the
>m8brs2000 chip starts to fail with prolonged use.
>
>It seems to be an heat issue as cooling the device restores normal
>operation. I will do some more tests in a lab this week for dry-joints.
>
>Have you or anyone else noticed any similar problems running the device
>under Windows?
>
>This means the device driver for Linux is back on Alpha and cannot be
>released.
>
>Regards
>
>Malcolm
>

Hi Malcolm,

first of all, thanks for all your effort making Linux drivers available for the LME2510/LME2510C based devices. I also own one of those with the non-SHARP / non-LG tuner.

I did further digging and found that the chipset used for tuner/demodulation is actually named M88RS2000 (double "8" instead of 8B). I've confirmed that via several google searches as well as looking into my pcb with a magnifier (picture attached). It is manufactured by Montage Tech, with some product info in the links below (nothing too technical, unfortunately):
http://www.montage-tech.com/products_DTV.htm
http://www.montage-tech.com/Product_RS2000.html

I've sent them an email (infosk@montage-tech.com) asking for info that could help us on building a linux driver for their product. Haven't received any reply  yet.

So it seems such model of the DM04 is a combination LME2510C+M88RS2000.

I had mine running under windows for a day or so without failure due to heat. However I could let it run for longer if that would help with troubleshooting the issue you found with your driver. I also offer myself to alpha-test your linux driver in one of my mythtv linux boxes. Just let me know if that could help.

Thanks a lot!

Dream HTPC
