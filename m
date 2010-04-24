Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:54273 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0DXV7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 17:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <20100424212353.GB11879@hardeman.nu>
References: <20100402102011.GA6947@hardeman.nu>
	 <20100407093205.GB3029@hardeman.nu>
	 <z2hbe3a4a1004231040uce51091fnf24b97de215e3ef1@mail.gmail.com>
	 <o2l9e4733911004231106te8b727e9nfa75bfd9c73e9506@mail.gmail.com>
	 <1272061228.3089.8.camel@palomino.walls.org>
	 <20100424052254.GB3101@hardeman.nu>
	 <m2j9e4733911004240535k4b14d64fu940f5dff17837b20@mail.gmail.com>
	 <20100424141510.GA3070@hardeman.nu>
	 <y2h9e4733911004240807wfa6b0e79q8deb18c425484b6f@mail.gmail.com>
	 <20100424212353.GB11879@hardeman.nu>
Date: Sat, 24 Apr 2010 17:59:46 -0400
Message-ID: <v2z9e4733911004241459jd637bec0g5d76b24a611c3863@mail.gmail.com>
Subject: Re: [PATCH 00/15] ir-core: Several improvements to allow adding LIRC
	and decoder plugins
From: Jon Smirl <jonsmirl@gmail.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 24, 2010 at 5:23 PM, David Härdeman <david@hardeman.nu> wrote:
> I don't care either way. Get the input maintainers to agree and I'll
> happily write patches that follow that approach (writing TX data to the
> input dev will also have to be supported).
>
> The only real problem I see is if we implement > 1 input device per
> rc/ir device (which I think we should do - each logical remote should
> have a separate keytable and input device).

I forgot about the many to 1 aspect of the receiver. You should have
started off with this point and I would have shut up, DRM does not
have many to 1 mappings. My radio receivers show up as network
devices. So I have multiple devices too.

I don't think we want a 'rc' device. The IR transceiver should be an
'ir' device. My radios are already 'net' devices. So my complaint
really is, I don't want an three devices - input, rc and net.

-- 
Jon Smirl
jonsmirl@gmail.com
