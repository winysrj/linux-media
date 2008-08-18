Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7IAa389006599
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 06:36:03 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7IAZkdU014179
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 06:35:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1108436nfc.21
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 03:35:45 -0700 (PDT)
Message-ID: <de8cad4d0808180335l7a6f9377m97c3eff844e187ee@mail.gmail.com>
Date: Mon, 18 Aug 2008 06:35:45 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1218939204.3591.25.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<1217986174.5252.7.camel@morgan.walls.org>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
	<1218070521.2689.15.camel@morgan.walls.org>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
	<1218205108.3003.44.camel@morgan.walls.org>
	<de8cad4d0808111433y4620b726wc664a06d7422e883@mail.gmail.com>
	<1218939204.3591.25.camel@morgan.walls.org>
Cc: Waffle Head <narflex@gmail.com>, video4linux-list@redhat.com,
	linux-dvb@linuxtv.org, ivtv-devel@ivtvdriver.org
Subject: Re: CX18 Oops
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

On Sat, Aug 16, 2008 at 10:13 PM, Andy Walls <awalls@radix.net> wrote:
> On Mon, 2008-08-11 at 17:33 -0400, Brandon Jenkins wrote:
>> On Fri, Aug 8, 2008 at 10:18 AM, Andy Walls <awalls@radix.net> wrote:
>> > Brandon,
>> >
>> > I have checked in a fix to defend against the Ooops we both encountered.
>> > The fix will also generate a WARN dump and some queue stats when it runs
>> > across the cause, but will otherwise try to clean up as best it can to
>> > allow further operation.
>> >
>> > The band-aid fix is the latest change at
>> >
>> > http://linuxtv.org/hg/~awalls/v4l-dvb
>> >
>> > Please provide the extra debug that happens if you encounter the warning
>> > in your logs.  I have only encountered the problem twice over a several
>> > month period, so its hard to get insight into the root cause buffer
>> > accounting error at that rate.
>>
>> Andy,
>>
>> I had an oops today, first one in a few days
>>
>> Brandon
>
> Brandon & Jeff,
>
> I have updated my repo at
>
> http://linuxtv.org/hg/~awalls/v4l-dvb
>
> with 3 changes:
>
> 1. Back out the original band aid fix
> 2. Simplify the queue flush routines (you will not see that oops again)
> 3. Fix the interrupt handler to obtain a queue lock (prevents queue
> corruption)
>
> >From most of the output you provided, it was pretty obvious that q_full
> was always claiming to have more buffers that it actually did.  I
> hypothesized this could come about at the end of a capture when the
> encoder hadn't really stopped transferring buffers yet (after we told it
> to stop) and then we try to clear q_full while the interrupt handler is
> still trying to add buffers.  This could happen because the interrupt
> handler never (ever) properly obtained a lock for manipulating the
> queues.  This could have been causing the queue corruption.
>
> Please test.  I need feedback that I haven't introduced a deadlock.
>
> It also appears that the last change requiring the interrupt handler to
> obtain a lock, completely mitigates me having to use the "-cache 8192"
> option to mplayer for digital captures, and greatly reduces the amount
> of cache I need to have mplayer use for analog captures.
>
[snip]

Andy,

I have update to the new code. Interestingly now I am getting audio
noises (chirping) while watching TV. Is there anything which has been
done that could affect sound?

Otherwise no issues thus far.

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
