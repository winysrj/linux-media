Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m39LxLRf009908
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 17:59:21 -0400
Received: from S3.cableone.net (s3.cableone.net [24.116.0.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m39Lx7G3030625
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 17:59:07 -0400
Received: from [72.24.208.253] (unverified [72.24.208.253])
	by S3.cableone.net (CableOne SMTP Service S3) with ESMTP id
	151595823-1872270
	for <video4linux-list@redhat.com>; Wed, 09 Apr 2008 14:59:02 -0700
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 9 Apr 2008 16:44:14 -0500
References: <1205282139.17131.28.camel@gloria.red.sld.cu>
	<1205649437.2771.13.camel@gloria.red.sld.cu>
	<20080409183536.3dd3fea4@areia>
In-Reply-To: <20080409183536.3dd3fea4@areia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200804091644.14833.vanessaezekowitz@gmail.com>
Content-Transfer-Encoding: 8bit
Subject: Re: Problems setting up a TM5600 based device
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


> Maykel Moya <moya-lists@infomed.sld.cu> wrote:
> >
> > CC decode_tm6000.o
> > In file included from decode_tm6000.c:19:
> > ../lib/v4l2_driver.h:26: error: expected specifier-qualifier-list before
> > ‘size_t’
> > decode_tm6000.c: In function ‘recebe_buffer’:
> > decode_tm6000.c:133: error: ‘struct v4l2_t_buf’ has no member named
> > ‘length’
> > decode_tm6000.c:135: error: ‘struct v4l2_t_buf’ has no member named
> > ‘length’
> > decode_tm6000.c:136: error: ‘struct v4l2_t_buf’ has no member named
> > ‘length’
> > make[1]: *** [decode_tm6000.o] Error 1
> > make[1]: se sale del directorio
> > `/home/moya/src/tm6010-upstream/v4l2-apps/util'

Does he have Qt4 installed by any chance?   This looks like the same error I ran into.  For me, the makefile calls the system's default qmake, which is supplied by Qt4, instead of calling the Qt3-specific copy.

-- 
"Life is full of happy and sad events.  If you take the time
to concentrate on the former, you'll get further in life."
Vanessa Ezekowitz  <vanessaezekowitz@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
