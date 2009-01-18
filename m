Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110808.mail.gq1.yahoo.com ([67.195.13.231]:35626 "HELO
	web110808.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751215AbZARShd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 13:37:33 -0500
Date: Sun, 18 Jan 2009 10:37:32 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
Reply-To: urishk@yahoo.com
Subject: Re: Siano's patches
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <49736FE6.9080309@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <986893.55175.qm@web110808.mail.gq1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Sun, 1/18/09, Michael Krufky <mkrufky@linuxtv.org> wrote:

> From: Michael Krufky <mkrufky@linuxtv.org>
> Subject: Re: Siano's patches
> To: urishk@yahoo.com
> Cc: "Mauro Carvalho" <mchehab@infradead.org>, linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org, "linux-dvb" <linux-dvb@linuxtv.org>
> Date: Sunday, January 18, 2009, 8:07 PM
> Uri Shkolnik wrote:
> > Hi Mauro,
> > 
> > Hope you had a great weekend :-)
> > 
> > 
> > I would like to know if you have already reached the
> conclusion whether to use the Mercurial tree option or the
> email option we discussed last week.   
> > Regarding the patches that have been already submitted
> to the linux-media@vger.kernel.org ML, any schedule for the
> merge?   
> Uri,
> 
> I've already responded to your last email -- You should
> continue to submit patches to the mailing list.

Mauro suggested two options, I asked for the first (the Mercurial tree) which is more convenient for me. As it used by multiple parties here and if there is no objection based on some unknown (to me) reason, I would like to use that option.


> 
> As for your pending patches, I explained in my email that
> they are in my queue.  I am in the midst of reviewing the
> changes.  As you're already aware, your changes break
> the Hauppauge device's functionality.  After merging
> your changes, I will have to go back and re-implement the
> Hauppauge-specific changes in the driver, using the new
> methods in your pending patches.
> 

Some of the patches in the list are pending from early September, 2008.
( I think it's time they will be popped out of the queue.... :-)

Regarding restoring, modifying, enhancing, etc. - Please do it successively, submitting my patches and your after them, so (1) the congruity between the Mercurial DVB tree change-sets and Siano's change-set will be kept, and (2) I, and other reviewers, may review your patches/changes in their own change-sets.


> Once I have reviewed & merged your changes and after I
> can restore the proper functionality to the hauppauge
> devices, then I will post a new mercurial tree for testing
> against all siano-based devices.
> 

Please see above

> Please be patient -- this takes time.
> 
> Regards,
> 
> Mike
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html


      
