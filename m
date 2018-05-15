Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52228 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbeEOTAs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 15:00:48 -0400
Date: Tue, 15 May 2018 16:00:33 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <20180515160033.156f119c@vento.lan>
In-Reply-To: <f342d8d6-b5e6-0cbf-d002-9561b79c90e4@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
        <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
        <20180423152455.363d285c@vento.lan>
        <3ab9c4c9-0656-a08e-740e-394e2e509ae9@embeddedor.com>
        <20180423161742.66f939ba@vento.lan>
        <99e158c0-1273-2500-da9e-b5ab31cba889@embeddedor.com>
        <20180426204241.03a42996@vento.lan>
        <df8010f1-6051-7ff4-5f0e-4a436e900ec5@embeddedor.com>
        <20180515085953.65bfa107@vento.lan>
        <20180515141655.idzuh2jfdkuu5grs@mwanda>
        <f342d8d6-b5e6-0cbf-d002-9561b79c90e4@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 May 2018 12:29:10 -0500
"Gustavo A. R. Silva" <gustavo@embeddedor.com> escreveu:

> On 05/15/2018 09:16 AM, Dan Carpenter wrote:
> >>>
> >>> I'm curious about how you finally resolved to handle these issues.
> >>>
> >>> I noticed Smatch is no longer reporting them.  
> >>
> >> There was no direct fix for it, but maybe this patch has something
> >> to do with the smatch error report cleanup:
> >>
> >> commit 3ad3b7a2ebaefae37a7eafed0779324987ca5e56
> >> Author: Sami Tolvanen <samitolvanen@google.com>
> >> Date:   Tue May 8 13:56:12 2018 -0400
> >>
> >>      media: v4l2-ioctl: replace IOCTL_INFO_STD with stub functions
> >>      
> >>      This change removes IOCTL_INFO_STD and adds stub functions where
> >>      needed using the DEFINE_V4L_STUB_FUNC macro. This fixes indirect call
> >>      mismatches with Control-Flow Integrity, caused by calling standard
> >>      ioctls using a function pointer that doesn't match the function type.
> >>      
> >>      Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> >>      Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> >>      Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> >>  
> 
> Thanks, Mauro.
> 
> > 
> > Possibly...  There was an ancient bug in Smatch's function pointer
> > handling.  I just pushed a fix for it now so the warning is there on
> > linux-next.
> >   
> 
> Dan,
> 
> These are all the Spectre media issues I see smatch is reporting in 
> linux-next-20180515:

Yeah, that's the same I'm getting from media upstream.

> drivers/media/cec/cec-pin-error-inj.c:170 cec_pin_error_inj_parse_line() 
> warn: potential spectre issue 'pin->error_inj_args'

This one seems a false positive, as the index var is u8 and the
array has 256 elements, as the userspace input from 'op' is 
initialized with:

	u8 v;
	u32 op;

	if (!kstrtou8(token, 0, &v))
		op = v;

> drivers/media/dvb-core/dvb_ca_en50221.c:1479 dvb_ca_en50221_io_write() 
> warn: potential spectre issue 'ca->slot_info' (local cap)

This one seems a real issue to me. Sent a patch for it.

> drivers/media/dvb-core/dvb_net.c:252 handle_one_ule_extension() warn: 
> potential spectre issue 'p->ule_next_hdr'

I failed to see what's wrong here, or if this is exploited. 

> 
> I pulled the latest changes from the smatch repository and compiled it.
> 
> I'm running smatch v0.5.0-4459-g2f66d40 now. Is this the latest version?
> 
> I wonder if there is anything I might be missing.

Here, I'm at this commit:

commit 2f66d40cbf57b0bd581fe75447d2a8625fc7bb1d (origin/master, origin/HEAD)
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Tue May 15 16:35:20 2018 +0300

    db: make call_implies rows unique

Plus the diff below (that won't affect Spectre errors).

Regards,
Mauro

> 
> Thanks
> --
> Gustavo
> 

diff --git a/check_missing_break.c b/check_missing_break.c
index 434b7283fc94..5bba6e919521 100644
--- a/check_missing_break.c
+++ b/check_missing_break.c
@@ -73,7 +73,7 @@ static void print_missing_break(struct expression *expr)
 	last_print_expr = get_switch_expr();
 
 	name = expr_to_var(expr);
-	sm_msg("warn: missing break? reassigning '%s'", name);
+//	sm_msg("warn: missing break? reassigning '%s'", name);
 	free_string(name);
 }
 
diff --git a/smatch_flow.c b/smatch_flow.c
index dc0e78824370..cd72a9ded375 100644
--- a/smatch_flow.c
+++ b/smatch_flow.c
@@ -1005,8 +1005,7 @@ void __split_stmt(struct statement *stmt)
 
 		__bail_on_rest_of_function = 1;
 		final_pass = 1;
-		sm_msg("Function too hairy.  Giving up. %lu seconds",
-		       stop.tv_sec - fn_start_time.tv_sec);
+		sm_msg("__split_smt: function too hairy.  Giving up.");
 		fake_a_return();
 		final_pass = 0;  /* turn off sm_msg() from here */
 		return;
diff --git a/smatch_implied.c b/smatch_implied.c
index 3588816361fe..f3ccd4b6d79e 100644
--- a/smatch_implied.c
+++ b/smatch_implied.c
@@ -594,7 +594,7 @@ static void separate_and_filter(struct sm_state *sm, int comparison, struct rang
 
 	gettimeofday(&time_after, NULL);
 	sec = time_after.tv_sec - time_before.tv_sec;
-	if (sec > 20) {
+	if (sec > 60) {
 		sm->nr_children = 4000;
 		sm_msg("Function too hairy.  Ignoring implications after %d seconds.", sec);
 	}
diff --git a/smatch_slist.c b/smatch_slist.c
index e1eb1b999b2a..2f8ba34a4b9a 100644
--- a/smatch_slist.c
+++ b/smatch_slist.c
@@ -237,12 +237,14 @@ char *alloc_sname(const char *str)
 int out_of_memory(void)
 {
 	/*
-	 * I decided to use 50M here based on trial and error.
+	 * I decided to use 6GB here based on trial and error.
 	 * It works out OK for the kernel and so it should work
 	 * for most other projects as well.
 	 */
-	if (sm_state_counter * sizeof(struct sm_state) >= 100000000)
+	if (sm_state_counter * sizeof(struct sm_state) >= 6000000000) {
+		sm_msg("Out of memory");
 		return 1;
+	}
 	return 0;
 }
 




Thanks,
Mauro
