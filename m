Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o094F4rS004335
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 23:15:05 -0500
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o094EoaJ020727
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 23:14:51 -0500
Subject: Re: Compiling xawtv - libzvbi.h error
From: hermann pitton <hermann-pitton@arcor.de>
To: Stuart McKim <mckim@lifetime.oregonstate.edu>
In-Reply-To: <20100108235715.GC4535@gazelle.rmt.insightsnow.com>
References: <20100108235715.GC4535@gazelle.rmt.insightsnow.com>
Date: Sat, 09 Jan 2010 05:03:09 +0100
Message-Id: <1263009789.3087.1.camel@pc07.localdom.local>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Freitag, den 08.01.2010, 15:57 -0800 schrieb Stuart McKim:
> I am trying to compile xawtv-3.95, but I have run into an error I can't
> seem to figure out the source of. I'm not sure if it's a mistake in my
> installation of zvbi or xawtv.
> 
> In order, I installed:
> tv-fonts-1.1 (successful)
> zvbi-0.2.33  (successful)
> xawtv-3.95   (failed)
> 
> My procedure for building xawtv is:
> ./configure
> make
> 
> The output from make is:
> mckim@eckleburg ~/builds/xawtv-3.95 $ make
>   CC      console/dump-mixers.o
>   LD      console/dump-mixers
>   CC      console/record.o
>   LD      console/record
>   CC      console/showriff.o
>   LD      console/showriff
>   CC      console/showqt.o
>   LD      console/showqt
>   CC      console/streamer.o
> In file included from ./common/commands.h:1,
>                  from console/streamer.c:32:
> ./common/vbi-data.h:5:21: error: libzvbi.h: No such file or directory
> In file included from ./common/commands.h:1,
>                  from console/streamer.c:32:
> ./common/vbi-data.h:10: error: expected specifier-qualifier-list before 'vbi_decoder'
> ./common/vbi-data.h:36: warning: 'struct vbi_event' declared inside parameter list
> ./common/vbi-data.h:36: warning: its scope is only this definition or declaration, which is probably not what you want
> ./common/vbi-data.h:37: warning: 'struct vbi_char' declared inside parameter list
> ./common/vbi-data.h:39: warning: 'struct vbi_decoder' declared inside parameter list
> ./common/vbi-data.h:42: warning: 'struct vbi_page' declared inside parameter list
> ./common/vbi-data.h:43: warning: 'struct vbi_page' declared inside parameter list
> In file included from console/streamer.c:32:
> ./common/commands.h:28: warning: 'struct vbi_page' declared inside parameter list
> make: *** [console/streamer.o] Error 1
> 
> 
> When I tried to locate libzvbi.h, the only copy I found is in the build
> directory for zvbi-0.2.33.
> 
> Can somebody please help me get pointed in the right direction? I am
> running Slackware64-13.0 on a 2.6.29.6 kernel.
> 
> Thanks,
> Stuart

what about, as always, installing zvbi-devel in such case?

Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
