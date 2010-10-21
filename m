Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130Ab0JUNos (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 09:44:48 -0400
Message-ID: <4CC043CC.5020809@redhat.com>
Date: Thu, 21 Oct 2010 11:44:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: Srinivasa.Deevi@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] mceusb: add support for cx231xx-based IR (e. g. Polaris)
References: <cover.1287442245.git.mchehab@redhat.com> <20101018205257.46cf3e8c@pedra> <20101019175029.GA16942@redhat.com>
In-Reply-To: <20101019175029.GA16942@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-10-2010 15:50, Jarod Wilson escreveu:
> On Mon, Oct 18, 2010 at 08:52:57PM -0200, Mauro Carvalho Chehab wrote:
>> For now, it adds support for Conexant EVK and for Pixelview.
>> We should probably find a better way to specify all Conexant
>> Polaris devices, to avoid needing to repeat this setup on
>> both mceusb and cx231xx-cards.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Looks good to me.
> 
> Reviewed-by: Jarod Wilson <jarod@redhat.com>
> 
Thanks!

I'll remove the Pixelview ID from it, as it has an extra chip for IR
decoding, so, we'll likely need to do something else for IR to work on it.
So, I'm keeping, for now, just the Conexant EVK USB ID. Probably other
cx231xx non-ISDB-T devices should work via mceusb as well.

Thanks,
Mauro
