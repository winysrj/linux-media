Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43084 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaCBRxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 12:53:49 -0500
Received: by mail-ee0-f45.google.com with SMTP id d17so3464465eek.4
        for <linux-media@vger.kernel.org>; Sun, 02 Mar 2014 09:53:48 -0800 (PST)
Message-ID: <53137061.5060507@googlemail.com>
Date: Sun, 02 Mar 2014 18:54:41 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Keith Lawson <keith.lawson@libertas-tech.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Support for Empia 2980 video/audio capture chip set
References: <1ed89f5b0a32bf26e17cee890a26b012@www.nowhere.ca> <52D2C929.9080109@googlemail.com> <de907f83197624a31fc6690a43a21929@www.nowhere.ca> <52D6FFA8.8060008@googlemail.com> <20140117001102.GA18205@nowhere.ca> <52DD8239.6060001@googlemail.com> <20140206125719.GA10386@nowhere.ca> <530B83B3.3030906@googlemail.com> <20140227014723.GA8822@nowhere.ca>
In-Reply-To: <20140227014723.GA8822@nowhere.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 27.02.2014 02:47, schrieb Keith Lawson:
> On Mon, Feb 24, 2014 at 06:38:59PM +0100, Frank Sch�fer wrote:
>> Am 06.02.2014 13:57, schrieb Keith Lawson:
>>> On Mon, Jan 20, 2014 at 09:08:25PM +0100, Frank Sch�fer wrote:
>>>> On 17.01.2014 01:11, Keith Lawson wrote:
>>>>> On Wed, Jan 15, 2014 at 10:37:44PM +0100, Frank Sch�fer wrote:
>>>>>> Am 14.01.2014 01:48, schrieb Keith Lawson:
>>>>>>> On 2014-01-12 11:56, Frank Sch�fer wrote:
>>>>>>>
>>>>>>>> On 09.01.2014 02:02, Keith Lawson wrote:
>>>>>>>>
>>>>>>>>> Hello, I sent the following message to the linux-usb mailing list
>>>>>>>>> and they suggested I try here. I'm trying to get a "Dazzle Video
>>>>>>>>> Capture USB V1.0" video capture card working on a Linux device but
>>>>>>>>> it doesn't
>>>>>>>>> look like the chip set is supported yet. I believe this card is the
>>>>>>>>> next version of the Pinnacle VC100 capture card that worked with the
>>>>>>>>> em28xx kernel module. The hardware vendor that sold the card says that
>>>>>>>>> this device has an Empia 2980 chip set in it so I'm inquiring about
>>>>>>>>> support for that chip set. I'm just wondering about the best
>>>>>>>>> approach for getting the new chip supported in the kernel. Is this
>>>>>>>>> something the
>>>>>>>>> em28xx maintainers would naturally address in time or can I assist
>>>>>>>>> in getting this into the kernel? Here's dmesg from the Debian box
>>>>>>>>> I'm working on: [ 3198.920619] usb 3-1: new high-speed USB device
>>>>>>>>> number 5
>>>>>>>>> usingxhci_hcd [ 3198.939394] usb 3-1: New USB device found,
>>>>>>>>> idVendor=1b80,idProduct=e60a [ 3198.939399] usb 3-1: New USB device
>>>>>>>>> strings: Mfr=0, Product=1,SerialNumber=2 [ 3198.939403] usb 3-1:
>>>>>>>>> Product: Dazzle
>>>>>>>>> Video Capture USB Audio Device [ 3198.939405] usb 3-1: SerialNumber:
>>>>>>>>> 0 l440:~$ uname -a Linux l440 3.10-3-amd64 #1 SMP Debian 3.10.11-1
>>>>>>>>> (2013-09-10) x86_64 GNU/Linux If this isn't the appropriate list to ask
>>>>>>>>> this question please point me in the right direction. Thanks, Keith
>>>>>>>> The em28xx is indeed the dedicated driver for this device, but it's hard
>>>>>>>> to say how much work would be necessary to add support for it.
>>>>>>>> We currently don't support any em29xx chip yet, but in theory it is just
>>>>>>>> an extended em28xx device.
>>>>>>>> Whatever that means when it comes to the low level stuff... ;)
>>>>>>>>
>>>>>>> What's the best route to get support for this chip added then? Should
>>>>>>> I start working on a patch myself or will this just happen during the
>>>>>>> course of development of the em28xx module? I'm a developer but
>>>>>>> haven't done any kernel hacking so this would likely be a steep
>>>>>>> learning curve for me.
>>>>>> Can you create USB-Traces of the Windows driver and send us the output
>>>>>> of "lsusb -v -d 1b80:e60a" for this device ?
>>>>>> That will give us a hint how much work will be needed.
>>>>> For the USB-trace will the Win7 logman output do or is there a Win7 64-bit utility like usbsnoop I should use?
>>>> AFAIK the logman output doesn't contain any transferred data.
>>>> SniffUSB would be preferred, but AFAIK it doesn't work with Win 7.
>>>> You may also want to try USBPcap (http://desowin.org/usbpcap/), but
>>>> I don't know if it runs on the 64bit version of Win 7.
>>>> There are also various commercial USB-Sniffers and some of them are
>>>> providing a free trial period/version.
>>>> In any case we need a readable (text) sniffing output.
>>> Thanks for the pointer. I used USBPcap and exported text out of wireshark. 
>>>
>>> Here's the capture of connecting the device: 
>>>
>>> https://www.libertas-tech.com/dazzle_usb_connect.txt
>>>
>>> Here's a capture of the device recording a 1 minute video. This one is almost 700 meg so you probably don't want to try and open it in a browser: 
>>>
>>> https://www.libertas-tech.com/dazzle_recording_video.txt 
>>>
>>> I can arrange to get one of these devices in the hands of a developer if that would help too. 
>> Sorry for the delay, I'm currently burried under lots other stuff...
> No worries. I know that feeling all too well. 
>
>> I haven't finished evaluating these logs yet, but so far I can say that
>> there's a lot of known stuff but also much new/unknown stuff.
>> Which capturing settings (resolution, video format, ...) did you use for
>> these logs ?
> Someone else did the capture for me since I didn't have a Windows box it would work on. He had it connected to a video camera but didn't have an audio connection so there's no sound.
>
> Here's the settings from the Pinnical software.
>
> The properties of the video are:
>
> Codec                   IPB MPEG-2 MP@ML 4:2:0
> Bitrate                  8000 kBit/s
> Duration              00:00:05.10
> Color Depth        16 Bit
> Frame Aspect    4:3
> Alpha                    No
> Dimensions        720 x 480 px
> Pixel Aspect       0.89
> Framestart          0
> Frames                 29.97 FPS
> Interlacing           Top Field First

Hmm... looking at the logs, I would have expected 720x240 + YUV422...


> The properties of the audio are:
> Codec                   MP2
> Bitrate                  224kBit/s
> Duration              00:00:5.17
> Sample Rate       48 kHz
> Channels             Stereo
> Resolution          16 Bit
> Sample Type      Stereo
> Format                 PCM
>
> When I click on 'Import' there aren't a tone of settings:
>
> Dazzle Video Capture is set to 'Video Composite', 4:3, and NTSC
>
> Mode is set to 'Scene detection ON'
>
>
>> Does the device consist of any other chips (AC97, demodulator, ...) ?
>>
> Not that I see. There's a couple smaller chips on the device. I uploaded pictures here: 
>
> https://www.libertas-tech.com//dazzle1.jpg
> https://www.libertas-tech.com//dazzle2.jpg

Ok, thanks, I suspected that. :/
It seems like the em298x has a built-in demodulator (and likely also an
audio codec).
I can see lots of reads/writes to a "special" address in the log.


Ok, here is a summary of what needs to be done to support this device
and what is already more or less in place:

Should work out of the box or can be made work with minor changes:
1.) chip type detection (can be added easily with a small patch)
2.) eeprom access
3.) i2c bus access
4.) capturing configuration and start/stop (bridge part)
5.) frame processing (seems to be at least very similar to the one used
by the other em27xx/em28xx, I can see the same header type)
6.) audio part

