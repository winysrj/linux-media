Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m39LbjwY028664
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 17:37:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m39LbJ9a018356
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 17:37:20 -0400
Date: Wed, 9 Apr 2008 18:35:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Maykel Moya <moya-lists@infomed.sld.cu>
Message-ID: <20080409183536.3dd3fea4@areia>
In-Reply-To: <1205649437.2771.13.camel@gloria.red.sld.cu>
References: <1205282139.17131.28.camel@gloria.red.sld.cu>
	<20080312180944.3a7e8447@gaivota>
	<1205359734.47d85476111af@webmail.sld.cu>
	<20080313102628.7507d02b@gaivota>
	<1205468182.3027.3.camel@gloria.red.sld.cu>
	<20080314105458.2dd2a284@gaivota>
	<1205649437.2771.13.camel@gloria.red.sld.cu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
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

On Sun, 16 Mar 2008 02:37:17 -0400
Maykel Moya <moya-lists@infomed.sld.cu> wrote:

> 
> El vie, 14-03-2008 a las 10:54 -0300, Mauro Carvalho Chehab escribió:
> 
> > > This firmware did load correctly but the computer locked up when
> > > accessing the device. I tried with tvtime and xawtv.
> > 
> > Those apps don't work well with tm6000, since they want to force the driver to
> > work on non-supported resolutions.
> > 
> > Try mplayer:
> > 
> > mplayer -tv driver=v4l2 tv://
> 
> I did run mplayer. First time it didn't launch the video output window
> and I had to interrupt it manually with Ctrl + C. After that I did run
> it again, this time it launched the video window and freezes the
> machine.

Sorry for not answering earlier. I was flooded with work here. I've updated
tm6010 tree. Yet, there are still several issues to be solved. Basically,
videobuf-vmalloc has several bugs fixed. I didn't touch on tm6000 part yet.

I expect to write some new code there soon.

> qv4l2 don't compile

You need all those qt development libs in order to compile it.

> CC decode_tm6000.o
> In file included from decode_tm6000.c:19:
> ../lib/v4l2_driver.h:26: error: expected specifier-qualifier-list before
> ‘size_t’
> decode_tm6000.c: In function ‘recebe_buffer’:
> decode_tm6000.c:133: error: ‘struct v4l2_t_buf’ has no member named
> ‘length’
> decode_tm6000.c:135: error: ‘struct v4l2_t_buf’ has no member named
> ‘length’
> decode_tm6000.c:136: error: ‘struct v4l2_t_buf’ has no member named
> ‘length’
> make[1]: *** [decode_tm6000.o] Error 1
> make[1]: se sale del directorio
> `/home/moya/src/tm6010-upstream/v4l2-apps/util'

Weird. However, I didn't work on this decoding code for quite some time.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
