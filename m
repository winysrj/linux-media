Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35808 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbcJDQLv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2016 12:11:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
 <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Date: Tue, 4 Oct 2016 18:11:50 +0200
Message-ID: <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
Subject: Re: Problem with VMAP_STACK=y
To: Jiri Kosina <jikos@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-10-04 15:26 GMT+02:00 Jiri Kosina <jikos@kernel.org>:
> On Tue, 4 Oct 2016, J=C3=B6rg Otte wrote:
>
>> With kernel 4.8.0-01558-g21f54dd I get thousands of
>> "dvb-usb: bulk message failed: -11 (1/0)"
>> messages in the logs and the DVB adapter is not working.
>>
>> It tourned out the new config option VMAP_STACK=3Dy (which is the defaul=
t)
>> is the culprit.
>> No problems for me with VMAP_STACK=3Dn.
>
> I'd guess that this is EAGAIN coming from usb_hcd_map_urb_for_dma() as th=
e
> DVB driver is trying to perform on-stack DMA.
>
> Not really knowing which driver exactly you're using, I quickly skimmed
> through DVB sources, and it turns out this indeed seems to be rather
> common antipattern, and it should be fixed nevertheless. See
>
>         cxusb_ctrl_msg()
>         dibusb_power_ctrl()
>         dibusb2_0_streaming_ctrl()
>         dibusb2_0_power_ctrl()
>         digitv_ctrl_msg()
>         dtt200u_fe_init()
>         dtt200u_fe_set_frontend()
>         dtt200u_power_ctrl()
>         dtt200u_streaming_ctrl()
>         dtt200u_pid_filter()
>
> Adding relevant CCs.
>
> --
> Jiri Kosina
> SUSE Labs

Thanks for the quick response.
Drivers are:
dvb_core, dvb_usb, dbv_usb_cynergyT2


J=C3=B6rg
