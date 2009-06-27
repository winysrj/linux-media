Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5RA5UoN027543
	for <video4linux-list@redhat.com>; Sat, 27 Jun 2009 06:05:30 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n5RA5DY2022109
	for <video4linux-list@redhat.com>; Sat, 27 Jun 2009 06:05:15 -0400
Date: Sat, 27 Jun 2009 12:05:03 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: eric.paturage@orange.fr
Message-ID: <20090627120503.2fe8362e@free.fr>
In-Reply-To: <200906270947.n5R9lwG04574@neptune.localwarp.net>
References: <200906270947.n5R9lwG04574@neptune.localwarp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: STV06xx and 046d:0840 "Logitech, Inc. QuickCam Express" /
 "Dexxa cam" (not working)
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

On Sat, 27 Jun 2009 11:47:36 +0200 (CEST)
eric.paturage@orange.fr wrote:

> Hello 

Hello Eric,

You should not use this list. The right one for Linux media is:
	linux-media@vger.kernel.org

> I am trying to get my Dexxa cam to work with the "new" driver
> STV06xx . no success so far ...
> the tests here, have been done with the version of v4l that comme
> with 2.6.29.4 i get the same with 2.6.30  . i have also tried the v4l
> "mercurial" from a few days ago . ---->same it does not work. 
	[snip]
> Are  there any tests or further debug i can do , to help find out
> what is the problem with this driver ? 
> according to a post from Hans de Goede in January , Camera with
> HDCS-1000/1100 sensor might or might not work (further testing
> needed . I have a feeling that timing issues are involved , as i get
> a garbage picture with debug on , and a time-out without debug ...

You give here the result of an old version (2.6.29). For such problems,
you should always use the last mercurial version from LinuxTv.

The maintainer of this subdriver is Erik Andrén (see Cc:). Erik, may
you help Eric?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
