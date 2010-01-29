Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0A2Sc5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 13:32:57 -0500
Message-ID: <4B6329CA.2030005@infradead.org>
Date: Fri, 29 Jan 2010 16:32:42 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: David Henig <dhhenig@googlemail.com>,
	Francis Barber <fedora@barber-family.id.au>,
	leandro Costantino <lcostantino@gmail.com>,
	=?ISO-8859-1?Q?N=E9meth_M=E1?= =?ISO-8859-1?Q?rton?=
	<nm127@freemail.hu>, linux-media@vger.kernel.org,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: Make failed - standard ubuntu 9.10
References: <4B62113E.40905@googlemail.com> <4B627EAE.7020303@freemail.hu>	 <4B62A967.3010400@googlemail.com>	 <c2fe070d1001290430v472c8040r2a61c7904ef7234d@mail.gmail.com>	 <4B62F048.1010506@googlemail.com>	 <4B62F620.6020105@barber-family.id.au>	 <4B6306AA.8000103@googlemail.com> <829197381001290916m4eeb9271x1c858d6a6d0b9b3b@mail.gmail.com>
In-Reply-To: <829197381001290916m4eeb9271x1c858d6a6d0b9b3b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Jan 29, 2010 at 11:02 AM, David Henig <dhhenig@googlemail.com> wrote:
>> Thanks, I appear to have the headers and no longer have to do the symlink,
>> but still getting the same error - any help gratefully received, or do I
>> need to get a vanilla kernel?
> 
> Open up the file v4l/.config and change the line for firedtv from "=m"
> to "=n".  Then run "make".
> 
> This is a known packaging bug in Ubuntu's kernel headers.

This issue is specific to Ubuntu. With Fedora and with upstream kernels, everything compiles fine.

Maybe the better is if one of you that use Ubuntu to write a patch checking for
the affected Ubuntu versions, and automatically disabling the compilation
of this module, or doing some changes on compat.h to properly compile it.

All it is needed is to patch one of some of those files:
	v4l/scripts/make_kconfig.pl 		(for the logic to disable it on Ubuntu)
	/v4l/compat.h				(if is there some compat stuff that can be added)
	/v4l/scripts/make_config_compat.pl 	(for a most sophisticated logic based on some script)


After having the patch done, just submit it to Douglas.

Cheers,
Mauro

