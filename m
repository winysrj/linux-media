Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1LJK3C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 05:29:02 -0500
Message-ID: <4EE3345E.5050304@redhat.com>
Date: Sat, 10 Dec 2011 08:28:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB: dvb_frontend: fix delayed thread exit
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com> <4EE252E5.2050204@iki.fi> <4EE25A3C.9040404@redhat.com> <4EE25CB4.3000501@iki.fi> <4EE287A9.3000502@redhat.com> <CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com> <4EE29BA6.1030909@redhat.com> <4EE29D1A.6010900@redhat.com> <4EE2B7BC.9090501@linuxtv.org> <CAGoCfizNCqHv1iwrFNTdOxpawVB3NzJnOF=U4hn8CXZQne=Vkw@mail.gmail.com> <4EE2BE97.6020209@linuxtv.org> <CAGoCfiyx6JR_MiVdC=ZGw_G-hzrE7O8mZp1a8of8=PcxW_P82g@mail.gmail.com>
In-Reply-To: <CAGoCfiyx6JR_MiVdC=ZGw_G-hzrE7O8mZp1a8of8=PcxW_P82g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 00:25, Devin Heitmueller wrote:
> Hello Andreas,
>
> On Fri, Dec 9, 2011 at 9:06 PM, Andreas Oberritter<obi@linuxtv.org>  wrote:
>> WTF, Devin, you again? I haven't asked anyone to upstream it. Feel free
>> to analyze the code and resubmit it.
>
> 1.  It's marked with a subject line that starts with "[PATCH]"
> 2.  It has your SIgned-Off-By line.
> 3.  it was sent to the mailing list.
> 4.  It doesn't have any keywords like "RFC" or "proposed".

Devin,

You're over-reacting. This patch were a reply from Andreas to a thread,
and not a separate patch submission.

Patches like are generally handled as RFC, especially since it doesn't
contain a description.

> If you don't intend for it to go upstream then don't do all of the above.
>
> I'm not sure if your "WTF, Devin, you again?" is some indication that
> I'm annoying you.  The last patch you submitted that touches the
> threading in dvb_frontend.c had a host of problems and was clearly not
> well researched (i.e. "DVB: dvb_frontend: convert semaphore to
> mutex").  As in this case, there is no background indicating that this
> patch has been fully thought out and due diligence has been done.
>
> Maybe you have thoroughly researched the change, taken the time to
> fully understand its effects, and tested it with a variety of boards
> and scenarios.  Without a good patch description, there is no way to
> know.
>
> I apologize if you're inconvenienced if I'm making an active effort to
> prevent poorly documented changes from getting merged (which often
> result in regressions).  Oh wait, I'm not sorry at all.  Nevermind.
>
> Devin
>

Regards,
Mauro
