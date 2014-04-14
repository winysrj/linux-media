Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32883 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbaDNK1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 06:27:07 -0400
Message-Id: <1397471220.18984.106207305.0AC6C440@webmail.messagingengine.com>
From: Will Manley <will@williammanley.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Reply-To: will@williammanley.net
In-Reply-To: <1551199.fyCn5EYGon@avalon>
References: <1394647711-25291-1-git-send-email-will@williammanley.net>
 <1832254.8GCCJyof1H@avalon> <53222C64.90901@williammanley.net>
 <1551199.fyCn5EYGon@avalon>
Subject: Re: [PATCH] uvcvideo: Work around buggy Logitech C920 firmware
Date: Mon, 14 Apr 2014 11:27:00 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Apr 2014, at 1:34, Laurent Pinchart wrote:
> On Thursday 13 March 2014 22:08:36 William Manley wrote:
> > On 13/03/14 17:03, Laurent Pinchart wrote:
> > > On Thursday 13 March 2014 10:48:20 Will Manley wrote:
> > >> On Thu, 13 Mar 2014, at 10:23, Laurent Pinchart wrote:
> > >>> On Wednesday 12 March 2014 18:08:31 William Manley wrote:
> > >>>> The uvcvideo webcam driver exposes the v4l2 control "Exposure
> > >>>> (Absolute)" which allows the user to control the exposure time of the
> > >>>> webcam, essentially controlling the brightness of the received image.
> > >>>> By default the webcam automatically adjusts the exposure time
> > >>>> automatically but the if you set the control "Exposure, Auto"="Manual
> > >>>> Mode" the user can fix the exposure time.
> > >>>> 
> > >>>> Unfortunately it seems that the Logitech C920 has a firmware bug where
> > >>>> it will forget that it's in manual mode temporarily during
> > >>>> initialisation. This means that the camera doesn't respect the exposure
> > >>>> time that the user requested if they request it before starting to
> > >>>> stream video. They end up with a video stream which is either too
> > >>>> bright or too dark and must reset the controls after video starts
> > >>>> streaming.
> > >>> 
> > >>> I would like to get a better understanding of the problem first. As I
> > >>> don't have a C920, could you please perform two tests for me ?
> > >>> 
> > >>> I would first like to know what the camera reports as its exposure time
> > >>> after starting the stream. If you get the exposure time at that point
> > >>> (by sending a GET_CUR request, bypassing the driver cache), do you get
> > >>> the value you had previously set (which, from your explanation, would be
> > >>> incorrect, as the exposure time has changed based on your findings), or
> > >>> a different value ? Does the camera change the exposure priority control
> > >>> autonomously as well, or just the exposure time ?
> > >> 
> > >> It's a bit of a strange behaviour. I'd already tried littering the code
> > >> with (uncached) GET_CUR requests. It seems that the value changes
> > >> sometime during the call to usb_set_interface in uvc_init_video.
> > > 
> > > I'll assume this means that the camera reports the updated exposure time
> > > in response to the GET_CUR request.
> > 
> > That's right
> > 
> > > Does the value of other controls (such as the
> > > exposure priority control for instance) change as well ?
> > 
> > No, I've not seen any of the other controls change.
> > 
> > >> Strangely enough though calling uvc_ctrl_restore_values immediately after
> > >> uvc_init_video has no effect. It must be put after the usb_submit_urb
> > >> loop to fix the problem.
> > >> 
> > >>> Then, I would like to know whether the camera sends a control update
> > >>> event when you start the stream, or if it just changes the exposure time
> > >>> without notifying the driver.
> > >> 
> > >> Wireshark tells me that it is sending a control update event, but it
> > >> seems like uvcvideo ignores it. I had to add the flag
> > >> UVC_CTRL_FLAG_AUTO_UPDATE to the uvc_control_info entry for "Exposure
> > >> (Auto)" for the new value to be properly reported to userspace.
> > > 
> > > Could you send me the USB trace ?
> > 
> > I've uploaded 3 traces: one with no patch (kernel 3.12) one with my
> > "PATCH v2" applied and one with no patch but caching of gets disabled.
> > You can get them here:
> > 
> >     http://williammanley.net/C920-no-patch.pcapng
> >     http://williammanley.net/C920-with-patch.pcapng
> >     http://williammanley.net/C920-no-caching.pcapng
> > 
> > The process to generate them was:
> > 
> >     sudo dumpcap -i usbmon1 -w /tmp/C920-no-patch2.pcapng &
> > 
> >     # Plug USB cable in here
> > 
> >     v4l2-ctl -d
> > /dev/v4l/by-id/usb-046d_HD_Pro_Webcam_C920_C833389F-video-index1
> > 
> > -cexposure_auto=1,exposure_auto_priority=0,exposure_absolute=152,white_balan
> > ce_temperature_auto=0
> > 
> >     ./streamon
> > 
> > The relevant output seems to be (here from C920-no-patch.pcapng):
> > > 10446 23.095874000 21:14:16.313257000         host -> 32.0         USB 64
> > > SET INTERFACE Request 10447 23.109379000 21:14:16.326762000         32.3
> > > -> host         USBVIDEO 70 URB_INTERRUPT in 10448 23.109389000
> > > 21:14:16.326772000         host -> 32.3         USB 64 URB_INTERRUPT in
> > > 10449 23.189448000 21:14:16.406831000         32.3 -> host        
> > > USBVIDEO 73 URB_INTERRUPT in 10450 23.189486000 21:14:16.406869000       
> > >  host -> 32.3         USB 64 URB_INTERRUPT in 10451 23.243314000
> > > 21:14:16.460697000         32.0 -> host         USB 64 SET INTERFACE
> > > Response
> > Taking a closer look at packet 10449:
> > > Frame 10449: 73 bytes on wire (584 bits), 73 bytes captured (584 bits) on
> > > interface 0> 
> > >     Interface id: 0
> > >     Encapsulation type: USB packets with Linux header and padding (115)
> > >     Arrival Time: Mar 13, 2014 21:14:16.406831000 GMT
> > >     [Time shift for this packet: 0.000000000 seconds]
> > >     Epoch Time: 1394745256.406831000 seconds
> > >     [Time delta from previous captured frame: 0.080059000 seconds]
> > >     [Time delta from previous displayed frame: 0.080059000 seconds]
> > >     [Time since reference or first frame: 23.189448000 seconds]
> > >     Frame Number: 10449
> > >     Frame Length: 73 bytes (584 bits)
> > >     Capture Length: 73 bytes (584 bits)
> > >     [Frame is marked: False]
> > >     [Frame is ignored: False]
> > >     [Protocols in frame: usb:usbvideo]
> > > 
> > > USB URB
> > > 
> > >     URB id: 0xffff88081bf95240
> > >     URB type: URB_COMPLETE ('C')
> > >     URB transfer type: URB_INTERRUPT (0x01)
> > >     Endpoint: 0x83, Direction: IN
> > >     
> > >         1... .... = Direction: IN (1)
> > >         .000 0011 = Endpoint value: 3
> > >     
> > >     Device: 32
> > >     URB bus id: 1
> > >     Device setup request: not relevant ('-')
> > >     Data: present (0)
> > >     URB sec: 1394745256
> > >     URB usec: 406831
> > >     URB status: Success (0)
> > >     URB length [bytes]: 9
> > >     Data length [bytes]: 9
> > >     [Request in: 10448]
> > >     [Time from request: 0.080059000 seconds]
> > >     [bInterfaceClass: Video (0x0e)]
> > > 
> > > .... 0001 = Status Type: VideoControl Interface (0x01)
> > > Originator: 1
> > > Event: Control Change (0x00)
> > > Control Selector: Exposure Time (Absolute) (0x04)
> > > Change Type: Value (0x00)
> > > Current value: 333 (0x0000014d)
> > 
> > This is the notification of the change of the value.  As you can see it
> > happens between "SET INTERFACE Request" and "SET INTERFACE Response".
> 
> Thank you for investigating this, and sorry for the late reply.
> 
> I still haven't heard back from Logitech on this issue. I've pinged them,
> they 
> might be busy at the moment.

Thanks for looking at my patch :).

> Given that the device notifies us that the control value changes, one
> possibly 
> more clever fix would be to handle that even and set the old control
> value 
> back when the auto control is disabled. However, that's probably an 
> overengineered solution.
> 
> I've still been wondering whether the quirk shouldn't restore only the 
> control(s) that are known to be erroneously changed by the camera instead
> of 
> restoring them all. Feel free to disagree, what's your opinion about that
> ?

So that was my initial intention, but when I got into it it seemed like
it was going to add a whole bunch of additional complexity (and lines of
code) for questionable benefit.  While uploading all the values is a bit
of a sledgehammer it has the advantage that it's simple and dumb and
exercises code that's already in use for suspend/resume.  OTOH you could
argue that a patch which explicitly contains code like:

    if (strcmp(param.name, "Exposure (Absolute)") == 0) {
        blah, blah, blah
    }

or similar documents the quirk a little more explicitly.  I still didn't
think it was worth the extra complexity.  I'm quite willing to be
convinced otherwise though :).

Another more marginal advantage is that the quirk may be more applicable
to other hardware.  Of course this is entirely theoretical at this point
so probably can be discounted.

Thanks

Will
