Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3DGI6gY032541
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 12:18:06 -0400
Received: from web902.biz.mail.mud.yahoo.com (web902.biz.mail.mud.yahoo.com
	[216.252.100.42])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3DGHsVj020892
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 12:17:54 -0400
Date: Sun, 13 Apr 2008 18:17:54 +0200 (CEST)
From: Markus Rechberger <mrechberger@empiatech.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Video <video4linux-list@redhat.com>
In-Reply-To: <454886.97234.qm@web901.biz.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <93606.67558.qm@web902.biz.mail.mud.yahoo.com>
Cc: 
Subject: RE: [ANNOUNCE] Videobuf improvements to allow its usage with USB
	drivers
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


> === message truncated ===
> This is the performance tests I did, running >
code_example to get 1,000
 frames
> @29.995 Hz (about 35 seconds of stream), tested on a
i386 machine,
>  running at
> 1,5GHz:

>         The old driver:

> $ time -f "%E: %Us User time, %Ss Kernel time, %P
CPU used"
>  ./capture_example
> 0:34.21: 8.22s User time, 25.16s Kernel time, 97% 
CPU used

>        The videobuf-based driver:

> $ time -f "%E: %Us User time, %Ss Kernel time, %P
CPU used"
>  ./capture_example
> 0:35.36: 0.01s User time, 0.05s Kernel time, 0% CPU
used

>        Conclusion:

> The time consumption to receive the stream where 
reduced from about
 33.38
> seconds to 0.05 seconds

the question is moreover what made capture_example go
up to 100% CPU in the first try and to 0% in the
second one.
I'm not sure about the old implementation in the
original driver, although I'm just curious about the
details here. xawtv usually uses very little cputime
at all. 
If I use 
"$ time mplayer tv:// -tv driver=v4l2" it shows up 

real 0m40.972s
user 0m0.230s
sys  0m0.050s

your benchmark is a bit unclear.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
