Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35307 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932448Ab0FERYx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jun 2010 13:24:53 -0400
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
From: Andy Walls <awalls@md.metrocast.net>
To: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jarod@redhat.com,
	linux-media@vger.kernel.org,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
In-Reply-To: <AANLkTikr49GiEcENLb6n1shtCkWrDhMXoYh4VJ4IPtdQ@mail.gmail.com>
References: <BQCH7Bq3jFB@christoph> <4C09482B.8030404@redhat.com>
	 <AANLkTikr49GiEcENLb6n1shtCkWrDhMXoYh4VJ4IPtdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 13:24:47 -0400
Message-ID: <1275758687.3618.191.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-06-04 at 14:57 -0400, Jon Smirl wrote:
> On Fri, Jun 4, 2010 at 2:38 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em 04-06-2010 12:51, Christoph Bartelmus escreveu:
> >> Hi Mauro,
> >>
> >> on 04 Jun 10 at 01:10, Mauro Carvalho Chehab wrote:
> >>> Em 03-06-2010 19:06, Jarod Wilson escreveu:
> >> [...]
> >>>> As for the compat bits... I actually pulled them out of the Fedora kernel
> >>>> and userspace for a while, and there were only a few people who really ran
> >>>> into issues with it, but I think if the new userspace and kernel are rolled
> >>>> out at the same time in a new distro release (i.e., Fedora 14, in our
> >>>> particular case), it should be mostly transparent to users.
> >>
> >>> For sure this will happen on all distros that follows upstream: they'll
> >>> update lirc to fulfill the minimal requirement at Documentation/Changes.
> >>>
> >>> The issue will appear only to people that manually compile kernel and lirc.
> >>> Those users are likely smart enough to upgrade to a newer lirc version if
> >>> they notice a trouble, and to check at the forums.
> >>
> >>>> Christoph
> >>>> wasn't a fan of the change, and actually asked me to revert it, so I'm
> >>>> cc'ing him here for further feedback, but I'm inclined to say that if this
> >>>> is the price we pay to get upstream, so be it.
> >>
> >>> I understand Christoph view, but I think that having to deal with compat
> >>> stuff forever is a high price to pay, as the impact of this change is
> >>> transitory and shouldn't be hard to deal with.
> >>
> >> I'm not against doing this change, but it has to be coordinated between
> >> drivers and user-space.
> >> Just changing lirc.h is not enough. You also have to change all user-space
> >> applications that use the affected ioctls to use the correct types.
> >> That's what Jarod did not address last time so I asked him to revert the
> >> change.
> >
> > For sure coordination between kernel and userspace is very important. I'm sure
> > that Jarod can help with this sync. Also, after having the changes implemented
> > on userspace, I expect one patch from you adding the minimal lirc requirement
> > at Documentation/Changes.
> 
> Keep the get_version() ioctl stable. The first thing user space would
> do it call the get_version() ioctl. If user space doesn't support the
> kernel version error out and print a message with the url of the
> project web site and tell the user to upgrade.
> 
> If you have the ability to upgrade your kernel you should also have
> the ability to upgrade user space too. I'm no fan of keeping backwards
> compatibility code around. It just becomes piles of clutter that
> nobody maintains. A reliable mechanism to determine version mismatch
> is all that is needed.
> 
> PS - I really don't like having to fix bug reports in compatibility
> code. That is an incredible waste of support time that can be easily
> fixed by upgrading the user.
> 
> >
> >> And I'd also like to collect all other change request to the API
> >> if there are any and do all changes in one go.
> >
> > You and Jarod are the most indicated people to point for such needs. Also, Jon
> > and David may have some comments.
> >
> > From my side, as I said before, I'd like to see a documentation of the defined API bits,
> > and the removal of the currently unused ioctls (they can be added later, together
> > with the patches that will introduce the code that handles them) to give my final ack.
> >
> > From what I'm seeing, those are the current used ioctls:
> >
> > +#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, unsigned long)
> >
> > +#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, unsigned long)
> 
> Has this been set into stone yet? if not a 64b word would be more future proof.
> Checking the existence of features might be better as sysfs
> attributes. You can have as many sysfs attributes as you want.
> 
> > +#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, uint32_t)
> > +#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, uint32_t)
> >
> > There is also a defined LIRC_GET_REC_MODE that just returns a mask of GET_FEATURES
> > bits, and a LIRC_SET_REC_MODE that do nothing.
> >
> > I can't comment about the other ioctls, as currently there's no code using them, but
> > it seems that some of them would be better implemented as ioctl, like the ones that
> > send carrier/burst, etc.

