Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab0BLENc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 23:13:32 -0500
Date: Thu, 11 Feb 2010 20:11:31 -0800
From: Greg KH <gregkh@suse.de>
To: Andy Walls <awalls@radix.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Richard Lemieux <rlemieu@cooptel.qc.ca>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800
	(DVB-S) and USB HVR Hauppauge 950q
Message-ID: <20100212041131.GA29697@suse.de>
References: <4B70E7DB.7060101@cooptel.qc.ca> <1265768091.3064.109.camel@palomino.walls.org> <4B722266.4070805@cooptel.qc.ca> <829197381002091912h5391129dpbf075485ab011936@mail.gmail.com> <1265816096.4019.65.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265816096.4019.65.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 10, 2010 at 10:34:56AM -0500, Andy Walls wrote:
> On Tue, 2010-02-09 at 22:12 -0500, Devin Heitmueller wrote:
> > On Tue, Feb 9, 2010 at 10:05 PM, Richard Lemieux <rlemieu@cooptel.qc.ca> wrote:
> > > Andy,
> > >
> > > This is a great answer!  Thanks very much.  When I get into this situation
> > > again
> > > I will know what to look for.
> > >
> > > A possible reason why I got into this problem in the first place is that I
> > > tried
> > > many combinations of parameters with mplayer and azap in order to learn how
> > > to use the USB tuner in both the ATSC and the NTSC mode.  I will look back
> > > in the terminal history to see if I can find anything.
> > 
> > I think the key to figuring out the bug at this point is you finding a
> > sequence where you can reliably reproduce the oops.  If we have that,
> > then I can start giving you some code to try which we can see if it
> > addresses the problem.
> > 
> > For example, I would start by giving you a fix which results in us not
> > calling the firmware release if the request_firmware() call failed,
> > but it wouldn't be much help if you could not definitively tell me if
> > the problem is fixed.
> 
> 
> For the oops analysis here:
> 
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/15954
> 
> 
> I will also note that the file scope "fw_lock" mutex is rather
> inconsistently used in
> linux/drivers/base/fw_class.c:firmware_loading_store().  (I guess for
> not wanting to consume the timeout interval with sleeping?)
> 
> The mutex protects "case 1:", but all other cases appear to be only
> protected by atomic status bit checks that can fall through to
> fw_load_abort() which complete()'s the fw_priv->completion.
> 
> Also not that in the _request_firmware() this sequence is the only place
> a once good "fw_priv->fw" pointer is set to NULL:
> 
>         mutex_lock(&fw_lock);
>         if (!fw_priv->fw->size || test_bit(FW_STATUS_ABORT, &fw_priv->status)) {
>                 retval = -ENOENT;
>                 release_firmware(fw_priv->fw);
>                 *firmware_p = NULL;
>         }
>         fw_priv->fw = NULL;     <--------------- The only place it is set to NULL
>         mutex_unlock(&fw_lock);
> 
> 
> So if the timeout timer fires at nearly the same time as udev coming in
> and say "I'm done loading" without holding the mutex, one can run into
> the Ooops.  Not only that, I think the above code can leak memory under
> some circumstances when the "if" clause is not satisfied.
> 
> I think this really is a firmware_class.c issue.  I think the "just
> right" firmware loading timeouts and the particular computer system
> responsiveness, make this Ooops possible.  However, I'm amazed that a
> single person has tripped it more than once.
> 
> Revising the locking in linux/drivers/base/firmware_class.c should fix
> the problem.
> 
> I don't believe this comment in the code now:
> 
> /* fw_lock could be moved to 'struct firmware_priv' but since it is just
>  * guarding for corner cases a global lock should be OK */
> static DEFINE_MUTEX(fw_lock);
> 
> struct firmware_priv {
>         char *fw_id;
> 	...
> 
> And since "f_priv" is dynamically created and destroyed by
> request_firmware() I see no harm in 
> 
> 1. moving the mutex into struct firmware_priv
> 2. just always just grabbing an almost never contended mutex
> 3. getting rid of the file scope fw_lock.
> 
> except grabbing a mutex() while the timeout timer is running during
> loading, means one *could* sleep for a while consuming the timeout
> interval.

That sounds reasonable to me, care to make up a patch for this?

thanks,

greg k-h
