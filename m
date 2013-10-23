Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50358 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab3JWXC5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Oct 2013 19:02:57 -0400
Received: from [192.168.1.56] ([84.26.254.29]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0Mb7lL-1VG5Qa34UF-00KkpK for
 <linux-media@vger.kernel.org>; Thu, 24 Oct 2013 01:02:55 +0200
Message-ID: <526855DC.6010909@gmx.net>
Date: Thu, 24 Oct 2013 01:03:56 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: EM28xx - MSI Digivox Trio - almost working.
References: <51C28FA2.70004@gmx.net> <5202E82E.50400@gmx.net>
In-Reply-To: <5202E82E.50400@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2013 02:37 AM, P. van Gaans wrote:
> On 20-06-13 07:14, P. van Gaans wrote:
>> Hi all,
>>
>> (device: http://linuxtv.org/wiki/index.php/MSI_DigiVox_Trio)
>>
>> Thanks to the message from Philip Pemberton I was able to try loading
>> the em28xx driver myself using:
>>
>> sudo modprobe em28xx card=NUMBER
>> echo eb1a 2885 | sudo tee /sys/bus/usb/drivers/em28xx/new_id
>>
>> Here are the results for NUMBER:
>>
>> Card=79 (Terratec Cinergy H5): works, less corruption than card=87, just
>> some blocks every few seconds. Attenuators didn't help.
>> Card=81 (Hauppauge WinTV HVR 930C): doesn't work, no /dev/dvb adapter
>> Card=82 (Terratec Cinergy HTC Stick): similar to card=87
>> Card=85 (PCTV QuatroStick (510e)): constantly producing i2c read errors,
>> doesn't work
>> Card=86 (PCTV QuatroStick nano (520e): same
>> Card=87 (Terratec Cinergy HTC USB XS): stick works and scans channels,
>> but reception is bugged with corruption. It's like having a DVB-T
>> antenna that's just not good enough, except this is DVB-C and my signal
>> is excellent. Attenuators didn't help.
>> Card=88 (C3 Tech Digital Duo HDTV/SDTV USB): doesn't work, no /dev/dvb
>> adapter
>>
>> So with card=79 it's really close to working. What else can I do?
>>
>> Best regareds,
>>
>> P. van Gaans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Hi all,
>
> Success!
>
> While I never succeeded in figuring out how the sniffing is supposed to
> be done (how to get any output from those scripts anyway? how to load
> the debug module in such away it actually works? run on native linux, or
> a windows VM on linux, or snoop in windows en run the script on linux?
> you get the picture) I just noticed a little notice on the DVB-C USB
> wiki page:
>
> "If you are experiencing problems with USB devices, it may not be the
> fault of the tuner. For example AMD 700 series chipsets (e.g. 780G) have
> a problem with USB ports which results in tuners working or partially
> working or not working at all."
>
> I was actually not even testing on an AMD 700 series but on an AMD 600
> series. And a somewhat older kernel, with latest v4l-dvb compiled.
>
> So here's what I did: I took the Digivox Trio, plugged it in an Ivy
> Bridgy computer with Lubuntu 13.04 (stock kernel, stock v4l-dvb, Lubuntu
> appears to come with the firmware preloaded), load the em28xx driver as
> if the Digivox were a Terratec H5 and watched 5 minutes or so, flawless.
>
> I will continue to test and watch some longer programs, but right now it
> appears it is safe to say the Digivox Trio can be supported by simply
> treating as an H5.
>
> Best regards,
>
> P. van Gaans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

It's been a while I've been using this setup and I haven't found any 
obvious flaws.

I've added this to my own linux/drivers/media/usb/em28xx/em28xx-cards.c:

	{ USB_DEVICE(0xeb1a, 0x2885),	/* MSI Digivox Trio */
			.driver_info = EM2884_BOARD_TERRATEC_H5 },

So it would load automatically. I've been using two of these with tvheadend.

So can this device be added? Any more info needed?

Best regards,

P. van Gaans
