Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7KInlbQ001789
	for <video4linux-list@redhat.com>; Wed, 20 Aug 2008 14:49:47 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7KInV6F007361
	for <video4linux-list@redhat.com>; Wed, 20 Aug 2008 14:49:32 -0400
Received: by fg-out-1718.google.com with SMTP id e21so394925fga.7
	for <video4linux-list@redhat.com>; Wed, 20 Aug 2008 11:49:31 -0700 (PDT)
Message-ID: <aad488990808201149n956d58ej544a07da93f33336@mail.gmail.com>
Date: Wed, 20 Aug 2008 11:49:30 -0700
From: "Simoes Vincent" <boelraty.altern@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <470378.52874.qm@web28411.mail.ukl.yahoo.com>
MIME-Version: 1.0
References: <470378.52874.qm@web28411.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: Timestamp and buffer
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

I feel free to answer to this question, because I have the same problem. For
the moment, I have just avoided the problem by deleting the first images. If
someone has an idea on the value we need to set in the timestamp, it would
be great.

Thanks
Vincent

2008/8/11 Malsoaz James <jmalsoaz@yahoo.fr>

> Hello,
>
> I'm trying to capture some images with a camera in a repetitive way.
> Unfortunately each time I'm launching my program the first images are not
> good and match with a previous capture. It seems  that the problem comes
> from the size of the buffer I'm using and that to solve the problem I have
> to change the timestamp of the buffer. However I don't know what are the
> value I have to set in the timestamp.
>
> I hope someone would be able to help me.
> Thank you
> James
>
>
>
>
>  _____________________________________________________________________________
> Envoyez avec Yahoo! Mail. Une boite mail plus intelligente
> http://mail.yahoo.fr
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subjectunsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
