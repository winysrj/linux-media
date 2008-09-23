Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8NB8jD2019203
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 07:08:45 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8NB8Q20002807
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 07:08:27 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1769877fga.7
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 04:08:25 -0700 (PDT)
Message-ID: <48D8CE26.3040104@gmail.com>
Date: Tue, 23 Sep 2008 13:08:22 +0200
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: dabby bentam <db260179@hotmail.com>
References: <BLU116-W45ED43A6BD49AF4EF5916AC24B0@phx.gbl>
	<1222117083.2983.14.camel@pc10.localdom.local>
	<BLU116-W22ED124457AE21528EA59BC24B0@phx.gbl>
In-Reply-To: <BLU116-W22ED124457AE21528EA59BC24B0@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] FIXME: audio doesn't work on svideo/composite
 -	hvr-1110 S-Video and Composite
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

dabby bentam a écrit :
> Yipee...
>
> I've attached a working saa7134-cards.c from an ubuntu 2.6.24-19.36 
> kernel. Not sure the mask setting is correct? as v4ctl -list comes up 
> as television on all three inputs, but as soon as you switch via 
> tvtime, it comes up correctly?
>
> Also its LINE1 not LINE2!
>
> You still have to redirect the sound via sox or arecord - pci dma i 
> guess? and unmute it. But its a start.
>
> Radio is not tested!
>
> Anymore suggestions on tweaking this. Both S-video and Composite have 
> sound now!!!
>
Very good work.

I am impatient to see your config and results

Cheers,

Thomas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
