Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab1BBNDM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Feb 2011 08:03:12 -0500
Message-ID: <4D495609.5060308@redhat.com>
Date: Wed, 02 Feb 2011 11:03:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Francesco <francesco@bsod.eu>
CC: linux-media@vger.kernel.org
Subject: Re: libv4l compile on uclibc
References: <710dab092054ffa3e12fbf493dd9b4da@127.0.0.1>
In-Reply-To: <710dab092054ffa3e12fbf493dd9b4da@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-02-2011 10:30, Francesco escreveu:
> Good afternoon.
> I'm trying to compile v4l-utils for uclibc, but i need only libv4l for my purpose.
> 
> In order to compile correctly, is should have argp.h, but in the distribution i'm using uclibc is not compiled with argp.h.
> Because this library is used in :
> 
> v4l2grab.c:#include <argp.h>
> decode_tm6000/decode_tm6000.c:#include <argp.h>
> utils/keytable/keytable.c:#include <argp.h>
> 
> but i don't need this part of utils, is possible compile only libv4l without using argp.h ?

I think you can just go to the lib directory and do a make there.

If you want, feel free to submit us a patch detecting that argp.h is
not available and disabling the compilation for the above.
> 
> Thanks in advance.

Cheers,
Mauro
