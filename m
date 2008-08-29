Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TB5wtF028561
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 07:05:58 -0400
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TB5ji1011227
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 07:05:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Date: Fri, 29 Aug 2008 13:05:33 +0200
References: <48B7D198.60505@hhs.nl>
In-Reply-To: <48B7D198.60505@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291305.33835.hverkuil@xs4all.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [v4l-dvb-maintainer] gspca-sonixb and sn9c102 produce
	incompatible V4L2_PIX_FMT_SN9C10X
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

On Friday 29 August 2008 12:38:16 Hans de Goede wrote:
> Hi all,
>
> I've been working on adding support for raw bayer output to
> gspca-sonixb, so that it has feature parity on this point with
> sonixb, and we can move tested cams over (as gspca-sonixb has other
> features which sonixb lacks) without regressions.
>
> While doing this I noticed that if I disable the compression in the
> bridge gspca produces raw GBRG bayer data, just like the compressed
> data is GBRG after decompression, but the sn9c102 driver produces raw
> BGGR data. Some further investigation has found that this is caused
> by a small difference in the way the 2 drivers program register 0x12
> (hstart) of the bridge. In gspca there are several init tables (one
> per sensor) with things like this:
>
>          0x00, 0x01, 0x00, 0x46, 0x09, 0x0a,     /* shift from 0x45
> 0x09 0x0a */
>
> Notice the comment that the 0x46 used to be 0x45 this is the value
> for the hstart register, and the sn9c102 driver has the 0x45 value
> here. This starting one pixel later (then both sn9c102 and windows)
> of the gspca sonixb driver causes the change from BGGR to GBRG bayer.
> The problem here is that the bayer in the compressed data after
> decompressoon also changes. So the data produced as
> V4L2_PIX_FMT_SN9C10X is different between the gspca-sonixb driver and
> the sn9c102 driver, also libv4l currently only works correctly with
> the gspca driver. Whereas existing applications which directly
> understand V4L2_PIX_FMT_SN9C10X such as sonic-snap only work correct
> with the sn9c102 driver.
>
> I see 2 possible solutions:
>
> 1) Fix the gspca driver and libv4l to produce / expect BGGR bayer
> inside the V4L2_PIX_FMT_SN9C10X data, making gspca compatible with
> the already released in an official kernel sn9c102 driver. The
> downside of this is that we loose all the testing done with gspca
> (both v1 and v2) with the current gspca settings but given that
> windows uses the sn9c102 settings I don't expect much of a problem
> from this (and I can test the new settings for 3 of the 7 supported
> sensors).

Sounds good.

> 2) Add a new V4L2_PIX_FMT_SN9C10X_GBRG format for the gspca driver,
> although this avoids making changes with possible regressions to
> gspca, its too ugly for words IMHO.

Sounds not so good :-)

> I'll be writing a patch against gspca and submitting it for this
> soon, but first I wanted to give you all a headsup and give you
> chance to tell me how bad my idea how to solve this is.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
