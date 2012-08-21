Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38585 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2HUToS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 15:44:18 -0400
Date: Tue, 21 Aug 2012 21:44:09 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sean Young <sean@mess.org>, Jarod Wilson <jwilson@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [media] rc-core: move timeout and checks to lirc
Message-ID: <20120821194409.GB4993@hardeman.nu>
References: <20120816221514.GA26546@pequod.mess.org>
 <502D7E62.9040204@redhat.com>
 <20120820213659.GC14636@hardeman.nu>
 <5032B407.8030407@redhat.com>
 <CAGoCfizxSnUgC2Ka5uz3_gXaFf65057kt+EBNz7WassEvVsDHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGoCfizxSnUgC2Ka5uz3_gXaFf65057kt+EBNz7WassEvVsDHg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 20, 2012 at 06:10:16PM -0400, Devin Heitmueller wrote:
>On Mon, Aug 20, 2012 at 6:02 PM, Mauro Carvalho Chehab
><mchehab@redhat.com> wrote:
>> So, IMO, it makes sense to have a "high end" API that accepts
>> writing keystrokes like above, working with both "raw drivers"
>> using some kernel IR protocol encoders, and with devices that can
>> accept "processed" keystrokes, like HDMI CEC.
>
>It might also make sense to have a third mode for devices that support
>high level protocols such as RC5/NEC but you want to leverage the very
>large existing LIRC database of remote controls.  The device would
>advertise all the modes it supports (RC5/NEC/RC6/whatever), and from
>there it can accept the actual RC codes instead of a raw waveform.

That should be pretty trivial with the API I suggested - i.e. that
userspace is expected to do an ioctl first to get the bitmask of
supported modes. This would just be another TX mode.


-- 
David Härdeman
