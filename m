Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34145 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1J3UFE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 16:05:04 -0400
Received: by eye27 with SMTP id 27so4869504eye.19
        for <linux-media@vger.kernel.org>; Sun, 30 Oct 2011 13:05:02 -0700 (PDT)
Message-ID: <4EADADE1.4080606@gmail.com>
Date: Sun, 30 Oct 2011 21:04:49 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Piotr Chmura <chmooreck@poczta.onet.pl>,
	devel@driverdev.osuosl.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [RESEND PATCH 11/14] staging/media/as102: fix compile warning
 about unused function
References: <4E7F1FB5.5030803@gmail.com>	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>	<4E7FF0A0.7060004@gmail.com>	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>	<20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de>	<20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl>	<4E99F2FC.5030200@poczta.onet.pl> <20111016105731.09d66f03@stein>	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>	<4E9ADFAE.8050208@redhat.com>	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>	<20111018111336.62af07ce.chmooreck@poczta.onet.pl> <20111018220352.3179feb1@darkstar>
In-Reply-To: <20111018220352.3179feb1@darkstar>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2011 10:03 PM, Piotr Chmura wrote:
> Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> 
> Original source and comment:
> # HG changeset patch
> # User Devin Heitmueller<dheitmueller@kernellabs.com>
> # Date 1267319685 18000
> # Node ID 84b93826c0a19efa114a6808165f91390cb86daa
> # Parent  22ef1bdca69a2781abf397c53a0f7f6125f5359a
> as102: fix compile warning about unused function
> 
> From: Devin Heitmueller<dheitmueller@kernellabs.com>
> 
> The function in question is only used on old kernels, so we had the call to
> the function #ifdef'd, but the definition of the function was stil being
> included.
> 
> Priority: normal
> 
> Signed-off-by: Devin Heitmueller<dheitmueller@kernellabs.com>
> Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
> 
> diff --git linux/drivers/staging/media/as102/as102_fe.c linuxb/drivers/staging/media/as102/as102_fe.c
> --- linux/drivers/staging/media/as102/as102_fe.c
> +++ linuxb/drivers/staging/media/as102/as102_fe.c
> @@ -32,6 +32,7 @@
>   static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
>   					  struct dvb_frontend_parameters *src);
> 
> +#if (LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 19))

I was wondering, could such a conditional compilation be simply skipped when
we are merging the driver into exactly known kernel version ?  
For backports there are separate patches at media_build.git and I can't see
such an approach used in any driver upstream.

--
Regards,
Sylwester
