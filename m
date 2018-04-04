Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:45175 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751216AbeDDLip (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 07:38:45 -0400
Subject: Re: cron job: media_tree daily build: OK
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
References: <0806dde4145aa196d5b5ab0e2fac4d9f@smtp-cloud7.xs4all.net>
 <20180404081519.10675eeb@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <632b2b24-284b-56f8-2f1d-a65094d34a73@xs4all.nl>
Date: Wed, 4 Apr 2018 13:38:42 +0200
MIME-Version: 1.0
In-Reply-To: <20180404081519.10675eeb@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/18 13:15, Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Wed, 04 Apr 2018 05:45:22 +0200
> "Hans Verkuil" <hverkuil@xs4all.nl> escreveu:
> 
> Not sure what versions of sparse/smatch you're using. Here, I'm using the
> latest version from both trees. Anyway, I'm getting different results
> than you (both built for i386).

My sparse version was out of date, my smatch version is the same as yours.

I've fixed the sparse version for the build.

Regards,

	Hans

> 
>> sparse: WARNINGS
> 
> The only sparse warnings I'm getting here are at ddbridge driver:
> 
> $ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='/devel/sparse/sparse' M=drivers/media
> drivers/media/pci/ddbridge/ddbridge-core.c:442:9: warning: context imbalance in 'ddb_output_start' - different lock contexts for basic block
> drivers/media/pci/ddbridge/ddbridge-core.c:457:9: warning: context imbalance in 'ddb_output_stop' - different lock contexts for basic block
> drivers/media/pci/ddbridge/ddbridge-core.c:472:9: warning: context imbalance in 'ddb_input_stop' - different lock contexts for basic block
> drivers/media/pci/ddbridge/ddbridge-core.c:504:9: warning: context imbalance in 'ddb_input_start' - different lock contexts for basic block
> 
> My sparse tree is at this commit:
> 
> commit d1c2f8d3d4205ca1ae7cf0ec2cbd89a7fce73e5c (HEAD -> master, tag: v0.5.2-rc1, origin/master, origin/HEAD)
> Author: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> Date:   Fri Mar 2 21:58:57 2018 +0100
> 
>     bump up version to 0.5.2-RC1
>     
>     Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
>     Signed-off-by: Christopher Li <sparse@chrisli.org>
> 
>> smatch: OK
> 
> Also here, my results are different. There are still a few smatch warnings
> there:
> 
> $ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='/devel/smatch/smatch -p=kernel' M=drivers/media
> drivers/media/v4l2-core/v4l2-fwnode.c:832 v4l2_fwnode_reference_parse_int_props() warn: passing zero to 'PTR_ERR'
> drivers/media/dvb-core/dvb_frontend.c:314 dvb_frontend_get_event() warn: inconsistent returns 'sem:&fepriv->sem'.
>   Locked on:   line 288
>                line 295
>                line 306
>                line 314
>   Unlocked on: line 303
> drivers/media/usb/dvb-usb-v2/lmedm04.c:742 lme_firmware_switch() warn: missing break? reassigning '*fw_lme'
> drivers/media/usb/dvb-usb-v2/lmedm04.c:765 lme_firmware_switch() warn: missing break? reassigning '*fw_lme'
> drivers/media/rc/st_rc.c:110 st_rc_rx_interrupt() warn: this loop depends on readl() succeeding
> drivers/media/pci/mantis/mantis_uart.c:105 mantis_uart_work() warn: this loop depends on readl() succeeding
> drivers/media/tuners/r820t.c:2374 r820t_attach() error: potential null dereference 'priv'.  (kzalloc returns null)
> drivers/media/platform/vsp1/vsp1_wpf.c:456 wpf_configure() error: we previously assumed 'pipe->bru' could be null (see line 455)
> 
> With regards to those remaining warnings:
> 
> 1) There's a fix already for the vsp1_wpf warning that I merged today
>    on my fixes tree, to be sent for 4.17-rc1.
> 2) The two missing breaks are false positive. As discussed with Dan,
>    maybe the best here is to change the logic at smatch, as the
>    code there is correct.
> 
> I am at this commit:
> 
> commit 3b5bf5c91fe648f89c12dfeb4cda3fe36e7f19c5 (origin/master, origin/HEAD)
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Mon Mar 26 15:13:22 2018 +0300
> 
>     implied: improve handling of assignments in arguments
>     
>     This example code wasn't parsed correctly:
>     
>             if (IS_ERR(ptr = some_function())) {
>     
>     We should say basically use "ptr" as the implied arg instead of the
>     assignment expression.
>     
>     Reported-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>     Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> I added an extra patch to prevent some other warnings due to very big
> functions:
> 
> commit 735d5595e2c23abc544858109925941f4b14f4a0
> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Date:   Fri Jun 5 09:49:00 2015 -0300
> 
>     smatch_slist: use a higher memory limit
>     
>     50M is not enough for some code at the Kernel. It produces this
>     warning:
>     
>     drivers/media/pci/cx23885/cx23885-dvb.c:2046 dvb_register() Function too hairy.  Giving up.
>     
>     While checking for troubles on a loop with attaches the device
>     specific sub-devices based on the PCI ID.
>     
>     There's not much that could be done at the code to simplify it.
>     The code there is big just because the cx23885 driver supports
>     lots of different cards.
>     
>     On the other hand, increasing the maximum memory size to 500MB
>     is cheap, as nowadays even desktops have 16GB.
>     
>     So, let's increase it.
>     
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> diff --git a/smatch_flow.c b/smatch_flow.c
> index 94a1c6b5dd89..a7bdd210b904 100644
> --- a/smatch_flow.c
> +++ b/smatch_flow.c
> @@ -982,8 +982,7 @@ void __split_stmt(struct statement *stmt)
>  
>  		__bail_on_rest_of_function = 1;
>  		final_pass = 1;
> -		sm_msg("Function too hairy.  Giving up. %lu seconds",
> -		       stop.tv_sec - fn_start_time.tv_sec);
> +		sm_msg("__split_smt: function too hairy.  Giving up.");
>  		fake_a_return();
>  		final_pass = 0;  /* turn off sm_msg() from here */
>  		return;
> diff --git a/smatch_implied.c b/smatch_implied.c
> index 3588816361fe..f3ccd4b6d79e 100644
> --- a/smatch_implied.c
> +++ b/smatch_implied.c
> @@ -594,7 +594,7 @@ static void separate_and_filter(struct sm_state *sm, int comparison, struct rang
>  
>  	gettimeofday(&time_after, NULL);
>  	sec = time_after.tv_sec - time_before.tv_sec;
> -	if (sec > 20) {
> +	if (sec > 60) {
>  		sm->nr_children = 4000;
>  		sm_msg("Function too hairy.  Ignoring implications after %d seconds.", sec);
>  	}
> diff --git a/smatch_slist.c b/smatch_slist.c
> index e1eb1b999b2a..2f8ba34a4b9a 100644
> --- a/smatch_slist.c
> +++ b/smatch_slist.c
> @@ -237,12 +237,14 @@ char *alloc_sname(const char *str)
>  int out_of_memory(void)
>  {
>  	/*
> -	 * I decided to use 50M here based on trial and error.
> +	 * I decided to use 6GB here based on trial and error.
>  	 * It works out OK for the kernel and so it should work
>  	 * for most other projects as well.
>  	 */
> -	if (sm_state_counter * sizeof(struct sm_state) >= 100000000)
> +	if (sm_state_counter * sizeof(struct sm_state) >= 6000000000) {
> +		sm_msg("Out of memory");
>  		return 1;
> +	}
>  	return 0;
>  }
>  
> 
> 
>>
>> Detailed results are available here:
>>
>> http://www.xs4all.nl/~hverkuil/logs/Wednesday.log
>>
>> Full logs are available here:
>>
>> http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2
>>
>> The Media Infrastructure API from this daily build is here:
>>
>> http://www.xs4all.nl/~hverkuil/spec/index.html
> 
> 
> 
> Thanks,
> Mauro
> 
