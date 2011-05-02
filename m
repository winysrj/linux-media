Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757596Ab1EBNGJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 09:06:09 -0400
Message-ID: <4DBEAC3D.7040608@redhat.com>
Date: Mon, 02 May 2011 10:06:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
CC: linux-media@vger.kernel.org
Subject: Re: Help to make a driver. ISDB-Tb
References: <4DBC422F.10102@netscape.net> <4DBCB4EF.5070104@redhat.com> <4DBE0F74.80602@netscape.net>
In-Reply-To: <4DBE0F74.80602@netscape.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-05-2011 22:57, Alfredo Jesús Delaiti escreveu:
> Hi Mauro
> 

> I guess the error is in this part of the module mb86a20s.c
> 
> /* Check if it is a mb86a20s frontend */
> rev = mb86a20s_readreg(state, 0);
> if (rev == 0x13) {
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> printk(KERN_INFO "Detected a Fujitsu mb86a20s frontend\n");
> } else {
> printk(KERN_ERR "Frontend revision %d is unknown - aborting.\n",
> rev);
> goto error;
> }

>From this message:
[ 14.288626] Frontend revision 255 is unknown - aborting.

I suspect that the I2C gate needed to access the frontend is at the wrong state. That's why you're
getting 0xff (255) value there.

> 
> I reiterate my gratitude,
> 
> Alfredo
> 

