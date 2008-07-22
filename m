Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MHENPI010347
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 13:14:23 -0400
Received: from web63007.mail.re1.yahoo.com (web63007.mail.re1.yahoo.com
	[69.147.96.218])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6MHE6bg032119
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 13:14:06 -0400
Date: Tue, 22 Jul 2008 10:14:00 -0700 (PDT)
From: Fritz Katz <frtzkatz@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <859073.27528.qm@web63007.mail.re1.yahoo.com>
Subject: xawtv fails to compile with quicktime
Reply-To: frtzkatz@yahoo.com
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

The V2L application xawtv appears to be broken if compiled with quicktime libraries.

The video4linux-list is mentioned as the proper discussion forum for xawtv at the bottom of the page: http://bytesex.org/xawtv/ 

I'm on a FreeBSD-7 system, but the same bug has also been filed against xawtv on Gentoo and Debian. Quicktime changed how colormodels are handled several years ago (~2004?) and I guess xawtv never heard about it. 

It's broken in xawtv-3.95 and the same code is used in the 4.x snapshot.

Unfortunately, the various distros make releases with multiple patches for problems -- but don't send fixes back upstream. FreeBSD-7 has 10 patches on xawtv-3.95. Some of these might be important bugfixes. If someone's interested, I can zip them up and email them to you.

Here's a link to the source of the offending code:
http://www.cs.fsu.edu/~baker/devices/lxr/http/source/xawtv-3.95/libng/plugins/write-qt.c

Here's where it fails in my environment:
# uname -smr
FreeBSD 7.0-RELEASE i386

  Installed:
	/usr/ports/multimedia/libquicktime (libquicktime-1.0.2)

  Attempted install:
	/usr/ports/multimedia/xawtv (xawtv-3.95, with patches, original from http://bytesex.org/xawtv/ )

	libng/plugins/write-qt.c: In function 'video_list':
	libng/plugins/write-qt.c:351: error: 'lqt_codec_info_t' has no member named 'num_encoding_colormodels'
	libng/plugins/write-qt.c:353: error: 'lqt_codec_info_t' has no member named 'encoding_colormodels'
	libng/plugins/write-qt.c:354: error: 'lqt_codec_info_t' has no member named 'encoding_colormodels'
	libng/plugins/write-qt.c:381: error: 'lqt_codec_info_t' has no member named 'num_encoding_colormodels'
	libng/plugins/write-qt.c:382: error: 'lqt_codec_info_t' has no member named 'encoding_colormodels'

---------------------
Here's the failure on Debian Linux, 

    http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=9;bug=392576

Debian's 'fix' was to disable libquicktime support:

---------------------
Here's the failure on Gentoo Linux:

    http://bugs.gentoo.org/141429

We're in luck here, someone wrote a patch that looks like it might work. Needs to be verified by someone knowledgeable of Quicktime:

---------------------------------
--- xawtv-3.95/libng/plugins/write-qt.c.old     2006-10-16 20:50:45.000000000 +0200 
 +++ xawtv-3.95/libng/plugins/write-qt.c 2006-10-17 19:36:09.000000000 +0200 
 @@ -348,10 +348,10 @@ 
                     info[i]->name,info[i]->long_name); 
             for (j = 0; j < info[i]->num_fourccs; j++) 
                 fprintf(stderr,"   fcc   : %s\n",info[i]->fourccs[j]); 
 -           for (j = 0; j < info[i]->num_encoding_colormodels; j++) 
 +           for (j = 0; j < lqt_num_colormodels(); j++) 
                 fprintf(stderr,"   cmodel: %d [%s]\n", 
 -                       info[i]->encoding_colormodels[j], 
 -                       lqt_get_colormodel_string(info[i]->encoding_colormodels[j])); 
 +                       lqt_get_colormodel(j), 
 +                       lqt_get_colormodel_string(j)); 
         } 
 
         /* sanity checks */ 
 @@ -378,8 +378,8 @@ 
         /* pick colormodel */ 
         fmtid  = VIDEO_NONE; 
         cmodel = 0; 
 -       for (j = 0; j < info[i]->num_encoding_colormodels; j++) { 
 -           cmodel = info[i]->encoding_colormodels[j]; 
 +       for (j = 0; j < lqt_num_colormodels(); j++) { 
 +           cmodel = lqt_get_colormodel(j); 
             if (cmodel>= sizeof(cmodels)/sizeof(int)) 
                 continue; 
             if (!cmodels[cmodel]) 
---------------------------------
It's one or two lines off, so it failed to apply on my system. But it's easy enough to just make the changes by hand.

Regards,
-- Fritz_Katz




      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
