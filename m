Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934310Ab3BSSxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:12 -0500
Date: Tue, 19 Feb 2013 15:53:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mr Goldcove <goldcove@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Wrongly identified easycap em28xx
Message-ID: <20130219155303.25c5077a@redhat.com>
In-Reply-To: <5123C849.6080207@googlemail.com>
References: <512294CA.3050401@gmail.com>
	<51229C2D.8060700@googlemail.com>
	<5122ACDF.1020705@gmail.com>
	<5123ACA0.2060503@googlemail.com>
	<20130219153024.6f468d43@redhat.com>
	<5123C849.6080207@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Feb 2013 19:45:29 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> > I don't like the idea of merging those two entries. As far as I remember
> > there are devices that works out of the box with
> > EM2860_BOARD_SAA711X_REFERENCE_DESIGN. A change like that can break
> > the driver for them.
> 
> As described above, there is a good chance to break devices with both
> solutions.
> 
> What's your suggestion ? ;-)
> 

As I said, just leave it as-is (documenting at web) or to use the AC97
chip ID as a hint. This works fine for devices that don't come with
Empiatech em202, but with something else, like the case of the Realtek
chip found on this device. The reference design for sure uses em202.

-- 

Cheers,
Mauro
