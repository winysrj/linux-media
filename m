Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HLMcCx026807
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 17:22:38 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7HLMRtm012504
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 17:22:28 -0400
Date: Sun, 17 Aug 2008 23:22:05 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: litlle girl <little.linux.girl@gmail.com>
Message-ID: <20080817212205.GA1133@daniel.bse>
References: <9e27f5bf0808170627n556116d5rb0af4771c525af88@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e27f5bf0808170627n556116d5rb0af4771c525af88@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Kworld mpeg tv station / PCI [KW-TV878-FBKM]
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

On Sun, Aug 17, 2008 at 03:27:38PM +0200, litlle girl wrote:
> mute isnt working
> this is my /etc/modprobe.d/bttv
> options bttv tuner=5 radio=1 pll=1 gpiomask=0x008007 audiomux=0,3,3,3,3

Unfortunately it is not possible to set the GPIO mute mask directly with
module parameters.

Try
options bttv card=5 tuner=5 radio=1 pll=1 gpiomask=0x8007 audiomux=0,1,0,0

This card should get a card entry in bttv-cards.c

> Why Audiomu acceps only 5 values? At Sound-Faq there are 6 values.

In fact it accepts only 4 values
- TV Tuner
- Radio
- External connector
- Internal connector

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
