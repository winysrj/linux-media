Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60994 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbeJaDdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 23:33:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: uvcvideo: IR camera lights only every second frame
Date: Tue, 30 Oct 2018 20:38:28 +0200
Message-ID: <12232791.8Rei9ILrTX@avalon>
In-Reply-To: <2bd43354-4a41-e73b-9071-8287e1f0f754@ideasonboard.com>
References: <3377b60e-afee-97bb-8714-36d4df048cef@suse.cz> <2bd43354-4a41-e73b-9071-8287e1f0f754@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, 30 October 2018 17:48:12 EET Kieran Bingham wrote:
> On 30/10/2018 14:36, Jiri Slaby wrote:
> > Hi,
> > 
> > I have a Dell Lattitude 7280 with two webcams. The standard one works
> > fine (/dev/video0). The other one is an IR camera (/dev/video1). The
> > camera proper works fine and produces 340x374 frames. But there is an IR
> > led supposed to light the object. The video is 30fps, but the LED seems
> > to emit light only on half of the frames, i.e. on every second frame (15
> > fps). This makes the video blink a lot. The two consecutive frames look
> > like:
> > https://www.fi.muni.cz/~xslaby/sklad/mpv-shot0002.jpg
> > https://www.fi.muni.cz/~xslaby/sklad/mpv-shot0003.jpg
> > 
> > Do you have any ideas what to check/test?
> 
> I have an HP Spectre with IR camera, and it also 'flashes' alternate frames.
> 
> I assumed this was something to do with controlling the lighting for
> face recognition some how.
> 
> I'm fairly sure we don't control the 'IR flash' from the UVC.
> 
> I wonder if there is a control parameter for the IR led in the
> extension-units?

[snip]

> >       VideoControl Interface Descriptor:
> >         bLength                18
> >         bDescriptorType        36
> >         bDescriptorSubtype      2 (INPUT_TERMINAL)
> >         bTerminalID            11
> >         wTerminalType      0x0201 Camera Sensor
> >         bAssocTerminal          0
> >         iTerminal               0
> >         wObjectiveFocalLengthMin      0
> >         wObjectiveFocalLengthMax      0
> >         wOcularFocalLength            0
> >         bControlSize                  3
> >         bmControls           0x00000000
> >       VideoControl Interface Descriptor:
> >         bLength                11
> >         bDescriptorType        36
> >         bDescriptorSubtype      5 (PROCESSING_UNIT)
> >       Warning: Descriptor too short
> >         bUnitID                 9
> >         bSourceID              11
> >         wMaxMultiplier          0
> >         bControlSize            2
> >         bmControls     0x00000000
> >         iProcessing             0
> >         bmVideoStandards     0x09
> >           None
> >           SECAM - 625/50
> >       VideoControl Interface Descriptor:
> >         bLength                 9
> >         bDescriptorType        36
> >         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
> >         bTerminalID             8
> >         wTerminalType      0x0101 USB Streaming
> >         bAssocTerminal          0
> >         bSourceID              10
> >         iTerminal               0
> >       VideoControl Interface Descriptor:
> >         bLength                25
> >         bDescriptorType        36
> >         bDescriptorSubtype      6 (EXTENSION_UNIT)
> >         bUnitID                12
> >         guidExtensionCode         {45b5da73-23c1-4a3d-a368-610f078c4397}
> >         bNumControl             0
> >         bNrPins                 1
> >         baSourceID( 0)          9
> >         bControlSize            0
> >         iExtension              0

This extension unit is strange, it exposes no control.

> >       VideoControl Interface Descriptor:
> >         bLength                27
> >         bDescriptorType        36
> >         bDescriptorSubtype      6 (EXTENSION_UNIT)
> >         bUnitID                10
> >         guidExtensionCode         {1229a78c-47b4-4094-b0ce-db07386fb938}
> >         bNumControl             2
> >         bNrPins                 1
> >         baSourceID( 0)         12
> >         bControlSize            2
> >         bmControls( 0)       0x00
> >         bmControls( 1)       0x06
> >         iExtension              0

This one exposes two controls, which are likely used to control the IR light. 
I however suspect that the controls merely expose an indirect way to read/
write internal registers, so we would really need to capture a USB trace when 
using the device in Windows (assuming that the machine is shipped with 
software that can control the IR light).

[snip]

-- 
Regards,

Laurent Pinchart
