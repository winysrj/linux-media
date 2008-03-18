Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2ICSUdu029335
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 08:28:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2ICRi4a013752
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 08:27:45 -0400
Date: Tue, 18 Mar 2008 09:26:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <20080318092648.3a517301@gaivota>
In-Reply-To: <200803161131.37966.zzam@gentoo.org>
References: <200803161131.37966.zzam@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [PATCH] Updated analog only support of Avermedia A700 cards -
 adds RF input support via XC2028 tuner (untested)
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

On Sun, 16 Mar 2008 11:31:37 +0100
Matthias Schwarzott <zzam@gentoo.org> wrote:

> Hi there!
> 
> I updated this patch to support both Avermedia A700 cards (AverTV DVB-S Pro 
> and AverTV DVB-S Hybrid+FM).
> 
> The RF input of the Hybrid+FM card (with XC2028 tuner) is still untested.
> 
> I would be happy if any of the XC2028 experts could have a look at this patch.

For this to work, you'll need to set xc3028 parameters. This device needs a
reset during firmware load. This is done via xc3028_callback. To reset, you
need to turn some GPIO values, and then, return they back to their original
values. The GPIO's are device dependent. So, you'll need to check with some
software like Dscaler's regspy.exe what pins are changed during reset.

Also, there are two ways for audio to work with xc3028/2028: MTS mode and
non-mts. You'll need to test both ways.

A final notice: most current devices work fine with firmware v2.7. However, a
few devices only work if you use an older firmware version.

Could you please send us the logs with i2c_scan=1?

Please, use the latest version of v4l-dvb, since I did some fixes for cx88 and
saa7134 there recently.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
