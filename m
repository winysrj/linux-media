Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbaDUSfS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 14:35:18 -0400
Message-ID: <535564D6.7030904@redhat.com>
Date: Mon, 21 Apr 2014 20:35:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andrey Volkov <volkov.am@ekb-info.ru>, linux-media@vger.kernel.org
CC: Gregor Jasny <gjasny@googlemail.com>
Subject: Re: [Bugreport] v4l-utils/libv4lconvert/ov511-decomp does not shutdown
 on SIGTERM
References: <20140421191114.391d005d@axid.nolty.ru>
In-Reply-To: <20140421191114.391d005d@axid.nolty.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the bug report. I must say I don't really
like the suggested fix. Can you try removing the kill
altogether and moving the 2 close calls to above
the waitpid call and see if that helps, I think that
is a cleaner solution.

Thanks & Regards,

Hans


On 04/21/2014 03:11 PM, Andrey Volkov wrote:
> Guys,
> 
> I use motion for my old web camera (v4l1) with
> export LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l2convert.so
> 
> v4l2convert.so run decompress helper ov511-decomp.
> 
> Processes look like:
> /usr/bin/motion
> \_ /usr/lib/i386-linux-gnu/libv4lconvert0/ov511-decomp
> 
> (motion - http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome)
> Everything works fine, but when I stop motion daemon I have to wait for a minute.
> 
> strace prints that ov511-decomp got SIGTERM, wait for the minute and then got SIGKILL.
> 
> When I do "killall -TERM ov511-decomp" ov511-decomp ignores it and continue to decomress.
> "killall -INT ov511-decomp" ov511-decomp shut down as expected.
> 
> As a workaround I made this patch to lib/libv4lconvert/helper.c
> 
> --- v4l-utils-1.0.1.orig/lib/libv4lconvert/helper.c
> +++ v4l-utils-1.0.1/lib/libv4lconvert/helper.c
> @@ -212,7 +212,7 @@ void v4lconvert_helper_cleanup(struct v4
> void v4lconvert_helper_cleanup(struct v4lconvert_data *data)
> {
> 	int status;
> 
> 	if (data->decompress_pid != -1) {
> -		kill(data->decompress_pid, SIGTERM);
> +		kill(data->decompress_pid, SIGINT);
> 		waitpid(data->decompress_pid, &status, 0);
> 
> 		close(data->decompress_out_pipe[WRITE_END]);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
