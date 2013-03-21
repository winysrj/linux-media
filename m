Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3CUS6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 14:58:45 -0400
Date: Thu, 21 Mar 2013 15:58:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: media-tree build is broken
Message-ID: <20130321155839.466f17bd@redhat.com>
In-Reply-To: <514B4E97.6010903@googlemail.com>
References: <514B4E97.6010903@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Mar 2013 19:16:55 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> ...
> Kernel: arch/x86/boot/bzImage is ready  (#2)
> ERROR: "__divdi3" [drivers/media/common/siano/smsdvb.ko] undefined!
> make[1]: *** [__modpost] Fehler 1
> make: *** [modules] Fehler 2
> 
> 
> Mauro, I assume this is caused by one of the recent Siano patches ?

Very likely, there's a u64 division somewhere there without a do_div().

I'll take a look on it later. Thanks for reporting.


-- 

Cheers,
Mauro