So I'll comment on the LIRC ioctl()'s that cx23885 driver/cx23888-ir.c
implementation will support.  These ioctl()'s are from the
lirc-0.8.7pre1 CVS snapshot I just downloaded.


LIRC_GET_FEATURES
The driver will support this.

LIRC_GET_SEND_MODE
LIRC_GET_REC_MODE
The driver will support these.  It will return hard-coded values, as the
hardware and cx23888-ir.c only deal with raw pulse time values because
there is no hardware decoding.

LIRC_SET_SEND_MODE
LIRC_SET_REC_MODE
The driver won't support these.  The CX23888 only supports 1 mode for Tx
and 1 mode for Rx (namely raw pulses), but these ioctl()'s are marked
obsolete anyway.

LIRC_GET_SEND_CARRIER
LIRC_GET_REC_CARRIER
The driver will support these.  It will return that actual value the
hardware is working with.  For the CX23888, that may not be *exactly*
what the user set, but instead the closest value the hardware could be
set to, given what the user requested.  (e.g. 35,904 Hz when 36,000 Hz
was requested). 

LIRC_SET_SEND_CARRIER
The driver will support this.  Setting it is only valid when transmit
modulation is enabled.  It will be set in hardware to a value as close
as possible to the user's desired setting, but it is not guaranteed to
be exact (e.g. 35,904 Hz when 36,000 Hz was requested)
If the driver is set for basedband transmit, then it is ignored.


LIRC_SET_REC_CARRIER
LIRC_SET_REC_CARRIER_RANGE
The driver will support these.  Setting them is only valid when receive
demodulation is enabled.  They will be set in hardware to values as
close as possible to the user's desired settings, but not guaranteed to
be exact.  If setting REC_CARRIER, a default CARRIER_RANGE window will
be set in the hardware.  If setting both, they really should be set
atomically, as the possible window settings in hardware really depend on
the desired receive carrier center freq.
If receive demodulation is disabled, the values are ignored.



LIRC_GET_SEND_DUTY_CYCLE
LIRC_SET_SEND_DUTY_CYCLE
The driver will support these.  The value returned for GET will be what
the hardware is set to, given what the user requested.  That value may
not be exactly what the user asked for.  The CX23888 hardware supports
settings of n/16 * 100%  for n in [1,16].  Note, that setting a value of
100% is *not* the same as setting baseband transmit modulation as far as
the hardware is concerned (although the physical effect may be the
same).


LIRC_GET_REC_DUTY_CYCLE
LIRC_SET_REC_DUTY_CYCLE
LIRC_SET_REC_DUTY_CYCLE_RANGE
The driver won't support these.  There is no hardware support.


LIRC_GET_REC_RESOLUTION
The driver will support this.  For CX23888 hardware, the value returned
is not a constant, as the current pulse measurment resolution depends on
how the hardware is set up.
The driver could also support this for Tx as well, but there is no lirc
ioctl().


LIRC_GET_MIN_TIMEOUT
LIRC_GET_MAX_TIMEOUT
The driver will support this.  With Rx demodulation enabled, the value
returned will be the same for both MIN and MAX, and it is a function of
the selected carrier frequency.  With Rx demodulation disabled (baseband
pulse reception), two distinct values can be returned: MIN_TIMEOUT would
be the one that corresponds to settings for maximum measurement
resolution of pulses, MAX_TIMEOUT corresponds to to settings for minimum
measurment resolution of pulses.


LIRC_SET_REC_TIMEOUT
The driver will support this.  The current cx23888-ir.c code implements
it as setting the maximum measurable pulse width when RX demodulation is
disabled (baseband pulses being received.).  Note that this setting
affects the Rx measurment resolution.  When Rx demodulation is enabled,
the receive tiomeout is determined by the Rx carrier setting and this
setting will be ignored.
Currently, since the cx23888-ir.c implementation is interrupt driven,
the driver does not have code to support a setting of 0.  To me a
setting of 0 implies polling the Rx hardware FIFO.


