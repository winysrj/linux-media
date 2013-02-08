Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760252Ab3BHTGg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Feb 2013 14:06:36 -0500
Date: Fri, 8 Feb 2013 17:06:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	Benoit Thebaudeau <benoit.thebaudeau@advansee.com>,
	David Hardeman <david@hardeman.nu>,
	Trilok Soni <tsoni@codeaurora.org>,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RESEND] media: rc: gpio-ir-recv: add support for device
 tree parsing
Message-ID: <20130208170616.7a9d1800@redhat.com>
In-Reply-To: <CABJ1b_TSH+Cz_aScW7bX7=cMW0Yr-Pe7p_BUbeb0DSUBJA_BdA@mail.gmail.com>
References: <1359400023-25804-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1360137832-13086-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<51125F44.3050603@samsung.com>
	<5112905E.3020400@gmail.com>
	<20130208155707.65a0fbab@redhat.com>
	<CABJ1b_TSH+Cz_aScW7bX7=cMW0Yr-Pe7p_BUbeb0DSUBJA_BdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 8 Feb 2013 19:12:31 +0100
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> escreveu:

> On Fri, Feb 8, 2013 at 6:57 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em Wed, 06 Feb 2013 18:18:22 +0100
> > Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> escreveu:
> >> On 02/06/2013 02:48 PM, Sylwester Nawrocki wrote:
> >> > On 02/06/2013 09:03 AM, Sebastian Hesselbarth wrote:
> >> >> This patch adds device tree parsing for gpio_ir_recv platform_data and
> >> >> the mandatory binding documentation. It basically follows what we already
> >> >> have for e.g. gpio_keys. All required device tree properties are OS
> >> >> independent but optional properties allow linux specific support for rc
> >> >> protocols and maps.
> >> >>
> >> >> There was a similar patch sent by Matus Ujhelyi but that discussion
> >> >> died after the first reviews.
> >> >>
> >> >> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> >> >> ---
> >> > ...
> >> >> diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> >> >> new file mode 100644
> >> >> index 0000000..937760c
> >> >> --- /dev/null
> >> >> +++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> >> >> @@ -0,0 +1,20 @@
> >> >> +Device-Tree bindings for GPIO IR receiver
> >> >> +
> >> >> +Required properties:
> >> >> +  - compatible = "gpio-ir-receiver";
> >> >> +  - gpios: OF device-tree gpio specification.
> >> >> +
> >> >> +Optional properties:
> >> >> +  - linux,allowed-rc-protocols: Linux specific u64 bitmask of allowed
> >> >> +      rc protocols.
> >> >
> >> > You likely need to specify in these bindings documentation which bit
> >> > corresponds to which RC protocol.
> >> >
> >> > I'm not very familiar with the RC internals, but why it has to be
> >> > specified statically in the device tree, when decoding seems to be
> >> > mostly software defined ? I might be missing something though..
> >>
> >> Sylwester,
> >>
> >> I am not familiar with RC internals either. Maybe somebody with more
> >> insight in media/rc can clarify the specific needs for the rc subsystem.
> >> I was just transferring the DT support approach taken by gpio_keys to
> >> gpio_ir_recv as I will be using it on mach-dove/cubox soon.
> >
> > The allowed rc protocol field are there for devices with hardware IR
> > support, where only a limited set of remote protocols can be decoded.
> >
> > For software decoders RC_BIT_ALL is the proper setup. Users of course
> > can change it via sysfs at runtime, or a software decoder may be
> > disabled at compilation time by not selecting its CONFIG_* var.
> 
> Mauro,
> 
> thanks for the clarification! So for v2 of the patch, you all agree on removing
> linux,allowed-rc-protocols from device node properties?

Yes.
> 
> >> > Couldn't this be configured at run time, with all protocols allowed
> >> > as the default ?
> >>
> >> Actually, this is how the internal rc code works. If there is nothing
> >> defined for allowed_protocols it assumes that all protocols are supported.
> >> That is why above node properties are optional.
> >>
> >> About the binding documentation of allowed_protocols, rc_map, or the
> >> default behavior of current linux code, I don't think they will stay
> >> in-sync for long.
> >
> > Why not? The rc_map name is used either by Kernelspace or by Userspace,
> > in order to provide the IR keycode name that matches a given keytable.
> >
> > There's no plans to change it, even in the long term.
> 
> Actually, I wasn't referring to changing names or bitmasks but updating
> the binding documentation with new allowed protocols or supported map
> names.
> 
> For linux,rc-map-name property it should be enough to just write that it
> relates to linux rc subsystem rc_map name - how to actually
> set it to a useful name is documented in rc subsystem.

It should be one of the names that are there at include/media/rc-map.h.

> And if the
> property is not set at all, DT parsing in gpio_ir_recv assumes the
> subsystem (or gpio_ir_recv platform) default, IIRC "rc-none".

The right default should be "rc-empty", but please use the macro RC_MAP_EMPTY
instead.

> I'll respin a v2 without allowed-protocols property soon.
> 
> Sebastian


-- 

Cheers,
Mauro
