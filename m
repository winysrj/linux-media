Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40309 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab1CQP3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 11:29:09 -0400
References: <1300307071-19665-1-git-send-email-jarod@redhat.com> <1300307071-19665-6-git-send-email-jarod@redhat.com> <1300320442.2296.25.camel@localhost> <20110317131909.GA5941@redhat.com>
In-Reply-To: <20110317131909.GA5941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5/6] lirc_zilog: error out if buffer read bytes != chunk size
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 17 Mar 2011 11:29:08 -0400
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Message-ID: <210cb1d1-4426-4b73-92aa-ec4337d9642c@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jarod Wilson <jarod@redhat.com> wrote:

>On Wed, Mar 16, 2011 at 08:07:22PM -0400, Andy Walls wrote:
>> On Wed, 2011-03-16 at 16:24 -0400, Jarod Wilson wrote:
>> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> > ---
>> >  drivers/staging/lirc/lirc_zilog.c |    4 ++++
>> >  1 files changed, 4 insertions(+), 0 deletions(-)
>> > 
>> > diff --git a/drivers/staging/lirc/lirc_zilog.c
>b/drivers/staging/lirc/lirc_zilog.c
>> > index 407d4b4..5ada643 100644
>> > --- a/drivers/staging/lirc/lirc_zilog.c
>> > +++ b/drivers/staging/lirc/lirc_zilog.c
>> > @@ -950,6 +950,10 @@ static ssize_t read(struct file *filep, char
>*outbuf, size_t n, loff_t *ppos)
>> >  				ret = copy_to_user((void *)outbuf+written, buf,
>> >  						   rbuf->chunk_size);
>> >  				written += rbuf->chunk_size;
>> > +			} else {
>> > +				zilog_error("Buffer read failed!\n");
>> > +				ret = -EIO;
>> > +				break;
>> 
>> No need to break, just let the non-0 ret value drop you out of the
>while
>> loop.
>
>Ah, indeed. I think I mindlessly copied what the tests just a few lines
>above were doing without looking at the actual reason for them. I'll
>remove that break from the patch here locally.
>
>-- 
>Jarod Wilson
>jarod@redhat.com

You might also want to take a look at that test to ensure it doesn't break blocking read() behavior.  (man 2 read). I'm swamped ATM and didn't look too hard.

It seems odd that the lirc buffer object can have data ready (the first branch of the big if() in the while() loop), and yet the read of that lirc buffer object fails.

-Andy
