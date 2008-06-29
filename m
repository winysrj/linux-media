Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TIbquQ031734
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 14:37:52 -0400
Received: from pne-smtpout2-sn1.fre.skanova.net
	(pne-smtpout2-sn1.fre.skanova.net [81.228.11.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TIb2oF011218
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 14:37:18 -0400
Message-ID: <4867D624.5090504@gmail.com>
Date: Sun, 29 Jun 2008 20:36:20 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <48674B80.6030107@hhs.nl>
In-Reply-To: <48674B80.6030107@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: Re: Announcing libv4l 0.3 aka "the cheese release"
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

Hi Hans and thanks for your hard work!

Are there any plans on supporting frame resizing within the v4lconvert 
framework?

Regards,
Erik Andrén

Hans de Goede wrote:
> Hi All,
> 
> I'm happy to announce version 0.3 of libv4l:
> http://people.atrpms.net/~hdegoede/libv4l-0.3.tar.gz
> 
> This release has the following changes (mostly bugfixes):
> 
> libv4l-0.3
> ----------
> * add extern "C" magic to public header files for c++ usage (Gregor Jasny)
> * Make libv4l1 and libv4l2 multithread use safe, see README.multi-threading
> * Add v4lx_dup() calls (and intercept dup() from the wrappers) this fixes
>   use with gstreamer's v4l2 plugin (tested with cheese)
> * Hopefully definitely fix compile errors on systems with a broken 
> videodev2.h
> 
> 
> The big improvement here is that gstreamer using applications now work 
> without any caveats.
> 
> I also believe / hope that this release fixes the compile problems some 
> people where having.
> 
> Regards,
> 
> Hans
> 
> -- 
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
