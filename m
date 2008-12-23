Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBN89ONU005062
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 03:09:24 -0500
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBN898Ae006237
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 03:09:08 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Kelvin Smith <kelvins@kelhome.dyndns.org>
In-Reply-To: <1230011500.30985.8.camel@goofy.kelhome.nz>
References: <1230011500.30985.8.camel@goofy.kelhome.nz>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 23 Dec 2008 09:08:40 +0100
Message-Id: <1230019720.1943.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: cannot get pac7311 data viewed by anything....
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

On Tue, 2008-12-23 at 18:51 +1300, Kelvin Smith wrote:
	[snip]
> Have a Philips SPC610NC webcam.  I have installed the snapshots from the
> linuxtv.org website, and plugging in my camera.  Below is the output
> from v4l-info.  I used to be able to go xawtv -d /dev/video0 and see a
> picture, now it is corrupt/missing.  I gather because the picture format
> is in PJPG is the reason why I cannot see any picture (just black
> screen, or black with random dots down 1/3 of the image).  
> 
> How do I get this to work with applications like XAWTV and zoneminder.
	[snip]

You must use the v4l library (look at my page).

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
