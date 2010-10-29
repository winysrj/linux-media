Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39382 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933875Ab0J2OYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 10:24:46 -0400
Received: by eye27 with SMTP id 27so2144957eye.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 07:24:45 -0700 (PDT)
Date: Fri, 29 Oct 2010 17:26:01 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [git:v4l-dvb/v2.6.37] [media] radio-si4713: Add regulator
 framework support
Message-Id: <20101029172601.fdf7ed07.jhnikula@gmail.com>
In-Reply-To: <4CCAD21A.9040100@redhat.com>
References: <E1P7ZwW-0003bq-Uv@www.linuxtv.org>
	<20101029092935.b6dd7693.jhnikula@gmail.com>
	<4CCAD21A.9040100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 29 Oct 2010 11:54:34 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> I had to remove it from my queue, as the patch broke compilation:
> 
> 	http://git.linuxtv.org/media_tree.git?a=commit;h=350df81ebaccc651fa4dfad27738db958e067ded
> 
> What's the sense of adding a patch that breaks a driver?
> 
> Even assuming that you would later send a patch fixing it, there are still some problems:
> 
> 1) A latter patch will break git bisect;
> 2) A broken driver means that I can't test anymore if there are any other problems on other
>    drivers.
> 
> So, please test your patches against breakages, before sending them to me.
> 
Oh shit, true, my fault. I definitely forgot one file from git commit
but luckily I had the diff file around that I used in testing instead
of the commit I sent...

Sorry the hassle and thanks for letting me know, I'll send an update
in a minute.


-- 
Jarkko
