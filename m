Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:9211 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZDTHDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 03:03:06 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1230197ywb.1
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 00:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ueivouqsu.wl%morimoto.kuninori@renesas.com>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
	 <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
	 <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com>
	 <ueivouqsu.wl%morimoto.kuninori@renesas.com>
Date: Mon, 20 Apr 2009 16:03:04 +0900
Message-ID: <aec7e5c30904200003i75f2195bic0466cb7c2fc1923@mail.gmail.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
From: Magnus Damm <magnus.damm@gmail.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

On Mon, Apr 20, 2009 at 9:12 AM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
>
> Hi Magnus
>
>> >> > http://www.open-technology.de/download/20090415/ based on linux-next
>> >> > history branch, commit ID in 0000-base file. Don't be surprised, that
>> >> > patch-set also contains a few not directly related patches.
>> >>
>> >> Testing on Migo-R board with 2.6.30-rc2-git-something and the
>> >> following cherry-picked patches:
>> >>
>> >> 0007-driver-core-fix-driver_match_device.patch
>> >> 0033-soc-camera-host-driver-cleanup.patch
>> >> 0034-soc-camera-remove-an-extra-device-generation-from-s.patch
>> >> 0035-soc-camera-simplify-register-access-routines-in-mul.patch
>> >> and part of 0036 (avoiding rejects, ap325 seems broken btw)
>> >
>> > Have I broken it or is it unrelated?
>
> I don't know about current 2.6.30-rc2 git.
> But when I used 2.6.30-rc1, It doesn't work either.

Thanks for your suggestions. I've updated my tree after the weekend
and linux-2.6 git
d91dfbb41bb2e9bdbfbd2cc7078ed7436eab027a is working just fine.

So 2.6.30-rc seems ok on Migo-R at least. A good first step. =)

/ magnus
