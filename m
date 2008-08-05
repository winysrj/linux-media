Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m75HLPiK027881
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 13:21:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m75HKBKf005869
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 13:20:43 -0400
Date: Tue, 5 Aug 2008 13:19:42 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080806023906.c2f919b4.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.1.10.0808051315440.22576@bombadil.infradead.org>
References: <20080806012357.55625daf.sfr@canb.auug.org.au>
	<20080805154122.GC22895@cs181140183.pp.htv.fi>
	<20080806020647.2cf11a2b.sfr@canb.auug.org.au>
	<20080805092650.af88364a.akpm@linux-foundation.org>
	<20080806023906.c2f919b4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-mips@linux-mips.org, video4linux-list@redhat.com,
	Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
	v4l-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: v4l/mips build problem
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

On Wed, 6 Aug 2008, Stephen Rothwell wrote:

> Hi Andrew,
>
> On Tue, 5 Aug 2008 09:26:50 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> yup, I'll send it in unless it turned up in today's linux-next.
>
> Which I think is unlikely:  the v4l/dvb tree has been unmergable since
> 29/7 and I haven't heard from Mauro since then.
Too busy during those days. I don't mind if Andrew prefer to forward this 
directly, but I have another bunch of patches to send Linus probably 
today.

I did some changes on the procedures I use for sending patches upstream, 
but I want to do some additional tests here to be sure that everything is 
all right. The idea is never rebase my main branches again.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
