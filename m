Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab2GIIms (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 04:42:48 -0400
Message-ID: <4FFA999B.7070000@redhat.com>
Date: Mon, 09 Jul 2012 10:43:07 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: martin-eric.racine@iki.fi, 677533@bugs.debian.org,
	linux-media@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
References: <20120614162609.4613.22122.reportbug@henna.lan> <20120614215359.GF3537@burratino> <CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com> <20120616044137.GB4076@burratino> <1339932233.20497.14.camel@henna.lan> <CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com> <4FF9CA30.9050105@redhat.com> <20120708203303.26d13474@armhf>
In-Reply-To: <20120708203303.26d13474@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/08/2012 08:33 PM, Jean-Francois Moine wrote:
> On Sun, 08 Jul 2012 19:58:08 +0200
> Hans de Goede <hdegoede@redhat.com> wrote:
>
>> Hmm, this is then likely caused by the new isoc bandwidth negotiation code
>> in 3.2, unfortunately the vc032x driver is one of the few gspca drivers
>> for which I don't have a cam to test with. Can you try to build your own
>> kernel from source?
>
> Hi Martin-Éric,
>
> Instead of re-building the gspca driver from a kernel source, you may
> try the gspca test tarball from my web site
> 	http://moinejf.free.fr/gspca-2.15.18.tar.gz

That is a good option too and easier then building a whole new kernel,
but:

> It contains most of the bug fixes, including the one about the
> bandwidth problem.

Right, but the problem with the vc032x driver is that there no bandwidth
related bugfix for it yet, which is why I asked Martin-Éric, not only
to build a new gspca driver from source, but also to try some modifications.

Martin-Éric,

Building the gspca test-tarbal also is a good way to test this:
http://moinejf.free.fr/gspca-2.15.18.tar.gz

But once you've confirmed the problem still happens with that version
you will still need to try the changes I suggested to gspca.c to help
us confirm that this is a bandwidth issue and try to come up with a fix.

Thanks & Regards,

Hans
