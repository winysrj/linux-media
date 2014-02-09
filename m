Return-path: <linux-media-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752074AbaBIUDD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 15:03:03 -0500
Message-ID: <52F7DEF4.3050006@nod.at>
Date: Sun, 09 Feb 2014 21:03:00 +0100
From: Richard Weinberger <richard@nod.at>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 19/28] Remove SI4713
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-20-git-send-email-richard@nod.at> <52F7D363.2080108@xs4all.nl>
In-Reply-To: <52F7D363.2080108@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 09.02.2014 20:13, schrieb Hans Verkuil:
> On 02/09/2014 07:47 PM, Richard Weinberger wrote:
>> The symbol is an orphan, get rid of it.
> 
> NACK.
> 
> It's not an orphan, it's a typo. It should be I2C_SI4713.
> 
> Paul, Richard, let me handle this. I'll make a patch for this tomorrow (I believe
> there was a report about a missing I2C dependency as well) and make sure it ends
> up in a pull request for 3.14.

This is perfectly fine. Thanks for sorting this out!

Thanks,
//richard
