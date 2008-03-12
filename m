Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2CNYVIb010552
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 19:34:31 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2CNXxvG000742
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 19:33:59 -0400
Received: by wr-out-0506.google.com with SMTP id 67so2404948wri.3
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 16:33:59 -0700 (PDT)
Date: Wed, 12 Mar 2008 16:33:49 -0700
From: Brandon Philips <brandon@ifup.org>
To: Carl Karsten <carl@personnelware.com>
Message-ID: <20080312233349.GA1753@plankton.ifup.org>
References: <47CB2689.3010707@personnelware.com>
	<47CB6801.4060503@personnelware.com>
	<47CC3E8D.4070801@personnelware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC3E8D.4070801@personnelware.com>
Cc: video4linux-list@redhat.com
Subject: Re: vivi.c stuck my CPU
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

On 12:08 Mon 03 Mar 2008, Carl Karsten wrote:
> > If someone will point me in the right direction, I'll write a test app to 
> > reproduce this.
> 
>  I see Brandon beat me to it.

I have ripped vivi apart and it no longer locks up in most cases.  :D

However, I need to finish fixing up the videobuf layer to be thread safe
before it will all be complete.  I will submit patches as soon as my
work is done :)

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
