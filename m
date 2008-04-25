Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3P7WFGT020251
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 03:32:15 -0400
Received: from web27914.mail.ukl.yahoo.com (web27914.mail.ukl.yahoo.com
	[217.146.182.64])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3P7W2HC016832
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 03:32:03 -0400
Date: Fri, 25 Apr 2008 08:31:57 +0100 (BST)
From: "Edward J. Sheldrake" <ejs1920@yahoo.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0804240658580.3725@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <58176.88846.qm@web27914.mail.ukl.yahoo.com>
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

--- Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Thanks for your help, Edward. I've applied the patch that seems to be
> the 
> correct one. It will select the MTS firmware, so, only MONO will be 
> available. The proper SCODE table will be loaded.
> 
> Btw, it would be nice if you could also test DVB mode. It should be 
> working properly for HVR-900.
> 
> Cheers,
> Mauro.
> 
Thanks, I updated v4l-dvb to 7737, and analog tv is now working fine.

As for DVB, we need to define a new board type for use in em28xx-dvb.c.
I have rev. B3C0 (same as B2C0 I think). I tried hacking em28xx-dvb.c
to call drx397xD_attach, but nothing happened. Also:

- I have no idea how to fill in drx397xD_config
- The get_dvb_firmware script doesn't support drx397xD yet
- There's no digital signal where I live

But I'll keep updating v4l-dvb, you're doing great work!

--

Edward Sheldrake


      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
