Return-path: <linux-media-owner@vger.kernel.org>
Received: from ks4004239.ip-142-4-213.net ([142.4.213.193]:35075 "EHLO
	mon.libertas-tech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbaBFM5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 07:57:33 -0500
Date: Thu, 6 Feb 2014 07:57:19 -0500
From: Keith Lawson <keith.lawson@libertas-tech.com>
To: Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Support for Empia 2980 video/audio capture chip set
Message-ID: <20140206125719.GA10386@nowhere.ca>
References: <1ed89f5b0a32bf26e17cee890a26b012@www.nowhere.ca>
 <52D2C929.9080109@googlemail.com>
 <de907f83197624a31fc6690a43a21929@www.nowhere.ca>
 <52D6FFA8.8060008@googlemail.com>
 <20140117001102.GA18205@nowhere.ca>
 <52DD8239.6060001@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52DD8239.6060001@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 20, 2014 at 09:08:25PM +0100, Frank Schäfer wrote:
> On 17.01.2014 01:11, Keith Lawson wrote:
> >On Wed, Jan 15, 2014 at 10:37:44PM +0100, Frank Schäfer wrote:
> >>Am 14.01.2014 01:48, schrieb Keith Lawson:
> >>>On 2014-01-12 11:56, Frank Schäfer wrote:
> >>>
> >>>>On 09.01.2014 02:02, Keith Lawson wrote:
> >>>>
> >>>>>Hello, I sent the following message to the linux-usb mailing list
> >>>>>and they suggested I try here. I'm trying to get a "Dazzle Video
> >>>>>Capture USB V1.0" video capture card working on a Linux device but
> >>>>>it doesn't
> >>>>>look like the chip set is supported yet. I believe this card is the
> >>>>>next version of the Pinnacle VC100 capture card that worked with the
> >>>>>em28xx kernel module. The hardware vendor that sold the card says that
> >>>>>this device has an Empia 2980 chip set in it so I'm inquiring about
> >>>>>support for that chip set. I'm just wondering about the best
> >>>>>approach for getting the new chip supported in the kernel. Is this
> >>>>>something the
> >>>>>em28xx maintainers would naturally address in time or can I assist
> >>>>>in getting this into the kernel? Here's dmesg from the Debian box
> >>>>>I'm working on: [ 3198.920619] usb 3-1: new high-speed USB device
> >>>>>number 5
> >>>>>usingxhci_hcd [ 3198.939394] usb 3-1: New USB device found,
> >>>>>idVendor=1b80,idProduct=e60a [ 3198.939399] usb 3-1: New USB device
> >>>>>strings: Mfr=0, Product=1,SerialNumber=2 [ 3198.939403] usb 3-1:
> >>>>>Product: Dazzle
> >>>>>Video Capture USB Audio Device [ 3198.939405] usb 3-1: SerialNumber:
> >>>>>0 l440:~$ uname -a Linux l440 3.10-3-amd64 #1 SMP Debian 3.10.11-1
> >>>>>(2013-09-10) x86_64 GNU/Linux If this isn't the appropriate list to ask
> >>>>>this question please point me in the right direction. Thanks, Keith
> >>>>The em28xx is indeed the dedicated driver for this device, but it's hard
> >>>>to say how much work would be necessary to add support for it.
> >>>>We currently don't support any em29xx chip yet, but in theory it is just
> >>>>an extended em28xx device.
> >>>>Whatever that means when it comes to the low level stuff... ;)
> >>>>
> >>>What's the best route to get support for this chip added then? Should
> >>>I start working on a patch myself or will this just happen during the
> >>>course of development of the em28xx module? I'm a developer but
> >>>haven't done any kernel hacking so this would likely be a steep
> >>>learning curve for me.
> >>Can you create USB-Traces of the Windows driver and send us the output
> >>of "lsusb -v -d 1b80:e60a" for this device ?
> >>That will give us a hint how much work will be needed.
> >For the USB-trace will the Win7 logman output do or is there a Win7 64-bit utility like usbsnoop I should use?
> 
> AFAIK the logman output doesn't contain any transferred data.
> SniffUSB would be preferred, but AFAIK it doesn't work with Win 7.
> You may also want to try USBPcap (http://desowin.org/usbpcap/), but
> I don't know if it runs on the 64bit version of Win 7.
> There are also various commercial USB-Sniffers and some of them are
> providing a free trial period/version.
> In any case we need a readable (text) sniffing output.

Thanks for the pointer. I used USBPcap and exported text out of wireshark. 

Here's the capture of connecting the device: 

https://www.libertas-tech.com/dazzle_usb_connect.txt

Here's a capture of the device recording a 1 minute video. This one is almost 700 meg so you probably don't want to try and open it in a browser: 

https://www.libertas-tech.com/dazzle_recording_video.txt 

I can arrange to get one of these devices in the hands of a developer if that would help too. 

> 
> >Here's the lsusb output:
> ...
> 
> >     Interface Descriptor:
> >       bLength                 9
> >       bDescriptorType         4
> >       bInterfaceNumber        0
> >       bAlternateSetting       7
> >       bNumEndpoints           4
> >       bInterfaceClass       255 Vendor Specific Class
> >       bInterfaceSubClass      0
> >       bInterfaceProtocol    255
> >       iInterface              0
> >       Endpoint Descriptor:
> >         bLength                 7
> >         bDescriptorType         5
> >         bEndpointAddress     0x81  EP 1 IN
> >         bmAttributes            3
> >           Transfer Type            Interrupt
> >           Synch Type               None
> >           Usage Type               Data
> >         wMaxPacketSize     0x0001  1x 1 bytes
> >         bInterval              11
> >       Endpoint Descriptor:
> >         bLength                 7
> >         bDescriptorType         5
> >         bEndpointAddress     0x82  EP 2 IN
> >         bmAttributes            1
> >           Transfer Type            Isochronous
> >           Synch Type               None
> >           Usage Type               Data
> >         wMaxPacketSize     0x1400  3x 1024 bytes
> >         bInterval               1
> >       Endpoint Descriptor:
> >         bLength                 7
> >         bDescriptorType         5
> >         bEndpointAddress     0x84  EP 4 IN
> >         bmAttributes            1
> >           Transfer Type            Isochronous
> >           Synch Type               None
> >           Usage Type               Data
> >         wMaxPacketSize     0x03ac  1x 940 bytes
> >         bInterval               1
> >       Endpoint Descriptor:
> >         bLength                 7
> >         bDescriptorType         5
> >         bEndpointAddress     0x8a  EP 10 IN
> >         bmAttributes            2
> >           Transfer Type            Bulk
> >           Synch Type               None
> >           Usage Type               Data
> >         wMaxPacketSize     0x0200  1x 512 bytes
> >         bInterval               0
> This endpoint configuration is different from the Empia devices
> we've seen so far.
> We have never seen any devices using endpoint address 0x8a and
> endpoint 0x84 looks strange.
> It's hard to say what they are used for.
> The current em28xx driver will assume 0x84 is used for DVB, but that
> makes no sense for this device.
> 
> Regards,
> Frank
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
