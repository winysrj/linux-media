Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:38605 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbZJ1Mvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 08:51:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: [Linux-uvc-devel] again "Logitech QuickCam Pro for Notebooks 046d:0991"
Date: Wed, 28 Oct 2009 13:52:14 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1255514751.15164.17.camel@zwerg> <200910280027.38292.laurent.pinchart@ideasonboard.com> <1256723904.3452.6.camel@zwerg>
In-Reply-To: <1256723904.3452.6.camel@zwerg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910281352.14940.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

On Wednesday 28 October 2009 10:58:24 Alexey Fisher wrote:
> Am Mittwoch, den 28.10.2009, 00:27 +0100 schrieb Laurent Pinchart:
> > On Monday 26 October 2009 15:06:41 Hans de Goede wrote:
> > > On 10/26/2009 12:52 PM, Alexey Fisher wrote:
> > > > Am Sonntag, den 25.10.2009, 14:21 +0100 schrieb Hans de Goede:
> >
> > [snip]
> >
> > > > > fwiw I'm a v4l kernel developer, but I'm not involved in the UVC
> > > > > driver, I'm however a contributor to cheese, I thought that my
> > > > > input that cheese would give up even if the driver has a long
> > > > > enough timeout would be helpful.
> > > > >
> > > > > To try and see if this (the cheese timeout is the issue), you will
> > > > > need to re-compile cheese from source, after unpacking cheese, edit
> > > > > src/cheese-webcam.c and goto line 716 (in 2.28.0)
> > > > >
> > > > > And change the "10 * GST_SECOND" there in something bigger. I also
> > > > > see that I'm mistaken and the timeout in cheese is not 3 but 10
> > > > > seconds, it might have changed recently, or my memory has been
> > > > > playing tricks on me.
> > > > >
> > > > > I still believe this might be the cause, the trace you have posted
> > > > > seems consistent with cheese's behaviour. Also noticed that there
> > > > > never is a successfull DQBUF the first time cheese opens the
> > > > > device. If cheese (or rather gstreamer) does not manage to DQBUF
> > > > > the first time, then cheese will not work with the device. There is
> > > > > a limitation in gstreamer (or maybe in the way cheese uses it)
> > > > > where gstreamer needs to be streaming before cheese can tell the
> > > > > properties of the cam. If the stream does not start within the
> > > > > first 10 seconds, then cheese will fail to get the properties.
> > > > >
> > > > > If you go to cheese's edit ->  preferences menu, and your cam has
> > > > > no resolutions listed there (the resolution drop down is grayed
> > > > > out). This is what is happening.
> > > > >
> > > > > As for empathy, I'm not familiar with that. But if we can get
> > > > > cheese to work first I'm sure that that would be a good step in the
> > > > > right direction.
> > > >
> > > > Hallo Hans,
> > > > thank you for your constructive response,
> > > > I increased timeout to 15 seconds i now i can't reproduce camera
> > > > freeze, i'll play with it more to be sure. There is still one issue
> > > > with it - on cold start the image is zoomed in.
> > > > I need to close cheese and open it again to get normal zoom. The
> > > > resolution seems to be the same.
> >
> > Zoomed in ? Really ? As far as I know the QuickCam Pro for Notebooks has
> > no optical or digital zoom. Could you please send me lsusb's output for
> > your device ?
> 
> Yes. I can use digital zoom under M$Win with Logitech software.

That's probably implemented in software in the Windows driver.

[snip]

> sudo lsusb -vd 046d:0991
> 
> Bus 001 Device 007: ID 046d:0991 Logitech, Inc. QuickCam Pro for
> Notebooks
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x046d Logitech, Inc.
>   idProduct          0x0991 QuickCam Pro for Notebooks
>   bcdDevice            0.05
>   iManufacturer           0
>   iProduct                0
>   iSerial                 2 [removed]
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength         1433
>     bNumInterfaces          4
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         0
>       bInterfaceCount         2
>       bFunctionClass         14 Video
>       bFunctionSubClass       3 Video Interface Collection
>       bFunctionProtocol       0
>       iFunction               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      1 Video Control
>       bInterfaceProtocol      0
>       iInterface              0
>       VideoControl Interface Descriptor:
>         bLength                13
>         bDescriptorType        36
>         bDescriptorSubtype      1 (HEADER)
>         bcdUVC               1.00
>         wTotalLength          133
>         dwClockFrequency       48.000000MHz
>         bInCollection           1
>         baInterfaceNr( 0)       1
>       VideoControl Interface Descriptor:
>         bLength                18
>         bDescriptorType        36
>         bDescriptorSubtype      2 (INPUT_TERMINAL)
>         bTerminalID             1
>         wTerminalType      0x0201 Camera Sensor
>         bAssocTerminal          0
>         iTerminal               0
>         wObjectiveFocalLengthMin      0
>         wObjectiveFocalLengthMax      0
>         wOcularFocalLength            0
>         bControlSize                  3
>         bmControls           0x0000000e
>           Auto-Exposure Mode
>           Auto-Exposure Priority
>           Exposure Time (Absolute)

The zoom control, if present, should have appeared here.

As your camera doesn't expose any zoom control I really don't know where the 
zoom comes from.

-- 
Regards,

Laurent Pinchart
