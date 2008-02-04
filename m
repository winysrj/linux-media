Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m14M8q5H016756
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 17:08:52 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.189])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m14M8UgG024581
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 17:08:31 -0500
Received: by rv-out-0910.google.com with SMTP id k15so1687637rvb.51
	for <video4linux-list@redhat.com>; Mon, 04 Feb 2008 14:08:25 -0800 (PST)
Message-ID: <fea7c4860802041408j21689c54v568c976f4173a463@mail.gmail.com>
Date: Mon, 4 Feb 2008 22:08:24 +0000
From: "Andy McMullan" <andy@andymcm.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080204072233.073d40da@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fea7c4860802030504k60ab0466ta03572a9083a69e@mail.gmail.com>
	<fea7c4860802030606v6614d884i1a5e71980709739f@mail.gmail.com>
	<20080204072233.073d40da@gaivota>
Cc: video4linux-list@redhat.com
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

> Maybe it have something to do with some power saving cycle at the processor.
> You may try to change powersave governor policy and see the results.

Thanks for the suggestion.  I tried turning off the cpuspeed service,
and even totally disabling acpi in the kernel, but it didn't make any
difference.  (I don't know much about cpu throttling on linux, but I
assume it relies on ACPI)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
