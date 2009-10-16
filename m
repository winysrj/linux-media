Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36332 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZJPSXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 14:23:15 -0400
Received: by yxe17 with SMTP id 17so2241654yxe.33
        for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 11:23:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD8B0A2.1090207@redhat.com>
References: <36be2c7a0910151500k847735dub3e1a8547f913e8c@mail.gmail.com>
	 <4AD8B0A2.1090207@redhat.com>
Date: Fri, 16 Oct 2009 15:23:19 -0300
Message-ID: <36be2c7a0910161123l7a238e02le3e8046a57557c87@mail.gmail.com>
Subject: Re: Possible bug on libv4l read() emulation
From: Pablo Baena <pbaena@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think I identified the problem, I used code extracted from:
http://www.saillard.org/linux/pwc/files/capture.c, and the code was
like:

          total_read_bytes = 0;
          do {
                read_bytes = read(fd, buffers[0].start, buffers[0].length);
                if (read_bytes < 0)
                {
                    switch (errno)
                    {
                        case EIO:
                        case EAGAIN:
                            continue;
                        default:
                            errno_exit("read");
                    }
                }
                total_read_bytes += read_bytes;
            } while (total_read_bytes < buffers[0].length);

I changed the read() call to a v4l2_read() and used libv4l, and that
piece of code was triggering the kernel panic.

To fix it, I just removed the do..while loop. I'm still trying to
figure out what's the problem with that though.

Thanks for the reply.

On Fri, Oct 16, 2009 at 2:42 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> On 10/16/2009 12:00 AM, Pablo Baena wrote:
>>
>> I have a program where I use libv4l's read() emulation for simplicity.
>> But with most v4l2 webcams I've tried, I get kernel panics.
>>
>> I have pics of the message if anyone cares to see them, I don't want
>> to flood the mailing list.
>>
>> Basically, the names I see in the kernel panic from a uvcvideo card is:
>>
>> uvc_queue_next_buffer
>> __bad_area_no_semaphore
>> do_page_fault
>>
>> And a lot more.
>>
>
> A panic should never happen, no matter what libv4l does (as libv4l is 100%
> userspace). Please submit a bug report with as much detail as possible to
> the
> driver author.
>
> Regards,
>
> Hans
>



-- 
"Not possessing the gift of reflection, a dog does not know that he
does not know, and does not understand that he understands nothing;
we, on the other hand, are aware of both. If we behave otherwise, it
is from stupidity, or else from self-deception, to preserve our peace
of mind."
