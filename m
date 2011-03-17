Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54856 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644Ab1CQQQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 12:16:31 -0400
References: <1300307071-19665-1-git-send-email-jarod@redhat.com> <1300307071-19665-6-git-send-email-jarod@redhat.com> <1300320442.2296.25.camel@localhost> <20110317131909.GA5941@redhat.com> <210cb1d1-4426-4b73-92aa-ec4337d9642c@email.android.com> <20110317154204.GB5941@redhat.com>
In-Reply-To: <20110317154204.GB5941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5/6] lirc_zilog: error out if buffer read bytes != chunk size
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 17 Mar 2011 12:16:31 -0400
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Message-ID: <9e23e0c0-8944-458f-a521-216239dc9bf9@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jarod Wilson <jarod@redhat.com> wrote:

>On Thu, Mar 17, 2011 at 11:29:08AM -0400, Andy Walls wrote:
>> Jarod Wilson <jarod@redhat.com> wrote:
>> 
>> >On Wed, Mar 16, 2011 at 08:07:22PM -0400, Andy Walls wrote:
>> >> On Wed, 2011-03-16 at 16:24 -0400, Jarod Wilson wrote:
>> >> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> >> > ---
>> >> >  drivers/staging/lirc/lirc_zilog.c |    4 ++++
>> >> >  1 files changed, 4 insertions(+), 0 deletions(-)
>> >> > 
>> >> > diff --git a/drivers/staging/lirc/lirc_zilog.c
>> >b/drivers/staging/lirc/lirc_zilog.c
>> >> > index 407d4b4..5ada643 100644
>> >> > --- a/drivers/staging/lirc/lirc_zilog.c
>> >> > +++ b/drivers/staging/lirc/lirc_zilog.c
>> >> > @@ -950,6 +950,10 @@ static ssize_t read(struct file *filep,
>char
>> >*outbuf, size_t n, loff_t *ppos)
>> >> >  				ret = copy_to_user((void *)outbuf+written, buf,
>> >> >  						   rbuf->chunk_size);
>> >> >  				written += rbuf->chunk_size;
>> >> > +			} else {
>> >> > +				zilog_error("Buffer read failed!\n");
>> >> > +				ret = -EIO;
>> >> > +				break;
>> >> 
>> >> No need to break, just let the non-0 ret value drop you out of the
>> >while
>> >> loop.
>> >
>> >Ah, indeed. I think I mindlessly copied what the tests just a few
>lines
>> >above were doing without looking at the actual reason for them. I'll
>> >remove that break from the patch here locally.
>> >
>> >-- 
>> >Jarod Wilson
>> >jarod@redhat.com
>> 
>> You might also want to take a look at that test to ensure it doesn't
>break blocking read() behavior.  (man 2 read). I'm swamped ATM and
>didn't look too hard.
>> 
>> It seems odd that the lirc buffer object can have data ready (the
>first branch of the big if() in the while() loop), and yet the read of
>that lirc buffer object fails.
>
>Generally, it shouldn't, but lirc_buffer_read uses kfifo underneath,
>and
>in the pre-2.6.33 kfifo implementation, the retval from
>lirc_buffer_read
>(as backported by way of media_build) is always 0, which is of course
>not
>equal to chunk_size. So I think that in current kernels, this should
>never
>trigger, and its partially just a note-to-self that this check will go
>sideways when running on an older kernel, but not a bad check to have
>if
>something really does go wrong.
>
>-- 
>Jarod Wilson
>jarod@redhat.com

But the orignal intent of the check I put in was to avoid passing partial/junk data to userspace, and go around again to see if good data could be provided.  

Your check bails when good data that might be sitting there still.  That doesn't seem like a good trade for supporting backward compat for old kernels.
  
-Andy
