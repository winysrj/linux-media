Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n76JM4bj004601
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 15:22:04 -0400
Received: from mail-yw0-f197.google.com (mail-yw0-f197.google.com
	[209.85.211.197])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n76JLknM003243
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 15:21:46 -0400
Received: by ywh35 with SMTP id 35so1410387ywh.19
	for <video4linux-list@redhat.com>; Thu, 06 Aug 2009 12:21:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7B2BDB.5000906@tmr.com>
References: <4A7B2BDB.5000906@tmr.com>
Date: Thu, 6 Aug 2009 15:21:46 -0400
Message-ID: <829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bill Davidsen <davidsen@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux M/L <video4linux-list@redhat.com>
Subject: Re: Is there any working video capture card which works and is
	still made?
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

On Thu, Aug 6, 2009 at 3:15 PM, Bill Davidsen<davidsen@tmr.com> wrote:
> I have a lovely collection of capture cards which either don't work or are
> no longer available new. Is there any such card?
>
> Note: I can't tell a client to buy hardware on eBay, or to patch a kernel,
> or commit to providing patched kernel... and we're in Time-Warned land,
> where the signal is a mix of clear digital, crypto-digital, and NTSC. I
> *can* tell someone to spend money to get something supported, which they
> could buy in some small quantity.
>
> I would be happy with a box like the HDhomerun, which does a nice job on the
> tiny list of clear digital signals, the Hauppauge HVR-2250 is ideal, but
> doesn't work because the driver isn't in the kernel and the windows stuff
> doesn't run on ndiswrapper (too complex to support anyway).
>
> Any thoughts, or is it just not currently happening?
>
> --
> bill davidsen <davidsen@tmr.com>
>  CTO TMR Associates, Inc
>
> "You are disgraced professional losers. And by the way, give us our money
> back."
>   - Representative Earl Pomeroy,  Democrat of North Dakota
> on the A.I.G. executives who were paid bonuses  after a federal bailout.

There are lots of cards that work.  The big questions lie in what bus
type you need (USB/PCI/PCIe), and what featureset (ATSC, ClearQAM,
analog, IR, etc.)

Might also be nice what your large collection is composed of, since we
might be able to get some of them to work.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
