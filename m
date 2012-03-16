Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35524 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547Ab2CPJIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 05:08:12 -0400
Received: by ghrr11 with SMTP id r11so3950531ghr.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 02:08:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F6228D4.6090706@redhat.com>
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com>
	<CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com>
	<CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com>
	<CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com>
	<CALjTZvYJZ32Red-UfZXubB-Lk503DWbHGTL_kEoV4DVDDYJ46w@mail.gmail.com>
	<4F61C79E.6090603@redhat.com>
	<CALjTZvZR=Mr-eSVwy=Wd8ToikAX9bG23NLARRw_K0scT-_YeCg@mail.gmail.com>
	<4F61FF2D.6010505@redhat.com>
	<CALF0-+WJ9c579+=2QMamxpAngHJKWfZaWqOp_z=GvZKGy97VnA@mail.gmail.com>
	<4F6228D4.6090706@redhat.com>
Date: Fri, 16 Mar 2012 09:08:11 +0000
Message-ID: <CALjTZvYZTaQNkb4bxoG6Z5QHVcFg+hz9hgPkGzgrf_LAH2y0cQ@mail.gmail.com>
Subject: Re: eMPIA EM2710 Webcam (em28xx) and LIRC
From: Rui Salvaterra <rsalvaterra@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?Q?Ezequiel_Garc=C3=ADa?= <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again, I'm terribly sorry for the delay


2012/3/15 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Em 15-03-2012 14:15, Ezequiel García escreveu:
>> Hi Mauro,
>>
>> On 3/15/12, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>> If you won't take it, it is likely that some day someone will do it,
>>> but, as this is just a cleanup, the main developers won't likely
>>> have time for doing it, as they're generally busy adding support for
>>> new hardware.
>>>
>>
>> I have no problem submitting the two patches in discussion.
>> (Actually, I've already wroten the first one).
>
> Good!
>
>> If Rui wants to help me, it would be nice to get this tested,
>> since I don't have the necessary hardware.
>
> I might test, but I'm currently very busy with some other stuff,
> so I won't likely have time for it anytime soon.


I'd love to give it at spin, of course. I'm just not familiar with the
procedure on Debian/Ubuntu (last time I compiled a kernel I was
running Gentoo, about six years ago).


>
>> One thing I haven't got clear is this: I've seen that ir_raw_init()
>> does not call request_module() directly but rather defers it
>> through a work queue.
>
> Deferring request_module to a work_queue is a common procedure we
> do at v4l drivers. It helps to initialize faster, and prevents some
> dependency issues, as the decoders depend on rc_core to be initialized,
> in order to load.
>
>> I don't understand fully the rc code, but still I don't get what
>> happens if I need the raw decoders *now* (so to speak)
>> but the work queue hasn't been run yet?
>
> Well, if you press an RC key while the needed decoded is not loaded,
> that key will be lost. No other problems should happen.
>
> Regards,
> Mauro.


Thanks,

Rui Salvaterra
