Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab0GEQJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 12:09:29 -0400
Message-ID: <4C3203B2.9050401@redhat.com>
Date: Mon, 05 Jul 2010 13:09:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: eduardo.valentin@nokia.com
CC: Jarkko Nikula <jhnikula@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] si4713: Fix oops when si4713_platform_data is marked
 as __initdata
References: <1274029466-17456-1-git-send-email-jhnikula@gmail.com>	<20100518125527.GB4265@besouro.research.nokia.com> <20100518162445.5399d077.jhnikula@gmail.com>
In-Reply-To: <20100518162445.5399d077.jhnikula@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-05-2010 10:24, Jarkko Nikula escreveu:
> On Tue, 18 May 2010 15:55:27 +0300
> Eduardo Valentin <eduardo.valentin@nokia.com> wrote:
> 
>> I'm probably fine with this patch, and the driver must check for the pointer
>> before using it, indeed.
>>
>> But, I'm a bit skeptic about marking its platform data as __initdata. Would it make sense?
>> What happens if driver is built as module and loaded / unload / loaded again?
>>
>> Maybe the initdata flag does not apply in this case. Not sure (and not tested the above case).
>>
> Yep, it doesn't work or make sense for modules if platform data is
> marked as __initdata but with built in case it can save some bytes which
> are not needed after kernel is initialized.
> 
> Like with this driver the i2c_bus number and i2_board_info data are not
> needed after probing but only pointer to set_power must be preserved.
> 

Hi Eduardo,

This patch is still on my queue. It is not clear to me what "proably fine" means...
Please ack or nack on it for me to move ahead ;)

Cheers,
Mauro



