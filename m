Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:49884 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbZH3X6B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 19:58:01 -0400
Received: by ewy2 with SMTP id 2so3578220ewy.17
        for <linux-media@vger.kernel.org>; Sun, 30 Aug 2009 16:58:02 -0700 (PDT)
Message-ID: <4A9B1203.8000709@gmail.com>
Date: Mon, 31 Aug 2009 05:27:55 +0530
From: Sudipto Sarkar <xtremethegreat1@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: HP VGA Cam.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 30 Aug 2009 17:16:56 +0530
> Sudipto Sarkar <xtremethegreat1@gmail.com> wrote:
>
>  
>> I'm trying to write a driver for the HP VGA camera. USB ID:
>> 15b8:6002. The sensor is 7131r, and the bridge is probably vc0323
>> (although the inf says it's vc0326). It's inf is the same inf which
>> includes the po1200 sensor, which was added in December last year
>> (The HP 2.0 Megapixel camera). I am trying to use usbsnoop in a
>> windows installation, but the log size just does not cease to come to
>> a halt (as is specified in the microdia site), thereby leaving me
>> unable to snoop the init sequence. What might be wrong?
>>
>> Also, is this the same sensor as hv7131r, as in vc032x.c?
>>     
>
> Hello Sudipto,
>
> Did you try the last gspca v2 from my test repository? As there is a
> probe sequence in the vc032x subdriver, the kernel log should contain
> the sensor name. What is it? If you cannot get images, may you tell me
> what is wrong? (does 'svv' display some image? does 'svv -rg' create a
> raw image? what are the last kernel messages? ...)
>
> Best regards.
>
>   
The kernel doesn't identify the video device at all. It however 
identifies the mic in it. I get the following for this from dmesg:

[  930.236048] usb 1-3: new high speed USB device using ehci_hcd and 
address 2
[  930.468474] usb 1-3: configuration #1 chosen from 1 choice
[  932.135471] usbcore: registered new interface driver snd-usb-audio


And of course there is no video device, so svv says:

Cannot identify '/dev/video0': 2, No such file or directory

However, I had edited the huge matrices (which I suppose are the URBs) 
for hv7131r and replaced that with the one written in the inf file. That 
works, but the brightness is very low, so that the camera works only 
when pointed to the bulb. Should I try that one with svv? btw, I used 
cheese to test the driver, that I'd made then.

