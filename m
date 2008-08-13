Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.237])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <czhang1974@gmail.com>) id 1KTIqy-0000m3-Ka
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 18:05:41 +0200
Received: by wr-out-0506.google.com with SMTP id 50so46394wra.13
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 09:05:35 -0700 (PDT)
Message-ID: <bd41c5f0808130905y30efc79m84bdcf5128c425a@mail.gmail.com>
Date: Wed, 13 Aug 2008 16:05:35 +0000
From: "Chaogui Zhang" <czhang1974@gmail.com>
To: "Paul Marks" <paul@pmarks.net>
In-Reply-To: <8e5b27790808122233r539e6404y777e2bade7c78b47@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <8e5b27790808120058o52c4c6bcw21152364b2613c39@mail.gmail.com>
	<8e5b27790808122233r539e6404y777e2bade7c78b47@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] FusionHDTV5 IR not working.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, Aug 13, 2008 at 5:33 AM, Paul Marks <paul@pmarks.net> wrote:
> On Tue, Aug 12, 2008 at 12:58 AM, Paul Marks <paul@pmarks.net> wrote:
>> I have a DViCO FusionHDTV5 RT Gold, with an IR sensor that connects to
>> the back of the card.  The remote is a "Fusion Remote MCE".  The video
>> capture stuff works just fine, but I've had no such luck with the
>> remote.
>
> Just to confirm some things:
> - The remote control works using DViCO's software on Windows Vista x64.
> - The remote is not detected in Ubuntu 8.04.1
>
> I normally run Gentoo with kernel 2.6.26, but I tested with an Ubuntu
> Live CD, to be sure I wasn't forgetting some trivial kernel module.
>

Do the following and see if it works:

Power off your system (don't just reboot), then unplug power, wait for
20 seconds and plug it back in then start your Ubuntu.

If this works, that means the IR receiver got messed up somehow and
only a complete power cut can reset it. I have seen this happening
tons of times when I tried to get the IR on my HDTV5 RT Gold to work
last summer.

-- 
Chaogui Zhang

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
