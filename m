Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42336 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab1HOKTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 06:19:39 -0400
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com> <1313226504.2840.22.camel@gagarin> <CAC3jWvLszU4gTSVW0mXUFrhnHCpPWRUqErytF9jXs39sbCJd3Q@mail.gmail.com> <1313400289.1648.22.camel@gagarin>
In-Reply-To: <1313400289.1648.22.camel@gagarin>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [mythtv-users] Anyone tested the DVB-T2 dual tuner TBS6280?
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 15 Aug 2011 06:19:49 -0400
To: Lawrence Rust <lvr@softsystem.co.uk>,
	Discussion about MythTV <mythtv-users@mythtv.org>
CC: linux-media@vger.kernel.org
Message-ID: <3976b67f-b55f-44c2-99fe-ef3968105563@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lawrence Rust <lvr@softsystem.co.uk> wrote:

>On Sun, 2011-08-14 at 17:50 +0200, Harald Gustafsson wrote:
>> Thanks for sharing your experience.
>> 
>[snip]
>> > Be warned that if you run a 2.6.38 or later kernel then the IR RC
>won't
>> > work because of significant changes to the RC architecture that TBS
>> > don't like (see
>http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=929 and
>> > http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=110&start=90#p2693
>)
>> 
>> In the links you refer to the driver author (at least he seems to be
>> the author) states that he has not upgraded to the latest IR code due
>> to compatibility issues between the CX23885 and IR.
>
>The TBS cards use the same cx23885 device that the Hauppauge HVR 1250 &
>1850 use, both of which support RC input.  The problem, as I understand
>it, is that in some modes the cx23885 can produce an interrupt storm.
>
>Given that the current v4l RC architecture is unlikely to change
>significantly in the near future then instead of bleating, perhaps TBS
>should contribute a fix.  However, given that to date all of TBS's code
>has been kept private then that's unlikely.  So the TBS Linux drivers
>are likely to become increasingly incompatible with current Linux
>kernels.
>
>I have a need to use my 6981 card so I'm developing my own fix for the
>RC problem.  I'll post this to linuxmedia when I'm happy it's sound.
>
>Incidentally, the latest TBS 6981 driver OOPS with linux 2.6.39 even
>though their release note says "Ensure compatibility with latest
>ArchLinux (with kernel 2.6.39.2-1)".  This is due to a change in an i2c
>driver structure in 2.6.39 and is a direct consequence of TBS shipping
>object modules built with old kernel headers.
>
>Be warned, the h/w is sound but the software & support suck.
>
>-- 
>Lawrence
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

One of the bigger problems with the cx23885 driver and hardware was that things don't appear to work well with MSI enabled in the driver.  Hack your version of the driver to make sure MSI is not enabled for CX2388[578] chips.

As far as the unclearable IR interrupt with MSI disabled, I've only seen that with the CX23885 on nonHauppauge cards; the CX23888 seems to be ok.  I'm sure the problem on nonHauppauge cards is simply me no knowing for sure how some of the pins on the CX23885 were wired up.

-Andy
