Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3U84lXK004703
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 04:04:47 -0400
Received: from znsun1.ifh.de (znsun1.ifh.de [141.34.1.16])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3U84GCv031943
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 04:04:18 -0400
Date: Wed, 30 Apr 2008 10:02:43 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080429185009.716c3284@gaivota>
Message-ID: <Pine.LNX.4.64.0804300953140.480@pub4.ifh.de>
References: <20080429185009.716c3284@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates and fixes
 for 2.6.26
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

sorry to say that now and not earlier, but:

On Tue, 29 Apr 2008, Mauro Carvalho Chehab wrote:
> .../{dvb/frontends => common/tuners}/mt2266.c      |    0
> .../{dvb/frontends => common/tuners}/mt2266.h      |    4 +-

The mt2266 is a zero-IF (baseband) tuner. I think there is no analog 
decoder for this kind of tuners.

Maybe the move was not necessary, but maybe all tuners should go to 
common.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
