Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m13E6ReF008343
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 09:06:27 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.186])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m13E650q010890
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 09:06:06 -0500
Received: by rv-out-0910.google.com with SMTP id k15so1339022rvb.51
	for <video4linux-list@redhat.com>; Sun, 03 Feb 2008 06:06:05 -0800 (PST)
Message-ID: <fea7c4860802030606v6614d884i1a5e71980709739f@mail.gmail.com>
Date: Sun, 3 Feb 2008 14:06:05 +0000
From: "Andy McMullan" <andy@andymcm.com>
To: video4linux-list@redhat.com
In-Reply-To: <fea7c4860802030504k60ab0466ta03572a9083a69e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fea7c4860802030504k60ab0466ta03572a9083a69e@mail.gmail.com>
Subject: Re: bt878 'interference' on fc6 but not fc1
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

> I've been using a Hauppauge WinTv (bt878) card with fedora core 1 for
> some time with no problems.  Yesterday I added a Fedora Core 6
> installation to the same PC (dual-boot), but when running FC6 I see a
> sort of wavey flickery interference pattern.   Switch back to FC1 and
> there's no interference.

Well, I've discovered that if my TV is off, the interference goes
away, so obviously it's electrical interference from the TV.   I
really don't understand how that would show up in FC6 and not FC1,
though.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
