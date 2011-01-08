Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:64250 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab1AHQRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jan 2011 11:17:20 -0500
Subject: Re: zilog and IR
From: Andy Walls <awalls@md.metrocast.net>
To: jgauthier@lastar.com
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTi=yLo8A==TXLYN6g72RZVsk4ydQthf29=i=A36j@mail.gmail.com>
References: <AANLkTi=yLo8A==TXLYN6g72RZVsk4ydQthf29=i=A36j@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Jan 2011 10:19:37 -0500
Message-ID: <1294499977.2443.106.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-08 at 10:44 -0500, Jason Gauthier wrote:
> Andy,
> 
>    Firstly, I apologize for reaching out to you directly.

The list could have answered this, so I adding the Cc:.

BTW, I normally ignore direct emails asking for free support, as the
N-to-1 free support problem is too costly for me personally.  The N-to-M
free support problem on the list is a little easier to bear, and is
consistent with Linux's community development model. 


>  I stumbled into your git tree, which looks like it does exactly what
> I want.

But it doesn't.  It's a bleeding edge tree of mine used to develop a
changeset.  Be warned that such trees come with no guarantees that at
any one moment in time it will compile and not damage your hardware.

I only subjected the changes to personal review, compilation check, and
inspection by others on the list.  That was sufficient for me for
software defect removal, since the change was a cut-and-paste from the
cx18 and ivtv modules and the code is not yet called by hdpvr anyway.


> I grabbed the source but, unfortunately, it is not compiling for me
> because one of the constants is not defined.
> 
> in hdprv_new_i2c_ir, the line:
>     init_data->type = RC_TYPE_RC5;

> I have not been able to find any traces of RC_TYPE_RC5 in my 2.6.37
> kernel source.
> Is this a #define that you've made specific to your git tree?

No:

http://git.linuxtv.org/media_tree.git?a=commit;h=e58462f45e39e01799d8b1ebab4816bd0ca68ddc

That media_tree.git repository is the bleeding edge tree recommended for
developers and advanced users wanting the latest drivers.

The alternate is the media_build.git repository when has ability to
build the modules with some not so old kernels.

Regards,
Andy

