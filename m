Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63372 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0AYUFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 15:05:24 -0500
Received: by ewy19 with SMTP id 19so142983ewy.21
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 12:05:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381001220827x243ae52cx44a8fa7b627c7184@mail.gmail.com>
References: <135ab3ff1001200926j9917d69x51eede94512fa664@mail.gmail.com>
	 <829197381001201000x58aadea5wab0948691d9a4c4f@mail.gmail.com>
	 <135ab3ff1001210155qad2c794rf6781c4ac28159c7@mail.gmail.com>
	 <d9def9db1001210407s6f14d637x1e32d34f7193a188@mail.gmail.com>
	 <4B587B91.9070300@koala.ie>
	 <135ab3ff1001220818r3e10650fl80e873c441bffde4@mail.gmail.com>
	 <829197381001220827x243ae52cx44a8fa7b627c7184@mail.gmail.com>
Date: Mon, 25 Jan 2010 21:05:06 +0100
Message-ID: <135ab3ff1001251205g3c699130r25c93ec1cadfc820@mail.gmail.com>
Subject: Re: Drivers for Eyetv hybrid
From: Morten Friesgaard <friesgaard@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Simon Kenyon <simon@koala.ie>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sound like a lot of work, and it would be easier just to buy a
functional tuner :)

Guess I'm busy enough. However, I did manage to find some more info,
for someone to use someday :)
/Morten

Model: EU 2008
USB Contoller: Empia EM2884
Stereo A/V Decoder: Micronas AVF 49x08
Hybrid Channel Decoder: Micronas DRX-K DRX3926K:A1 0.9.0

On Fri, Jan 22, 2010 at 5:27 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Fri, Jan 22, 2010 at 11:18 AM, Morten Friesgaard
> <friesgaard@gmail.com> wrote:
>> Actually I don't understand why this em28xx driver is the only one
>> being patched, guess that reduces backward compability!? :-P
>
> There are many drivers actively being developed.  What I'm trying to
> say is that the new version of the EyeTV Hybrid is not an em28xx based
> hardware design.
>
>> Well, I haven't given up, but no one has given me any pointers but /dev/null
>> If this em28xx module would be startable with the usb id "0fd9:0018",
>> I could tryout the old driver.
>> If you say the hardware design is completely different, I guess it
>> should still be possible to mount the usb device and fetch anything
>> from the device (e.g. tvtime -d /dev/usbdev). The driver would be a
>> matter of controlling the device to tune to the correct channel etc.
>
> No, that is not how USB drivers work.  You have to know how to program
> the various chips on the device (the bridge, demodulator, decoder,
> tuner), as well as knowing how to decode the packets coming back from
> the device.  If you want to get an understanding as to how complex the
> drivers are then feel free to look at some of them in the v4l-dvb
> source code.  You can get a better understanding as to how these
> devices are designed here:
>
> KernelLabs Blog:  How Tuners Work...
> http://www.kernellabs.com/blog/?p=1045
>
>> When new hardware is introduced, how do you guys break down the task
>> and implement a driver? (how much can be borrow from the mac os x
>> drivers?)
>
> It largely depends on the device.  Usually you start by cracking it
> open and seeing what chips it contains, and from there you can see
> which components currently have a driver and which do not.  Whether
> the various components are already supported usually drives whether a
> whole new driver is required or just a board profile in an existing
> driver.  And whether datasheets are available publicly dictates how
> easy/hard it is to write a driver (the datasheets are usually *not*
> available for modern devices, or only available under NDA).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
