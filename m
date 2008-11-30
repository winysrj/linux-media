Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAUJiNsA017847
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 14:44:23 -0500
Received: from tomts36-srv.bellnexxia.net (tomts36.bellnexxia.net
	[209.226.175.93])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAUJhVZN001791
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 14:43:31 -0500
Received: from toip7.srvr.bell.ca ([209.226.175.124])
	by tomts36-srv.bellnexxia.net
	(InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP id
	<20081130194327.CPSW1669.tomts36-srv.bellnexxia.net@toip7.srvr.bell.ca>
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 14:43:27 -0500
From: Bill Pringlemeir <bpringle@sympatico.ca>
To: video4linux-list@redhat.com
References: <87fxlff09v.fsf@sympatico.ca> <87fxl9m0lh.fsf@sympatico.ca>
Date: Sun, 30 Nov 2008 15:40:34 -0500
In-Reply-To: <87fxl9m0lh.fsf@sympatico.ca> (Bill Pringlemeir's message of
	"Sun, 30 Nov 2008 15:15:54 -0500")
Message-ID: <87prkdkkvx.fsf@sympatico.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: KWorld ATSC 110 and NTSC
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


Possibly more helpful config information,

gzip -dc /proc/config.gz | egrep '^[^\#]*(DVB|MEDIA|VIDEO)'
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_DVB_CAPTURE_DRIVERS=y
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_MT352=y
CONFIG_DVB_TDA10048=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_PLL=m
CONFIG_DVB_ISL6421=m
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_VIDEO_SELECT=y

On 30 Nov 2008, bpringle@sympatico.ca wrote:

> $ gzip -dc /proc/config.gz | egrep '^[^\#]*(DVB|MEDIA)'
> CONFIG_DVB_CORE=y
> CONFIG_VIDEO_MEDIA=y

[...]

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
