Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2JAOC6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 10:02:58 -0400
Date: Mon, 1 Oct 2012 11:02:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Martin Burnicki <martin.burnicki@burnicki.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Current media_build doesn't succeed building on kernel 3.1.10
Message-ID: <20121001110241.2f5ab052@redhat.com>
In-Reply-To: <201209302052.42723.martin.burnicki@burnicki.net>
References: <201209302052.42723.martin.burnicki@burnicki.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 30 Sep 2012 20:52:42 +0200
Martin Burnicki <martin.burnicki@burnicki.net> escreveu:

> Hi all,
> 
> is anybody out there who can help me with the media_build system? I'm trying 
> to build the current modules on an openSUSE 12.1 system (kernel 3.1.10, 
> x86_64), but I'm getting compilation errors because the s5k4ecgx driver uses 
> function devm_regulator_bulk_get() which AFAICS has been introduced in kernel 
> 3.4 only. When I run the ./build script compilation stops with these 
> messages:
> 
>  CC [M]  /root/projects/media_build/v4l/s5k4ecgx.o
> media_build/v4l/s5k4ecgx.c: In function 's5k4ecgx_load_firmware':
> media_build/v4l/s5k4ecgx.c:346:2: warning: format '%d' expects argument of \
>     type 'int', but argument 4 has type 'size_t' [-Wformat]
> media_build/v4l/s5k4ecgx.c: In function 's5k4ecgx_probe':
> media_build/v4l/s5k4ecgx.c:977:2: error: implicit declaration of \
>     function 'devm_regulator_bulk_get' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

Those are warnings. It wil compile if you disable -Werror=implicit-function-declaration.

> 
> 
> Probably I'll don't need module s5k4ecgx anyway, so any hint how to exclude 
> this from build would be fine.
> 
> On this page 
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers#Retrieving_and_Building.2FCompiling_the_Latest_V4L-DVB_Source_Code
> the section "More Manually Intensive Approach" mentions steps where I can 
> run "make menuconfig" after unpacking the sources and before the build 
> process is started, so I could deselect the module(s) I don't need and 
> exclude them from build. However, I've no idea what I should use for "DIR=" 
> in the command 
> 
>   make tar DIR=<some dir with media -git tree>
> 
> mentioned on the web page.
> 
> According to theis link
> https://patchwork.kernel.org/patch/1267511/
> the s5k4ecgx module which does not build here has just been added at the 
> beginning of August, so if I could specify a git version of the code which is 
> slightly older this might also work.
> 
> BTW, if I understand the build environment correctly then there should be 
> dayly test builds of the package for varions kernels. I'd expect those 
> automated builds should also fail for kernels older than 3.4.
> 
> 
> Regards,
> 
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
