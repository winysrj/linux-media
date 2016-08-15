Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:30441 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbcHONzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 09:55:40 -0400
From: Hans Verkuil <hansverk@cisco.com>
Subject: [ANN] HDMI CEC: added cec-compliance/cec-follower utilities
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Message-ID: <6a2674e6-f6e6-d55b-5601-cbf06da54ef4@cisco.com>
Date: Mon, 15 Aug 2016 15:55:36 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two new CEC utilities have been added to the v4l-utils repository:

https://git.linuxtv.org/v4l-utils.git/

The cec-follower utility can emulate a CEC device, implementing the
follower functionality needed.

The cec-compliance utility can test a remote CEC device and check how
compliant it is against the CEC specification.

A major problem with CEC implementations is that they often poorly
adhere to the standard. These two utilities are an attempt to provide
a way to test CEC implementations.

Many thanks go to Johan Fjeldtvedt for working on this as part of his
Cisco Summer internship!

The linux-media mailinglist is the main point of contact, and patches
improving these utilities are welcome.

Note that these CEC features have currently limited coverage:

One Touch Record
Deck Control
Device Menu Control
Audio Rate Control
Tuner Control
Timer Programming
Capability Discovery and Control
Vendor Specific Commands

There is also no or very limited support for Unregistered devices,
CEC switches and CDC-only devices.

The compliance tests are based on CEC 2.0, although some tests are
slightly different for CEC 1.4 devices.

If you want to experiment with these utilities, then the easiest method
is to use the vivid driver from kernel 4.8. That driver provides two
emulated CEC devices.

	modprobe vivid

This creates two cec devices: cec0 is that of the HDMI receiver, cec1
is the device for the HDMI transmitter.

This can be verified with 'cec-ctl -d0' and 'cec-ctl -d1'. The physical
address of the receiver is reported as 0.0.0.0, that of the transmitter
as 1.0.0.0.

Note: -dX is short-hand for -d /dev/cecX.

The next step is to configure these two devices:

	cec-ctl -d0 --tv
	cec-ctl -d1 --playback

This configures the receiver as a TV and the transmitter as a playback
device.

Now start cec-follower to emulate the playback device:

	cec-follower -d1

And start the compliance test to test the follower implementation:

	cec-compliance -d0 -r4

The -r4 option says that it should test the remote CEC device with logical
address 4 (i.e. the playback device).

These utilities require that the cec device is configured (e.g. the
CEC_S_LOG_ADDRS ioctl was called), otherwise they will refuse to run.
That's why cec-ctl is needed to configure the two vivid cec devices.

Some tests require interactive mode. Add the -i option to enable that.
Especially tests relating to Standby mode need a human to look at the TV
to verify it is really in standby or not.

Below is the full output for the compliance run from the example above. Sadly,
it is very unlikely you'll see 0 failures with real CEC implementations.

Regards,

	Hans

Example of a compliance run:

$ cec-compliance -r4
Driver Info:
         Driver Name                : vivid
         Adapter Name               : vivid-000-vid-cap0
         Capabilities               : 0x0000003e
                 Logical Addresses
                 Transmit
                 Passthrough
                 Remote Control Support
                 Monitor All
         Driver version             : 4.8.0
         Available Logical Addresses: 1
         Physical Address           : 0.0.0.0
         Logical Address Mask       : 0x0001
         CEC Version                : 2.0
         Vendor ID                  : 0x000c03
         Logical Addresses          : 1

           Logical Address          : 0
             Primary Device Type    : TV
             Logical Address Type   : TV
             All Device Types       : TV
             RC TV Profile          : None
             Device Features        :
                 None

Compliance test for device /dev/cec0:

     The test results mean the following:
         OK                  Supported correctly by the device.
         OK (Not Supported)  Not supported and not mandatory for the device.
         OK (Presumed)       Presumably supported.  Manually check to confirm.
         OK (Unexpected)     Supported correctly but is not expected to be supported for this device.
         OK (Refused)        Supported by the device, but was refused.
         FAIL                Failed and was expected to be supported by this device.

Find remote devices:
         Polling: OK

Network topology:
         System Information for device 4 (Playback Device 1) from device 0 (TV):
                 CEC Version                : 2.0
                 Physical Address           : 1.0.0.0
                 Primary Device Type        : Playback
                 Vendor ID                  : 0x000c03
                 OSD Name                   : 'Playback'
                 Power Status               : On

