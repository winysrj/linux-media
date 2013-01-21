Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab3AUNwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 08:52:18 -0500
Date: Mon, 21 Jan 2013 11:51:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patchwork / Bugzilla update
Message-ID: <20130121115144.01e58f6a@redhat.com>
In-Reply-To: <50FBEBFB.3020209@googlemail.com>
References: <50FBEBFB.3020209@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 20 Jan 2013 14:07:07 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Hi Mauro,
> 
> the patches 16225, 16231, 16232 at patchwork are superseeded:
> 
> pwclient update -s 'superseded' 16225
> pwclient update -s 'superseded' 16231
> pwclient update -s 'superseded' 16232

Updated.

> The following kernel bugs can be closed as "resolved - fixed":
> - bug 26572 "rmmod em28xx or unplugging em28xx tv adapter problem"
>   => resolved with commit 05fe2175cf87da8a5475aed422bd636475ab0412
> "em28xx: refactor the code in em28xx_usb_disconnect()"
> - bug 14126 "Audio input for TV mode of Terratec Cinergy 250 is
> misconfigured"
>   => resolved with commit 5e8d02bb346d6240b029f1990ddc295d7d59685b
> "em28xx: fix audio input for TV mode of device Terratec Cinergy 250"

Feel free to close them there directly.

Regards,
Mauro
