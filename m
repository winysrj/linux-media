Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab0BKP3X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 10:29:23 -0500
Message-ID: <4B742227.3000400@redhat.com>
Date: Thu, 11 Feb 2010 13:28:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Samuel Ortiz <samuel.ortiz@intel.com>
CC: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
References: <4B66C36A.4000005@pelagicore.com> <4B693ED7.4060401@redhat.com> <20100203100326.GA3460@sortiz.org> <4B694D69.1090201@redhat.com> <20100203123617.GF3460@sortiz.org> <4B69B12D.6030105@redhat.com> <20100204092846.GA3336@sortiz.org> <4B71D70A.6030806@pelagicore.com> <20100211152620.GA6025@sortiz.org>
In-Reply-To: <20100211152620.GA6025@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Samuel Ortiz wrote:

>> Now when the radio driver made it into the media tree, can I post an
>> updated MFD which defines these drivers too?
>> Is a complete MFD patch preferred, or just an incremental against the
>> last one?
> Since the mfd driver is currently merged into Mauro's tree, you should make
> incremental patches against it. At least that's how I'd take it in my tree.
> Mauro, do you agree ?

Yes.

Richard, just send me an incremental patch against my -git tree.

Cheers,
Mauro