ToDo:
1.) figure out the meaning of the USB endpoints and extend the current
logic to handle them properly
2.) add support for the built-in demodulator (an access routine is easy
to add, but the registers meaning/setup is completely unknown)
3.) figure out the meaning of some new/unknown bridge registers (0x2e,
0x38, 0x44, 0x4f, 0xb0-0xb8), xclk (reg 0x0f) is set to an unknown frequency

1.) and 3.) could probably be achieved with a good piece of reverse
engineering work and some dirty hacks.
But 2.) is hardly possible without the datasheet of the em298x. :(

Any chance to get access to the datasheet ? :-)

Regards,
Frank


>> Regards,
>> Frank
>>
>>>>> Here's the lsusb output:
>>>> ...
>>>>
>>>>>     Interface Descriptor:
>>>>>       bLength                 9
>>>>>       bDescriptorType         4
>>>>>       bInterfaceNumber        0
>>>>>       bAlternateSetting       7
>>>>>       bNumEndpoints           4
>>>>>       bInterfaceClass       255 Vendor Specific Class
>>>>>       bInterfaceSubClass      0
>>>>>       bInterfaceProtocol    255
>>>>>       iInterface              0
>>>>>       Endpoint Descriptor:
>>>>>         bLength                 7
>>>>>         bDescriptorType         5
>>>>>         bEndpointAddress     0x81  EP 1 IN
>>>>>         bmAttributes            3
>>>>>           Transfer Type            Interrupt
>>>>>           Synch Type               None
>>>>>           Usage Type               Data
>>>>>         wMaxPacketSize     0x0001  1x 1 bytes
>>>>>         bInterval              11
>>>>>       Endpoint Descriptor:
>>>>>         bLength                 7
>>>>>         bDescriptorType         5
>>>>>         bEndpointAddress     0x82  EP 2 IN
>>>>>         bmAttributes            1
>>>>>           Transfer Type            Isochronous
>>>>>           Synch Type               None
>>>>>           Usage Type               Data
>>>>>         wMaxPacketSize     0x1400  3x 1024 bytes
>>>>>         bInterval               1
>>>>>       Endpoint Descriptor:
>>>>>         bLength                 7
>>>>>         bDescriptorType         5
>>>>>         bEndpointAddress     0x84  EP 4 IN
>>>>>         bmAttributes            1
>>>>>           Transfer Type            Isochronous
>>>>>           Synch Type               None
>>>>>           Usage Type               Data
>>>>>         wMaxPacketSize     0x03ac  1x 940 bytes
>>>>>         bInterval               1
>>>>>       Endpoint Descriptor:
>>>>>         bLength                 7
>>>>>         bDescriptorType         5
>>>>>         bEndpointAddress     0x8a  EP 10 IN
>>>>>         bmAttributes            2
>>>>>           Transfer Type            Bulk
>>>>>           Synch Type               None
>>>>>           Usage Type               Data
>>>>>         wMaxPacketSize     0x0200  1x 512 bytes
>>>>>         bInterval               0
>>>> This endpoint configuration is different from the Empia devices
>>>> we've seen so far.
>>>> We have never seen any devices using endpoint address 0x8a and
>>>> endpoint 0x84 looks strange.
>>>> It's hard to say what they are used for.
>>>> The current em28xx driver will assume 0x84 is used for DVB, but that
>>>> makes no sense for this device.
>>>>
>>>> Regards,
>>>> Frank
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

