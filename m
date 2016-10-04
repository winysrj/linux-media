Return-path: <linux-media-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55452 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751754AbcJDN15 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Oct 2016 09:27:57 -0400
Date: Tue, 4 Oct 2016 15:26:28 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        linux-media@vger.kernel.org
Subject: Re: Problem with VMAP_STACK=y
In-Reply-To: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 4 Oct 2016, Jörg Otte wrote:

> With kernel 4.8.0-01558-g21f54dd I get thousands of
> "dvb-usb: bulk message failed: -11 (1/0)"
> messages in the logs and the DVB adapter is not working.
> 
> It tourned out the new config option VMAP_STACK=y (which is the default)
> is the culprit.
> No problems for me with VMAP_STACK=n.

I'd guess that this is EAGAIN coming from usb_hcd_map_urb_for_dma() as the 
DVB driver is trying to perform on-stack DMA.

Not really knowing which driver exactly you're using, I quickly skimmed 
through DVB sources, and it turns out this indeed seems to be rather 
common antipattern, and it should be fixed nevertheless. See

	cxusb_ctrl_msg()
	dibusb_power_ctrl()
	dibusb2_0_streaming_ctrl()
	dibusb2_0_power_ctrl()
	digitv_ctrl_msg()
	dtt200u_fe_init()
	dtt200u_fe_set_frontend()
	dtt200u_power_ctrl()
	dtt200u_streaming_ctrl()
	dtt200u_pid_filter()
	
Adding relevant CCs.

-- 
Jiri Kosina
SUSE Labs
