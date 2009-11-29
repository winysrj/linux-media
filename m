Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:5614 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbZK2Uoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 15:44:34 -0500
MIME-Version: 1.0
In-Reply-To: <m3ocml6ppt.fsf@intrepid.localdomain>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259450815.3137.19.camel@palomino.walls.org>
	 <m3ocml6ppt.fsf@intrepid.localdomain>
Date: Sun, 29 Nov 2009 15:44:36 -0500
Message-ID: <9e4733910911291244p364b328fm3a76ded4e4cd8603@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 3:27 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> 1. Do we agree that a lirc (-style) kernel-user interface is needed at
>   least?
>
> 2. Is there any problem with lirc kernel-user interface?

Can you consider sending the raw IR data as a new evdev message type
instead of creating a new device protocol?
evdev protects the messages in a transaction to stop incomplete
messages from being read.

You might also want to use evdev capabilities to describe what the
hardware can do. These were the capabilities I had made up:

#define IR_CAP_RECEIVE_BASEBAND 0
#define IR_CAP_RECEIVE_36K 1
#define IR_CAP_RECEIVE_38K 2
#define IR_CAP_RECEIVE_40K 3
#define IR_CAP_RECEIVE_56K 4
#define IR_CAP_SEND_BASEBAND 5
#define IR_CAP_SEND_36K 6
#define IR_CAP_SEND_38K 7
#define IR_CAP_SEND_40K 8
#define IR_CAP_SEND_56K 9
#define IR_CAP_XMITTER_1 10
#define IR_CAP_XMITTER_2 11
#define IR_CAP_XMITTER_3 12
#define IR_CAP_XMITTER_4 13
#define IR_CAP_RECEIVE_RAW 14
#define IR_CAP_SEND_RAW 15


> If the answer for #1 is "yes" and for #2 is "no" then perhaps we merge
> the Jarod's lirc patches (at least the core) so at least the
> non-controversial part is done?
>
> Doing so doesn't block improving input layer IR interface, does it?
> --
> Krzysztof Halasa
>



-- 
Jon Smirl
jonsmirl@gmail.com
