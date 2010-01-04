Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.re3.yahoo.com ([66.196.96.89]:45180 "HELO
	smtp116.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751419Ab0ADLfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 06:35:15 -0500
Message-ID: <4B41D271.4090605@bellsouth.net>
Date: Mon, 04 Jan 2010 06:35:13 -0500
From: Bill Whiting <textux@bellsouth.net>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Lenovo compact webcam 17ef:4802
References: <4B413B99.3020604@bellsouth.net> <20100104101927.087aa290@tele>
In-Reply-To: <20100104101927.087aa290@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The gspca module is provided as part of the kernel.  The kernel version 
is 2.6.30-10
The libv4l version is 0.6.3-1

Is there a way that I can display the version of gspca?  I looked in 
dmesg and /var/log/messages but didn't find a version listed.

I think cheese may be using gstreamer.  How can I confirm whether cheese 
or skype are using v4l?

//Bill

On 01/04/2010 04:19 AM, Jean-Francois Moine wrote:
> On Sun, 03 Jan 2010 19:51:37 -0500
> Bill Whiting<textux@bellsouth.net>  wrote:
>
>    
>> I have not been able to get an image from a Lenovo webcam under
>> Fedora 11. It reports to the kernel with USB id 17ef:4802 as below:
>>
>>    kernel: usb 1-3: new high speed USB device using ehci_hcd and
>> address 9 kernel: usb 1-3: New USB device found, idVendor=17ef,
>> idProduct=4802 kernel: usb 1-3: New USB device strings: Mfr=1,
>> Product=2, SerialNumber=0 kernel: usb 1-3: Product: Lenovo USB Webcam
>>    kernel: usb 1-3: Manufacturer: Primax
>>    kernel: usb 1-3: configuration #1 chosen from 1 choice
>>    kernel: gspca: probing 17ef:4802
>>    kernel: vc032x: check sensor header 20
>>    kernel: vc032x: Sensor ID 143a (3)
>>    kernel: vc032x: Find Sensor MI1310_SOC
>>    kernel: gspca: probe ok
>>      
> 	[snip]
>
> Hello Bill,
>
> I don't know which version of gspca is included in your kernel.
> First, do you use the v4l library when running cheese or skype?
> Then, may you get the last video stuff from LinuxTv.org and check if it
> works?
>
> Regards.
>
>    

