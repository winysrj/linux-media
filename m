Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm0.bullet.mail.ne1.yahoo.com ([98.138.90.253]:28632 "HELO
	nm4-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754505Ab1HZI46 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 04:56:58 -0400
Message-ID: <1314348648.45073.YahooMailClassic@web121702.mail.ne1.yahoo.com>
Date: Fri, 26 Aug 2011 01:50:48 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Is DVB ioctl FE_SET_FRONTEND broken?
To: Andreas Oberritter <obi@linuxtv.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4E56DE32.6010809@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Fri, 26/8/11, Andreas Oberritter <obi@linuxtv.org> wrote:
> can you please test whether https://patchwork.kernel.org/patch/1036132/
> restores the old behaviour?
> 
> These three pending patches are also related to frontend events:
>
> https://patchwork.kernel.org/patch/1036112/
> https://patchwork.kernel.org/patch/1036142/
> https://patchwork.kernel.org/patch/1036122/

Andreas,

I've only reviewed these patches so far, but I am concerned that we both have a different understanding of what the FE_SET_FRONTEND ioctl is supposed to do. According to the documentation:

"The result of this call will be successful if the parameters were valid and the tuning could be initiated. The result of the tuning operation in itself, however, will arrive asynchronously as an event."

However, your comment in your first patch reads:

"FE_SET_FRONTEND triggers an initial frontend event with status = 0, which copies output parameters to userspace."

To my mind, these are conflicting statements because how can there be such thing as "an initial frontend event"? I am not expecting the kernel to send any event until the tuning has finished and it can give me real information. I am *definitely* not expecting the kernel to send my input parameters straight back to me.

Given the documented description of this ioctl, I would write the following (pseudo)code in userspace:

int rc;

rc = ioctl(fd, FE_SET_FRONTEND, &args);
if (rc != 0) {
    printf("Error: could not start tuning.\n");
} else {
    struct pollfd  pfd;
    pfd.fd = fd;
    pfd.events = POLLIN;
    pfd.revents = 0;

    // Wait 5 seconds for tuning to finish.
    rc = poll(&pfd, 1, 5000);
    if (rc < 0) {
        printf("Error!\n");
    } else if (rc == 0) {
        printf("Still not tuned after 5 seconds - give up!\n");
    } else {
        printf("YAY! WE ARE TUNED!\n");
    }
}

But your code adds an event to the queue as the ioctl() exits, which means that my pseudocode is never going to print the "Still not tuned after 5 seconds" message but jump straight to "YAY! WE ARE TUNED!" instead while tuning is actually still in progress.

So I'm going to say "No", your patches don't restore the old behaviour.

Cheers,
Chris