(I'll note the baseband Rx reception is not moot for some TV cards.
Some cards with an CX23888, like the HVR-1850, only provide baseband Rx
pulses to the CX23888 receive circuitry.  Apparently such cards have
external components integrating the received carrier pulses into
baseband pulses.  For these cards, the CX23888 only sees baseband pulses
on receive and Rx demodulation must remain disabled in normal
operation.)


LIRC_SET_REC_TIMEOUT_REPORTS
The driver will support this.  When the width measurment timer expires,
a special measurement value is put on the Rx FIFO indicating a timeout
(in band signaling).  The driver uses this internally and can pass the
value along if requested.


LIRC_GET_MIN_FILTER_PULSE
LIRC_GET_MAX_FILTER_PULSE
The driver will support these.  The CX23888 has a hardware glith filter
for pulses.  It also has a hardware setting for inverting polarity of
the receive signal before the glitch filter, so the cx2888-ir.c will be
able to ensure the glitch filer is always applied to pulses and never
spaces.  The values returned for this are not constant but depend on the
carrier frequency if Rx demodulation is enabled, or the pulse measurment
resolution if Rx demodulation is disabled.


LIRC_GET_MIN_FILTER_SPACE
LIRC_GET_MAX_FILTER_SPACE
The driver for the CX23888 will not support these.  Older Conexant IR
core implementations don't have hardware to invert incoming Rx signals,
so it could be the case that the hardware glitch filter is applied to
spaces instead of pulses depending on how the TV card is wired up.
Polarity inversion is done in software after the glitch filter for those
older chips.  There are no IR drivers currently in kernel for these
older chips


LIRC_SET_REC_FILTER_PULSE
LIRC_SET_REC_FILTER
The driver will support these.  They will affect the pulse glitch
filter.

LIRC_SET_REC_FILTER_SPACE
The driver will not support this.

LIRC_GET_LENGTH
The driver will not support this.

LIRC_SET_TRANSMITTER_MASK
The driver will not support this.  The CX23888 can support up to two
output LEDs, but I doubt I'll ever see a video card wired up to do such.
Also the current cx23888-ir.c doesn't have code to support it.

LIRC_SET_MEASURE_CARRIER_MODE
The driver will not support this.

LIRC_NOTIFY_DECODE
I'm not sure what this one is for.  If it means send up a notification
when the hardware pulse measurment times out (so start decoding), then
the driver can support it.


LIRC_SETUP_START
LIRC_SETUP_END
The driver will support these (I beleive I asked for them).  To change
anything with the transmitter or receiver on the CX23888, the
transmitter or receiver (respectively) needs to be disabled, have its
interrupts masked, the setting made, the interrupts unmasked, and the
unit reenabled.  These ioctl()'s would allow setting parameters in a
batch, which is more efficient and probably smoother than operating with
patial settings where one could possibly get interrupts unexpectedly.


What I don't see in the LIRC ioctl() set are:

1. ioctl()'s to enable/disable Tx modulation onto a carrier and Rx
demodulation from a carrier.

2. an ioctl() to enable hardware loopback or other test modes.

I'm not sure if they would be useful beyond testing anyway.


> If the ioctls haven't been implemented, leave them as comments in the
> h file. Don't implement them with stubs. Stubs will set the parameters
> into stone and the parameters may be wrong.
> 
> > One discussion that may be pertinent is if we should add ioctls for those controls,
> > or if it would be better to just add sysfs nodes for them.
> >
> > As all those ioctls are related to config stuff, IMO, using sysfs would be better, but
> > I haven't a closed opinion about that matter.


I personally don't like sysfs:

Cons of sysfs:
- it's linux specific  (Linux's own version of vendor lock-in: Where's
the standards document?)
- the hierarchy can easily get too deep
- difficult to set multiple things atomically
- Oops'es from races with sysfs nodes that appears and disappear and
user space has managed to open it before it disappears.  (firmware
loading process is an example)

Pros of sysfs
- long term scalability for linux kernel configuration
- manipulated with human readable, and typeable, strings.

Maybe it's just that I've been playing with Unix systems since 1989 and
am very used to ioctl().



However, in my experience, the best interfaces are the ones with the
most complete documentation. :)


> In general sysfs is used to set options that are static or only change
> infrequently.
> 
> If the parameter is set on every request, use an IOCTL.

That makes sense to me.

Regards,
Andy



