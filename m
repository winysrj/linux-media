Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:57697 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbZKWWZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 17:25:54 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com>
Date: Mon, 23 Nov 2009 23:25:57 +0100
In-Reply-To: <4B0A81BF.4090203@redhat.com> (Mauro Carvalho Chehab's message of
	"Mon, 23 Nov 2009 10:36:15 -0200")
Message-ID: <m3aaycri8a.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I though about it a bit - my idea:

1. Receivers that can only decode their own remote controllers.
   The present code (saa713x etc) can stay mostly unchanged. I'd only
   verify that 7 bits (or whatever the number is) is enough for all
   cases. The ioctl() should stay unchanged. That means keyboard-like
   input layer interface.


2. Receivers that can be programmed to receive different codes, and/or
   which simply generate IRQ on space/mark changes. They would use a new
   ioctl() instead:

int set_rc_mapping_ioctl(void *data ...)

data should be:
	u32 protocol1;
	u32 length1;
	u32 protocol2;
        u32 length2;
        ...
        u32 protocol_last;
        u32 length_last;
        (u32) 0.

The protocol data would follow (after all proto/length fields to avoid
alignment issues, but that's a detail of course).

For example, RC5. It uses 1 start bit (formerly 2 bits), 1 "toggle" bit,
5 address bits (group code) and 7 command bits (formerly 6 bits).
Each key would be represented by u16, or maybe by a couple of u8.
A "discard repeated" (perhaps inverted) bit should be included. Of
course, the "symbolic" key code should be included for each "scan" code.

Maybe:  u8 address_and_discard_repeated_bit;
        u8 command_value;
        u8 symbolic_key_code;
repeated as required.

Protocol2 would follow protocol1 etc. (alignment issues). The driver
could see this info (for example, to program hardware to receive a
specific protocol) and then it should pass it to the generic
lirc_set_mapping() routine.

I'd also add separate trivial space/mark protocol, for debugging etc.
Maybe:  u8 key_code_for_space;
        u8 key_code_for_mark;
Maybe specifying length = 0 (meaning constant "key" codes) would be
enough? I think the "key" code should also specify some time stamp (or
pulse length).



Interface to the sensor driver:
The driver should register an IRQ called on both (preferably) edges of
the input signal. Basically it should only register IRQ and do:

irqreturn_t xxx_irq()
{
	ack_irq_as_usual_etc();
        if (input_signal->changed_state) /* really for us */
		lirc_signal_state_change(input_signal->current_state);
}

The sensor driver would not know about the protocols etc. unless it
needs to e.g. program the hardware.

The middle layer (some sort of a library, and module) would interface to
the userspace (ioctl passed by the driver, input interface) and to the
hw driver. It would have to enable and call the required protocol
decoders (based on the keymap loaded).
-- 
Krzysztof Halasa