testing CEC local LA 0 (TV) to remote LA 4 (Playback Device 1):
         Core:
             Feature aborts unknown messages: OK
             Feature aborts Abort message: OK

         Give Device Power Status feature:
             Give Device Power Status: OK
             Report Device Power Status: OK (Presumed)

         System Information feature:
             Polling Message: OK
             Give Physical Address: OK
             Give CEC Version: OK
             Get Menu Language: OK (Not Supported)
             Set Menu Language: OK (Presumed)
             Give Device Features: OK

         Vendor Specific Commands feature:
             Give Device Vendor ID: OK

         Device OSD Transfer feature:
             Set OSD Name: OK (Not Supported)
             Give OSD Name: OK

         OSD String feature:

         Remote Control Passthrough feature:
             User Control Pressed: OK (Presumed)
             User Control Released: OK (Presumed)

         Device Menu Control feature:
             Menu Request: OK (Not Supported)
             Menu Status: OK (Not Supported)
             User Control Pressed: OK (Presumed)
             User Control Released: OK (Presumed)

         Deck Control feature:
             Give Deck Status: OK (Not Supported)
             Deck Status: OK
             Deck Control: OK (Not Supported)
             Play: OK (Not Supported)

         Tuner Control feature:
             Give Tuner Device Status: OK (Not Supported)
             Select Analogue Service: OK (Not Supported)
             Select Digital Service: OK (Not Supported)
             Tuner Device Status: OK
             Tuner Step Decrement: OK (Not Supported)
             Tuner Step Increment: OK (Not Supported)

         One Touch Record feature:
             Record TV Screen: OK (Not Supported)
             Record On: OK (Not Supported)
             Record Off: OK (Not Supported)
             Record Status: OK

         Timer Progrmaming feature:
             Set Analogue Timer: OK (Not Supported)
             Set Digital Timer: OK (Not Supported)
             Set Timer Program Title: OK (Not Supported)
             Set External Timer: OK (Not Supported)
             Clear Analogue Timer: OK (Not Supported)
             Clear Digital Timer: OK (Not Supported)
             Clear External Timer: OK (Not Supported)
             Timer Status: OK (Presumed)
             Timer Cleared Status: OK (Presumed)

         Capability Discovery and Control feature:
             CDC_HEC_Discover: OK

         Dynamic Auto Lipsync feature:
             Request Current Latency: OK
             Request Current Latency with invalid PA: OK

         Audio Return Channel feature:
             Initiate ARC (RX): OK (Not Supported)

         System Audio Control feature:
             Request Short Audio Descriptor: OK (Not Supported)
             Set System Audio Mode (directly addressed): OK (Not Supported)
             Set System Audio Mode (broadcast on): OK (Presumed)
             System Audio Mode Status: OK (Unexpected)
             System Audio Mode Request (on): OK (Not Supported)
             Give System Audio Mode Status: OK (Not Supported)
             Give Audio Status: OK (Not Supported)
             User Control Pressed (Volume Up): OK (Presumed)
             User Control Pressed (Volume Down): OK (Presumed)
             User Control Pressed (Mute): OK (Presumed)
             User Control Released: OK (Presumed)
             Set System Audio Mode (broadcast off): OK (Presumed)

         Audio Rate Control feature:
             Set Audio Rate: OK (Not Supported)

         One Touch Play feature:
             Image View On: OK (Presumed)
             Text View On: OK (Presumed)
             Active Source: OK (Presumed)
             Request Active Source: OK

         Routing Control feature:
             Inactive Source: OK (Not Supported)
             Active Source: OK (Presumed)
             Request Active Source: OK
                 >>> Sending Set Stream Path and waiting for reply. This may take up to 60 s.
             Set Stream Path: OK

         Standby/Resume and Power Status:
                 >>> Sending Standby message.
                 >>> Waiting for new stable power status. This may take up to 60 s.
                 >>> Transient state after 0 s, stable state Standby after 2 s
             Standby: OK
                 >>> Sending Standby message.
                 >>> Checking for power status change. This may take up to 60 s.
             Repeated Standby message does not wake up: OK
                 >>> Sending Active Source message.
                 >>> Checking for power status change. This may take up to 60 s.
             No wakeup on Active Source: OK
                 >>> Device is woken up
                 >>> Waiting for new stable power status. This may take up to 60 s.
                 >>> Transient state after 0 s, stable state On after 2 s
             Wake up: OK

         Post-test checks:
             Recognized/unrecognized message consistency: OK

Total: 54, Succeeded: 54, Failed: 0, Warnings: 0

