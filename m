Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7BDqhxv028155
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 09:52:43 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7BDqRub026795
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 09:52:30 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1161608fga.7
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 06:52:27 -0700 (PDT)
Message-ID: <37219a840808110652n7c7f919ajfba184f4776bcd99@mail.gmail.com>
Date: Mon, 11 Aug 2008 09:52:26 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: mark.paulus@verizonbusiness.com
In-Reply-To: <48A0407F.8020104@verizonbusiness.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A0407F.8020104@verizonbusiness.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Help with recent DVB/QAM problem please.
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

2008/8/11 Mark Paulus <mark.paulus@verizonbusiness.com>:
> Hi all,
>
> Background:
> I have a machine in my basement with:
> Hauppauge PVR-150 (connected to DCT2524)
> Air2PC ATSC/OTA card (connected to antenna in attic)
> Avermedia A180 (connected to comcast cable)
> Dvico FusionHDTV RT 5 Lite (connectec comcast cable)
> Debian using 2.6.24-x64 kernel
>
> Situation:
> Up until a week ago, I was able to use azap to tune in
> a bunch of mplexids, and get good locks on both the A180 and the Dvico card.
>  However, starting on Monday,
> I am not able to get locks on either of my DVB cards.
> I have been able, and am still able to get good locks
> on my air2pc OTA card.
>
> Can anyone help me figure out why I can't seem to see
> anything from my 2 QAM cards?  I've tried running a
> dvbscan and neither card can make a good lock.

What variables have changed in your test environment since last Monday?

If the answer is "nothing" , then the problem is more than likely due
to your cable company moving services around.

First, you should confirm that you still have clear QAM available...
assuming yes, then I recommend scanning for channels again.

BTW, this question is off-topic for this mailing list -- video4linux
deals with analog video -- better luck on linux-dvb mailing list.
(see www.linuxtv.org for mailing list subscription info)

HTH,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
