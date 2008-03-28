Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SF4hUK029667
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 11:04:43 -0400
Received: from web904.biz.mail.mud.yahoo.com (web904.biz.mail.mud.yahoo.com
	[216.252.100.44])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2SF4PJw009599
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 11:04:29 -0400
Date: Fri, 28 Mar 2008 16:04:11 +0100 (CET)
From: Markus Rechberger <mrechberger@empiatech.com>
To: Mat <heavensdoor78@gmail.com>
In-Reply-To: <47ED03EB.4070708@gmail.com>
MIME-Version: 1.0
Message-ID: <731850.15654.qm@web904.biz.mail.mud.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Empia em28xx based USB video device...
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



Mat <heavensdoor78@gmail.com> schrieb: 
ARGH, you are righttt ! :)
Thank you for the tip Markus, very useful.

Ok, I post some info about the device for future reference:

Brand: Digitus
Model: DA-70820
ID eb1a:2821 eMPIA Technology, Inc.
Site: http://www.digitus.info/scripts/digdetail.asp?artnr=DA-70820

I'll try to get hold of such a device next month for going through all input options (S-Video/Composite/NTSC/PAL/SECAM).

Markus
Module used: em28xx
Params: card=9
( Pinnacle Dazzle DVC 90/DVC 100 )
I had few tests for now... xawtv: ok... v4l2 small test app: ok...
I dunno if it's stable but it seems to work.

Markus Rechberger wrote:
> On 3/28/08, Mat  wrote:
>   
> ...
> this one is connected to a usb 1.1 port .. the driver doesn't work
> with usb 1.1 (at least not yet).
>
> Is there any productlink available?
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
