Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA1GK4dl010440
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 12:20:04 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA1GJEXs008441
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 12:19:15 -0400
Received: by ey-out-2122.google.com with SMTP id 4so559852eyf.39
	for <video4linux-list@redhat.com>; Sat, 01 Nov 2008 09:19:14 -0700 (PDT)
Message-ID: <412bdbff0811010919v3b336939qf94df1162ecbbb28@mail.gmail.com>
Date: Sat, 1 Nov 2008 12:19:14 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <84144f020811010908h1220d209j799edca3eb772fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811011505.51716.hverkuil@xs4all.nl>
	<412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
	<84144f020811010908h1220d209j799edca3eb772fd@mail.gmail.com>
Cc: Greg KH <greg@kroah.com>, v4l <video4linux-list@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	em28xx <em28xx@mcentral.de>, mchehab@infradead.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, Nov 1, 2008 at 12:08 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Devin,
>
> On Sat, Nov 1, 2008 at 5:46 PM, Devin Heitmueller
> <devin.heitmueller@gmail.com> wrote:
>> A number of people have suggested that nobody was willing to
>> incorporate Markus's changes incrementally to improve the in-kernel
>> driver.  This couldn't be further from the truth.  I appealed to
>> Markus on multiple occasions trying to find some compromise where his
>> changes could be merged into the mainline em28xx driver.  He outright
>> refused.  It was his contention that his driver was/is better than the
>> in-kernel driver in every possible way, and that the existing code has
>> no redeeming value.  In fact, I was accused of taking his GPL'd code
>> without his consent and incorporating it into the linux-dvb codebase.
>> It's this "all or nothing" attitude that has prevented his work thus
>> far from being incorporated, not the unwillingness of people like
>> myself to do the work to merge his changes in a sane matter.
>
> I'm not sure I understand how he can refuse such a thing. If the code
> is released under the GPLv2 and the author refuses to play by the well
> known rules of the kernel community, then I don't see any problem with
> taking the code and improving the current driver (as long as the
> copyright is properly attributed, of course).
>
> I think it's already pretty well established that we don't just take
> in shiny new drivers and trust a new maintainer to do the right thing
> because that has gotten us in such a mess so many times before. Being
> part of the community is not so much the code you write but the way
> you interact with other kernel developers.
>
> So, if I were you, I'd just do it.

Hello Pekka,

I do not believe that he had any legal standing to prevent me from
taking the code and incorporating it if that was my desire, given that
he released it under the GPL.  However, taking someone's code when
they specifically said they don't want you to is kind of a crappy
thing to do in my humble opinion, and it definitely doesn't improve
relations with the developer.

The reality is that from a technical standpoint I really want Markus
to be the maintainer.  He knows more about the devices than anyone,
works for the vendor, and has access to all the datasheets.  That
said, I don't want a situation where he is the *only* one who can do
work on the codebase because it is poorly commented and structured in
a way where only he can understand why it works the way it does.
Also, I believe certain design decisions should be made as a result of
consensus with the other maintainers, taking into consideration
consistency across drivers.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
