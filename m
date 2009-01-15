Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FHI9Ki006869
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 12:18:22 -0500
Received: from dd18532.kasserver.com (dd18532.kasserver.com [85.13.139.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FGpN0Z022193
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 11:52:04 -0500
Date: Thu, 15 Jan 2009 17:51:21 +0100
From: Carsten Meier <cm@trexity.de>
To: Jonathan Lafontaine <jlafontaine@ctecworld.com>
Message-ID: <20090115175121.25c4bdaa@tuvok>
In-Reply-To: <09CD2F1A09A6ED498A24D850EB10120817E30B7506@Colmatec004.COLMATEC.INT>
References: <20090115163348.5da9932a@tuvok>
	<09CD2F1A09A6ED498A24D850EB10120817E30B7506@Colmatec004.COLMATEC.INT>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: How to identify USB-video-devices
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

> 
> -----Original Message-----
> From: video4linux-list-bounces@redhat.com
> [mailto:video4linux-list-bounces@redhat.com] On Behalf Of Carsten
> Meier Sent: 15 janvier 2009 10:34 To: Markus Rechberger
> Cc: video4linux-list@redhat.com
> Subject: Re: How to identify USB-video-devices
> 
> Am Thu, 15 Jan 2009 16:20:23 +0100
> schrieb "Markus Rechberger" <mrechberger@gmail.com>:
>   
> > On Thu, Jan 15, 2009 at 3:41 PM, Carsten Meier <cm@trexity.de>
> > wrote:  
> > > Hello list,
> > >
> > > we recently had a discussion on the pvrusb2-list on how to
> > > identify a video-device connected via USB from an userspace app.
> > > (Or more precisely on how to associate config-data with a
> > > particular device). This led to a patch which returned the
> > > device's serial-no. in v4l2_capability's bus_info field. This one
> > > has been rejected, but I really feel that this is the right way
> > > to go. Here's the thread:
> > > http://www.isely.net/pipermail/pvrusb2/2009-January/002091.html
> > >
> > > I think the meaning of the bus_info-field should be modified
> > > slightly for USB-devices to reflect its dynamic nature. At least a
> > > string that won't change on dis-/reconnect and
> > > standby/wake-up-cycles should be returned. If a device has a
> > > unique serial-no. it is a perfect candidate for this, if not, some
> > > USB-port-info should be returned that won't change if the device
> > > is connected to the same port through the same hub.
> > >
> > > What do you think?
> > > (BTW: I'm not a kernel-hacker, I'm writing this from the
> > > perspective of an app-developer)
> > >  
> >
> > write a few shellscripts and parse sysfs, or attach your application
> > to sysfs that it will
> > be notified if a device gets added. dbus is also a tip. no need to
> > hook up drivers
> > with some special things there.
> >
> > regards,
> > Markus  
> 
> But according to the docs, the bus_info-field is intended for the
> purpose of identifying particular devices. Other solutions may be
> possible, but they are much more complex and much more sensible to
> other kernel-changes. By using bus_info, there is a simple and clean
> solution that only depends on the V4L2-API and it also reflects the
> primary intention of the field.
> 
> Other USB-device-drivers aren't required to change to the new policy,
> their current bus_info-string (if implemented like in pvrusb2) changes
> on every reconnect and standby/wake-up-cycle and is of no use anyway
> for any app.
> 
> I really think that current behaviour is broken.
> 
> Regards,
> Carsten
>   



Am Thu, 15 Jan 2009 10:55:40 -0500
schrieb Jonathan Lafontaine <jlafontaine@ctecworld.com>:

> I think that generic devices (often cheapest price) do not identify
> themselves exactly as well known trademarks.
> 
> So you can identify kind of chip they use (empia 2860) but, the
> eeprom space usb chips identity have, remain the
> responsibility/regardless to the company who build the entire video
> usb board and not the empia or otherelse chip you ask information on.
> 
> You can identify the vendor (2 letters id)so, in this situation,
> contact the vendor/company to get more precision about.
> 
> Try lsusb in terminal.
> 
> Hope this reply is usefull. Best regards, cheers  

Hi,

I think you misunderstood me or I misunderstood your message. :)

I don't want to recognize a particual device type (or brand), but I
want to distinguish two identical devices connected to a system.

Here comes the full story (again):

I'm currently writing a tool to store and apply configuration settings
like channel-frequencies and control-values. These should all be kept
in an XML-file which has a section for every v4l-device in the system.
Those sections are associated with a particular device by storing the
card- and bus_info-fields of the v4l2_capability-struct in the XML-file.

This works pretty well for PCI-cards, because the bus_info field never
changes (assuming you don't put the card in a different PCI-slot). This
use-case is exactly the one the bus_info field was made for.

But with USB things changed a bit. Now (at least for pvrusb2) a string
like "usb 7-2 address 6" is reported in bus_info. This is not
tragic, but after a disconnect-reconnect and even after a
standby-wakeup-cycle it reports a different string by increasing the
address no. Now I ask: Does anybody like to reconfigure an app just
because the laptop was idle and went to stand-by-mode?

Storing device-file-names is also not an option because they are
created dynamicly.

I can't say much about the sysfs-approach because I don't know much
about it. But it seems more complex and why depend on an external
mechanism if the V4L2-API already defines one?

Regards,
Carsten

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
