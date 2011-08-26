Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:59709 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab1HZJtw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 05:49:52 -0400
Message-ID: <4E576C3B.9070204@linuxtv.org>
Date: Fri, 26 Aug 2011 11:49:47 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: Is DVB ioctl FE_SET_FRONTEND broken?
References: <1314348648.45073.YahooMailClassic@web121702.mail.ne1.yahoo.com>
In-Reply-To: <1314348648.45073.YahooMailClassic@web121702.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

reading your first message again, I realize that I was misunderstanding
you. I first thought that you were talking about a regression in Linux
3.0.x.

On 26.08.2011 10:50, Chris Rankin wrote:
> --- On Fri, 26/8/11, Andreas Oberritter <obi@linuxtv.org> wrote:
>> can you please test whether https://patchwork.kernel.org/patch/1036132/
>> restores the old behaviour?
>>
>> These three pending patches are also related to frontend events:
>>
>> https://patchwork.kernel.org/patch/1036112/
>> https://patchwork.kernel.org/patch/1036142/
>> https://patchwork.kernel.org/patch/1036122/
> 
> Andreas,
> 
> I've only reviewed these patches so far, but I am concerned that we both have a different understanding of what the FE_SET_FRONTEND ioctl is supposed to do. According to the documentation:
> 
> "The result of this call will be successful if the parameters were valid and the tuning could be initiated. The result of the tuning operation in itself, however, will arrive asynchronously as an event."

The quoted text is right.

"Result of this call" and "result of the tuning operation" are distinct,
where "result of this call" means that ioctl() will return 0. The
"result of a tuning operation" is not a single value (success/failure),
but a series of changes. I.e., you'll get an event for every status
change reported by the tuner, e.g. also when a signal is lost.

> However, your comment in your first patch reads:
> 
> "FE_SET_FRONTEND triggers an initial frontend event with status = 0, which copies output parameters to userspace."
> 
> To my mind, these are conflicting statements because how can there be such thing as "an initial frontend event"? I am not expecting the kernel to send any event until the tuning has finished and it can give me real information. I am *definitely* not expecting the kernel to send my input parameters straight back to me.

This initial event with status=0 exists since 2002. It's used to notify
a new tuning operation to the event listener.

http://www.linuxtv.org/cgi-bin/viewvc.cgi/DVB/driver/dvb_frontend.c?revision=1.6.2.30&view=markup

> Given the documented description of this ioctl, I would write the following (pseudo)code in userspace:
> 
> int rc;
> 
> rc = ioctl(fd, FE_SET_FRONTEND, &args);
> if (rc != 0) {
>     printf("Error: could not start tuning.\n");
> } else {
>     struct pollfd  pfd;
>     pfd.fd = fd;
>     pfd.events = POLLIN;
>     pfd.revents = 0;
> 
>     // Wait 5 seconds for tuning to finish.
>     rc = poll(&pfd, 1, 5000);
>     if (rc < 0) {
>         printf("Error!\n");
>     } else if (rc == 0) {
>         printf("Still not tuned after 5 seconds - give up!\n");
>     } else {
>         printf("YAY! WE ARE TUNED!\n");
>     }
> }
> 
> But your code adds an event to the queue as the ioctl() exits, which means that my pseudocode is never going to print the "Still not tuned after 5 seconds" message but jump straight to "YAY! WE ARE TUNED!" instead while tuning is actually still in progress.

It's not my code and my patch doesn't create any new event.

Your example code can't work. You need to call FE_GET_EVENT or
FE_READ_STATUS.

> So I'm going to say "No", your patches don't restore the old behaviour.

Yes. The patch is restoring a different old behaviour. The behaviour
you're referring to has never been in the kernel. ;-)

Regards,
Andreas
