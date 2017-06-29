Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:42717 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751776AbdF2UKX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 16:10:23 -0400
Subject: Re: [linux-media] How to handle independent CA devices
To: linux-media@vger.kernel.org, Ralph Metzler <rjkm@metzlerbros.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <19593.22297.612764.560375@valen.metzler>
 <4C928170.7060808@tvdr.de>
Cc: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
        Daniel Scheller <d.scheller@gmx.net>,
        Oliver Endriss <o.endriss@gmx.de>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <1bb6ac49-f82f-84bc-3925-44b52788970d@anw.at>
Date: Thu, 29 Jun 2017 22:10:12 +0200
MIME-Version: 1.0
In-Reply-To: <4C928170.7060808@tvdr.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

It is now 6,5 years since this eMail ir reply to and a lot of things changed
since then.

As there is currently a lot of effort done to get the newest version of the DD
(Digital Devices) drivers into the Kernel, I want to bring up this topic again.
Yes, this eMail is long but it is necessary to explain all very detailed, so
all people can understand the new concepts.



a) First a description of the current situation:

> VDR already has mechanisms that allow independent handling of CAMs
> and receiving devices. Out of the box this currently only works for
> DVB devices that actually have a frontend and where the 'ca' device
> is under the same 'adapter' as the frontend.
This is still the case and it is good so.
What has been changed is ddbridge. Not in the current Kernel version, but in
the vendor version. Ralph implemented the ddbridge parameter adapter_alloc,
which allows to configure where the caX device is allocated. Moreover, he
implemented a sysFS node (ddbridge?/redirect) to control how the TS stream is
routed through ddbridge.

With both together you can implement all required combinations an application
needs. The Default is a complete independent creation of the caX devices into a
separate adapter$ directory. Also the TS stream is *not* routed through the CI
interface, but to the reused secX device (the DD version uses a new device node
ciX for that instead of secX).

In this setup, VDR doesn't see the caX device and therefore doesn't initialize
it. Which is perfectly OK, because it isn't possible to use it anyway.

> So, the bottom line is: I would appreciate an implementation where,
> given the configuration you described above, I could, e.g., tune using
> /dev/dvb/adapter0/frontend0, read the data stream from /dev/dvb/adapter0/dvr0
> as usual, communicate with the CAM through /dev/dvb/adapter2/ca0 and
> (which is the tricky part, I guess) "tell" the driver or some library
> function to "assign the CAM in /dev/dvb/adapter2/ca0 to the frontend|dvr
> in /dev/dvb/adapter0/frontend0|dvr0).
I guess Ralph implemented the sysFS node (ddbridge?/redirect) and
adapter_alloc because of this request from Klaus and of course that the DD
hardware is usable by any other software, too.

If ddbridge is started with the parameter adapter_alloc=3, then the driver
creates the caX and the secX(ciX) device in the same directory as the frontendX
and dvrX devices. Now VDR will recognize the caX device and initialize the CAM.
Additionally, the user needs to select which caX device shall be used for which
tuner via the mentioned sysFS node (ddbridge?/redirect). With this combination
the DD driver behaves like a DVB card which has the CI interface hard wired to
a tuner. It will route the TS stream through the CAM via the CI hardware before
it can be read out of the dvrX device.
Long time this was the only possibility to use the DD CI with a DD tuner.

> As for decrypting data from several frontends through one CAM: I don't
> see this happening in VDR. Pay tv channels repeat their stuff
In the meantime VDR is able do MTD (multi tuner decoding) by rewriting
the PIDs of the TS stream and feed it into the CAM (connected via a DD CI
hardware) with help of a plugin I wrote.

> However, VDR always assumes that the data to be recorded comes out of
> the 'dvr' device that's under the same adapter as the 'frontend'.
> So requiring that VDR would read from the frontend's 'dvr' device,
> write to the ca-adapter's 'sec' (or whatever) device, and finally read
> from that same 'sec' device again would be something I'd rather avoid.
VDR provides a plugin interface for a CI driver since version 2.1.7. With this
interface it is now possible to connect any CI hardware to VDR, if a plugin
does the caX/secX(ciX) device communication.
As mentioned above the DD driver default is creating the caX/secX(ciX) device
in a dedicated adapter$ directory and the TS stream is available at the dvrX
device in another adapter$ directory (possibly encrypted).

My VDR plugin will now search for adapter$ directories with only caX/secX(ciX)
devices and provide them to VDR. VDR itself will not initialize the CAM
interface, because the caX device is not in the same adapter$ directory as the
dvrX device, although it still searches for them. So VDR would still use the
caX device of a DVB card with a hard wired CI interface.

Moreover, VDR is now able to use the DD CI interface together with a DVB device
from another vendor. It is even possible to use the same CAM for several tuners
from different vendors.



b) Things to do:

>From all of the above we see, that a dedicated CI interface (independent from a
tuner) is a very useful piece of hardware.
Currently DD provides the Octopus CI, the DuoFlex CI (single) and the DuoFlex
CI (dual) (if I forget one, I apologize). The cxd2099 driver is used on the
DuoFlex CI (single) card only (AFAIK). The other cards are handled by ddbrigde
directly. Moreover, ddbridge provides is re-using the secX device (or
implementing the ciX device) and not the cxd2099 driver.

1) From that said I really see *no* reason why the cxd2099 driver is in the
staging directory!
This driver is an i2c driver used for the transport of the caX device data
only. Yes, it is for a dedicated CI hardware, but with the new ddbridge core it
can be used in several modes including a hard wired operation (permanent
attached to a specific tuner).
-- So I plan to move this driver from staging/media to the media/i2c directory.

2) When thew DD CI interface is used in the tuner independent mode, the TS
stream needs to be feed through a device to the CAM and read back. This
requires a new device. The dedicated device is a must to use the new feature
MTD implemented by VDR, because only a user space application can rewrite the
PIDs and CA-PMTs from different TS streams.
The current Kernel version of ddbridge uses the secX device for that. The
vendor version of ddbridge renamed secX to ciX. Yes, this breaks the Kernel
API, but secX is depreciated since really long time and not used anymore.
Implementing a new ciX device additionally is too much effort, but renaming it
is not. I would like to hear some comments on this topic.
-- Is it OK to rename secX to ciX or shall we add a new ciX device and keep the
   unused depreciated secX?

Please comment on the "--" questions.

BR,
   Jasmin
