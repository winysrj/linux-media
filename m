Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4HGngv032383
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 12:16:49 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB4HFnV4026342
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 12:16:00 -0500
Date: Thu, 4 Dec 2008 12:15:46 -0500
From: Jim Paris <jim@jtan.com>
To: Jean-Francois Moine <moinejf@free.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Message-ID: <20081204171546.GA27230@psychosis.jim.sh>
References: <patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
	<20081204130557.85799da0.ospite@studenti.unina.it>
	<patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204130557.85799da0.ospite@studenti.unina.it>
	<1228378442.1733.17.camel@localhost>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 4] ov534 patches
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

Hi Jean, Antonio,

Jean-Francois Moine wrote:
> Thank you for these patchs. Some changes were already done in my
> repository. I merged them and pushed. May you check if everything is
> correct?

I took a brief look and the merge looks OK, thanks.

> Also, I moved the last fid and pts to the sd structure. This allows many
> webcams to work simultaneously. I was wondering about the reset of these
> variables: last_fid is never reset and last_pts is reset on
> UVC_STREAM_EOF. Shouldn't they also be reset on streaming start?

I didn't consider multiple cameras.  Moving them of course makes sense
for that.  I did think of the reset case and thought it was OK, but
given Antonio's report below there might need to be some fixes in here
anyway.

Antonio Ospite wrote:
> Tested the latest version, I am getting "payload error"s setting
> frame_rate=50, loosing about 50% of frames. I tried raising
> bulk_size but then I get "frame overflow" errors from gspca, I'll
> investigate further.

I don't think I see any payload errors even at 50fps.  For the bulk
size, I'm not sure exactly how the payloads work into that.  I suppose
that when bulk_size is larger than the camera's payload size (2048),
we get another payload header at data[2048] but don't pay attention to
it.  If this header had the EOF then we can send gspca too much data,
causing frame overflow.  (there's no overflow check in ov534 since
gspca handles it already).

With the current setup, we're essentially getting a UVC stream.  This
makes sense since the marketing for ov534 says it supports UVC.  So
some documentation for this would be
  http://www.usb.org/developers/devclass_docs/USB_Video_Class_1_1.zip

This header and payload format is handled by a couple drivers that I
found:

  linux/drivers/media/video/uvc/uvc_video.c
     uvc_video_decode_start
     uvc_video_decode_data
     uvc_video_decode_end
     
  (I thought there was another Linux driver that also handled this
   payloads itself, but now I can't find it again)

  http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/usb/uvideo.c?rev=1.99
     uvideo_vs_decode_stream_header

Some discussion I found on payload headers in bulk transfers is here

  http://osdir.com/ml/linux.drivers.uvc.devel/2007-05/msg00036.html

Maybe finding a way to switch to isoc would make things easier?

-jim

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
