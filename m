Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m52K0l44008356
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 16:00:47 -0400
Received: from m2.goneo.de (m2.goneo.de [82.100.220.83])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m52K0MR4027327
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 16:00:23 -0400
From: Jan Frey <linux@janfrey.de>
To: video4linux-list@redhat.com
Date: Mon, 2 Jun 2008 21:58:53 +0200
References: <1212092787.7328.16.camel@skoll> <1212323843.4184.7.camel@skoll>
In-Reply-To: <1212323843.4184.7.camel@skoll>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200806022158.54175.linux@janfrey.de>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: Hauppauge HVR-1300 analog troubles
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

Hi Jonatan,

I'm quite successfully using this code here:
http://linuxtv.org/hg/~rmcc/hvr-1300/

And additionally I have all the v4l modules unloaded and reloaded via 
rc.local to get the tuner up reliably.

Regards,
Jan

On Sunday 01 June 2008, Jonatan Åkerlind wrote:
> An update:
>
> I booted the system up today and modprobed tuner with debug=1 and cx88xx
> with audio_debug=1 ir_debug=1 and tried to scan for channels and this
> time everything worked just fine. Tried unloading the modules and
> reloading everything without debugging and it still works. I cannot
> really tell what is different this time from all my other attempts at
> this but anyway it seems to be working.
>
> Now, is there any possibility to get the mpeg2-encoder working? I'm
> using the cx88-blackbird module but i'm not really sure if or what
> firmware I should be downloading to the card.
>
> /Jonatan
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
-- 
Jan Frey
linux [at] janfrey.de

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
