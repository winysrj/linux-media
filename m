Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab3JGP0A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Oct 2013 11:26:00 -0400
Message-ID: <5252D276.3010004@redhat.com>
Date: Mon, 07 Oct 2013 17:25:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Alan Stern <stern@rowland.harvard.edu>
CC: Xenia Ragiadakou <burzalodowa@gmail.com>,
	linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: New USB core API to change interval and max packet size
References: <20131001204554.GB15395@xanatos> <Pine.LNX.4.44L0.1310021007110.1293-100000@iolanthe.rowland.org> <20131002183905.GG15395@xanatos>
In-Reply-To: <20131002183905.GG15395@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/02/2013 08:39 PM, Sarah Sharp wrote:
> On Wed, Oct 02, 2013 at 10:22:52AM -0400, Alan Stern wrote:

<snip>

>> We should consider this before rushing into a new API.
>
> Yes, I agree. :)  That's why I'd like to see some cases in the media
> drivers code where it could benefit from changing the interval or
> maxpacket size, so that we can see what use cases we have.  Mauro, can
> you point is to places in drivers that would need this?

Allow me to jump in here. As you may remember I pointed out the media
side of this in the ubs-mini summit during the 2nd plumbers conference
in Portland.

I don't know about any media drivers which want to change interval, but
it make sense that there are those who will want to do that too, esp in
the hid area.

I can give 2 examples who want to change the maxpacketsize in media
land. Both for quite old usb-1 webcam chipsets. The manufacturers of
these chip-sets decided that having X alt-settings was too limiting, so
they have only 2. Alt 0 with no isoc endpoints, and alt 1 with 1 isoc
endpoint with a maxpacketsize of 1023. This means that if these device
somehow end up sharing usb-1 bandwidth with anything else (through
say 1 single tt usb-2 hub) they eat up all the periodic bandwidth, or
try to and fail.

Technically these devices actually have an almost unlimited number of
alt-settings, as they have a register through which the maxpacketsize
they will actually use can be configured.

Since we don't always need the full 1000 (interval 1) * 1023 bytes /
second bandwidth their alt-setting 1 gives us, currently their drivers
employ the following hack:

alt = &gspca_dev->dev->actconfig->intf_cache[0]->altsetting[1];
alt->endpoint[0].desc.wMaxPacketSize = cpu_to_le16(packet_size);

Before calling usb_set_interface(), so that they can start streaming
successfully even though the full usb-1 bandwidth which their alt1
descriptor claims it needs is not available, at least on ohci and ehci
this hack has that result, not sure if it works for xhci too (I can test
if people are interested).

For people who want to actually see the code for this admittedly ugly
hack, see:

drivers/media/usb/gspca/xirlink_cit.c

and:

drivers/media/usb/gspca/stv06xx/stv06xx.c

Note that their are several other chipsets which have a maxpacketsize
register too. But their descriptors do properly contain multiple
alt-settings with different maxpacketsizes (for the benefit of the OS
I assume), so all we do their is simply write the current wMaxPacketSize
to the register see ie: drivers/media/usb/gspca/ov519.c at line 3500 ,
technically we could use the discussed functionality there too, to do
finer grained bandwidth management but I don't really see a need for this.

>
>> In particular, do we want to go around changing single endpoints, one
>> at a time?  Or do we want to change all the endpoints in an interface
>> at once?
>>
>> Given that a change to one endpoint may require the entire schedule to
>> be recomputed, it seems to make more sense to do all of them at once.
>> For example, drivers could call a routine to set the desired endpoint
>> parameters, and then the new parameters could take effect when the
>> driver calls usb_set_interface().
>
> I think it makes sense to change several endpoints, and then ask the
> host to recompute the schedule.  Perhaps the driver could issue several
> calls to usb_change_ep_bandwidth and then ask the USB core to update the
> host's schedule?
>
> I'm not sure that usb_set_interface() is the right function for the new
> parameters to take effect.  What if the driver is trying to modify the
> current alt setting?  Would they need to call usb_set_interface() again?

What the 2 media drivers in question currently do is:

1) Determine an optimal wMaxPacketSize for the resolution + framerate
userspace has selected (so one where we can actually reach the framerate
with no framedrop or image degradation due to over aggressive compression).
Also determine a minimum wMaxPacketSize, below which streaming simply
won't work reliabe, even with frame drop, etc.
2) Put the wMaxPacketSize in the intf_cache for the alt1 alt-setting
3) Try a usb_set_interface(dev, iface, 1)
4) If 3). fails, reduce wMaxPacketSize in the intf_cache for the alt1 alt-setting
by 100 bytes, until we hit the minimum, then goto 3, or bail if the last
try was with the minimum already.

They are basically doing the same as other webcam drivers, except that
other drivers determine an optimal and minimum alt-setting with which
to work and then try set_interface with alt-settings with decreasing
wMaxPacketSize, where as these drivers keep retrying with the same
alt-setting, while changing the wMaxPacketSize of that alt-setting.

So from a media (specifically webcam driver) pov, the suggested approach
of first calling usb_change_ep_bandwidth 1 or more times, and then calling
usb_set_interface makes a lot of sense.

Note that in the hid case however where we are likely talking about
cases where the descriptors say something stupid like "poll this mouse
8000 times / second", or "poll this joystick 1 / second", normally the
driver will not call usb_set_interface() at all, because these
devices normally have only 1 alt-setting (only alt0).

Still since this is a special case for quirk handling, I think it is
reasonable that drivers have to call usb_set_interface() after calling
usb_change_ep_bandwidth(), for the changes to go into effect.

>> In any case, the question about what to do when the interface setting
>> gets switched never really arises.  Each usb_host_endpoint structure is
>> referenced from only one altsetting.  If the driver wants the new
>> parameters applied to an endpoint in several altsettings, it will have
>> to change each altsetting separately.
>
> Ok, so it sounds like we want to keep the changes the endpoints across
> alt setting changes.

At a minimum we want to keep them until the first usb_set_interface call,
which comes automatically with the transaction like interface Alan suggested
(so the usb_change_ep_bandwidth() calls just store a value some where and are
otherwise nops).

This makes me realize that the original suggestion to just have a
usb_change_ep_bandwidth() call which would change just that one ep and
immediately apply the changes, is not usable for the webcam case, since
in some cases the usb_set_interface call can only succeed with the
modified wMaxPacketSize and/or interval, so we would never be able to
move cur_altsetting to alt-setting 1, and thus would never be able to
change the wMaxPacketSize in there.

TBH I don't see much reason to keep the changes beyond the first set_interface
call, nor do I see much reason not too (except on driver unbind). Implementation
wise it might be easiest to just keep the override values until the first
call. This could be as simple as an array with 30 wMaxPacketSize override
values, and 30 interval overrides to be applied at the first set_interface
call.

 > But we still want to reset the values after the driver unbinds, correct?

Yes we definitely want to reset the values after an unbind.

Regards,

Hans
