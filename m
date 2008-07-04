Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6458s2K012008
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 01:08:54 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6458djW001522
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 01:08:39 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1421230rvb.51
	for <video4linux-list@redhat.com>; Thu, 03 Jul 2008 22:08:38 -0700 (PDT)
Message-ID: <68cac7520807032208g456ed51bw6c8da9305755e06d@mail.gmail.com>
Date: Fri, 4 Jul 2008 02:08:38 -0300
From: "Douglas Schilling Landgraf" <dougsland@gmail.com>
To: "Video 4 Linux" <video4linux-list@redhat.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>, moinejf@free.fr,
	"Ivan Brasil Fuzzer" <ivan@fuzzer.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: [v4l-dvb-maintainer] [PULL]
	http://linuxtv.org/hg/~dougsland/spca508a
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

Hi Mauro,

Please pull from http://linuxtv.org/hg/~dougsland/spca508a for the following:

- Added ID vendor/product for Clone Digital Webcam 11043.
  Thanks to Ivan Brasil Fuzzer <ivan@fuzzer.com.br> for testing and
data collection.

# Added/removed/changed files:
# linux/Documentation/video4linux/gspca.txt |    1 +
# linux/drivers/media/video/gspca/spca508.c |    4 ++++
# 2 files changed, 5 insertions(+)

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
