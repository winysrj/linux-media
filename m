Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51789 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0IPLcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 07:32:09 -0400
Message-ID: <d1cd45c6d862e80252cf82047455e9b6.squirrel@www.hardeman.nu>
In-Reply-To: <20100916052245.GC23299@redhat.com>
References: <20100916051932.GA23299@redhat.com>
    <20100916052245.GC23299@redhat.com>
Date: Thu, 16 Sep 2010 13:32:07 +0200 (CEST)
Subject: Re: [PATCH 2/4] imon: split mouse events to a separate input dev
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Jarod Wilson" <jarod@redhat.com>
Cc: linux-media@vger.kernel.org,
	"Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
	"Anders Eriksson" <aeriksson@fastmail.fm>,
	"Anssi Hannula" <anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, September 16, 2010 07:22, Jarod Wilson wrote:
> This is a stab at separating the mouse (and front panel/knob) events
> out to a separate input device. This is necessary in preparation for
> the next patch which makes the rc-core input dev opaque to rc
> drivers.
>
> I can't verify the correctness of the patch beyond the fact that it
> compiles without warnings. The driver has resisted most of my
> attempts at understanding it properly...for example, the double calls
> to le64_to_cpu() and be64_to_cpu() which are applied in
> imon_incoming_packet() and imon_panel_key_lookup() would amount
> to a bswab64() call, irregardless of the cpu endianness, and I think
> the code wouldn't have worked on a big-endian machine...
>
> Signed-off-by: David Härdeman <david@hardeman.nu>
>
> - Minor alterations to apply with minimal core IR changes
> - Use timer for imon keys too, since its entirely possible for the
>   receiver to miss release codes (either by way of another key being
>   pressed while the first is held or by the remote pointing away from
>   the recevier when the key is release. yes, I know, its ugly).

Where's the additional timer usage exactly? I can't see any in the patch...

-- 
David Härdeman

