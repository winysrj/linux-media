Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OB1jgj027465
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 07:01:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OB1Zf0027026
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 07:01:35 -0400
Date: Thu, 24 Apr 2008 07:01:34 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Edward J. Sheldrake" <ejs1920@yahoo.co.uk>
In-Reply-To: <916086.24458.qm@web27912.mail.ukl.yahoo.com>
Message-ID: <Pine.LNX.4.64.0804240658580.3725@bombadil.infradead.org>
References: <916086.24458.qm@web27912.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com
Subject: Re: em28xx/xc3028: changeset 7651 breaks analog audio?
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

On Thu, 24 Apr 2008, Edward J. Sheldrake wrote:

>> Please, try again, with with the enclosed patch. Let's see if stereo
>> will work
>> on your board.
>>
>> This should load the IF=6.24 firmware, non-MTS mode.

> This did not work, all I could hear was silence, with clicking at 1
> second intervals. The clicking stopped after opening and closing
> mplayer a few times, but that's another issue.
>
> I've got a pdf and a small text file of product info (which I can't
> find any URLs for), which both say mono audio for analogue, also in
> Windows, Mono audio is the only available option, so I think stereo is
> not supported.
>
> Dmesg output attached, it's not loading mts firmware this time.

Thanks for your help, Edward. I've applied the patch that seems to be the 
correct one. It will select the MTS firmware, so, only MONO will be 
available. The proper SCODE table will be loaded.

Btw, it would be nice if you could also test DVB mode. It should be 
working properly for HVR-900.

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
