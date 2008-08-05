Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m75Kbprx015593
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 16:37:52 -0400
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m75KbBix002298
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 16:37:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 5 Aug 2008 22:37:09 +0200
References: <200806121535.30530.janne-dvb@grunau.be>
	<200806130836.49227.hverkuil@xs4all.nl>
	<200806131247.03511.janne-dvb@grunau.be>
In-Reply-To: <200806131247.03511.janne-dvb@grunau.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808052237.09552.hverkuil@xs4all.nl>
Cc: 
Subject: Re: [RFC] Extend V4L MPEG Encoding API, add AVC and AAC
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

Hi Janne,

I noticed that this patch wasn't merged in v4l-dvb. Do you want me to do 
it? I'm adding the AC3 audio encoding format as well for another board, 
so it might be a good time to merge this patch at the same time.

Regards,

	Hans

On Friday 13 June 2008 12:47:03 Janne Grunau wrote:
> On Friday 13 June 2008 08:36:49 Hans Verkuil wrote:
> > Looks good! Make sure you also document these in the v4l2 spec.
>
> But it wasn't. I missed to update v4l2_ctrl_query_fill_std()
> with the new max values. Updated patch below.
>
> Janne
>
> ----
>
> Extend V4L MPEG Encoding API with AVC and AAC
>
> From: Janne Grunau <j@jannau.net>
>
> Adds Advanced Audio Coding (AAC) and MPEG-4 Advanced Video Coding
> (AVC/H.264) as audio/video codecs to the extended controls API.
>
> Signed-off-by: Janne Grunau <j@jannau.net>
>
> diff -r 87878a6b80a8 -r a8438761721d
> linux/drivers/media/video/v4l2-common.c ---
> a/linux/drivers/media/video/v4l2-common.c	Fri Jun 13 11:21:43 2008
> +0200 +++ b/linux/drivers/media/video/v4l2-common.c	Fri Jun 13
> 11:29:04 2008 +0200 @@ -359,7 +359,7 @@ int
> v4l2_ctrl_query_fill(struct v4l2_que /* MPEG controls */
>  	case V4L2_CID_MPEG_CLASS: 		name = "MPEG Encoder Controls"; break;
>  	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ: name = "Audio Sampling
> Frequency"; break; -	case V4L2_CID_MPEG_AUDIO_ENCODING: 	name =
> "Audio Encoding Layer"; break; +	case V4L2_CID_MPEG_AUDIO_ENCODING:
> 	name = "Audio Encoding"; break; case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
> 	name = "Audio Layer I Bitrate"; break; case
> V4L2_CID_MPEG_AUDIO_L2_BITRATE: 	name = "Audio Layer II Bitrate";
> break; case V4L2_CID_MPEG_AUDIO_L3_BITRATE: 	name = "Audio Layer III
> Bitrate"; break; @@ -494,7 +494,7 @@ int
> v4l2_ctrl_query_fill_std(struct v4l2 case
> V4L2_CID_MPEG_AUDIO_ENCODING:
>  		return v4l2_ctrl_query_fill(qctrl,
>  				V4L2_MPEG_AUDIO_ENCODING_LAYER_1,
> -				V4L2_MPEG_AUDIO_ENCODING_LAYER_3, 1,
> +				V4L2_MPEG_AUDIO_ENCODING_AAC, 1,
>  				V4L2_MPEG_AUDIO_ENCODING_LAYER_2);
>  	case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
>  		return v4l2_ctrl_query_fill(qctrl,
> @@ -536,7 +536,7 @@ int v4l2_ctrl_query_fill_std(struct v4l2
>  	case V4L2_CID_MPEG_VIDEO_ENCODING:
>  		return v4l2_ctrl_query_fill(qctrl,
>  				V4L2_MPEG_VIDEO_ENCODING_MPEG_1,
> -				V4L2_MPEG_VIDEO_ENCODING_MPEG_2, 1,
> +				V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 1,
>  				V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
>  	case V4L2_CID_MPEG_VIDEO_ASPECT:
>  		return v4l2_ctrl_query_fill(qctrl,
> diff -r 87878a6b80a8 -r a8438761721d linux/include/linux/videodev2.h
> --- a/linux/include/linux/videodev2.h	Fri Jun 13 11:21:43 2008 +0200
> +++ b/linux/include/linux/videodev2.h	Fri Jun 13 11:29:04 2008 +0200
> @@ -923,6 +923,7 @@ enum v4l2_mpeg_audio_encoding {
>  	V4L2_MPEG_AUDIO_ENCODING_LAYER_1 = 0,
>  	V4L2_MPEG_AUDIO_ENCODING_LAYER_2 = 1,
>  	V4L2_MPEG_AUDIO_ENCODING_LAYER_3 = 2,
> +	V4L2_MPEG_AUDIO_ENCODING_AAC     = 3,
>  };
>  #define V4L2_CID_MPEG_AUDIO_L1_BITRATE 		(V4L2_CID_MPEG_BASE+102)
>  enum v4l2_mpeg_audio_l1_bitrate {
> @@ -1005,8 +1006,9 @@ enum v4l2_mpeg_audio_crc {
>  /*  MPEG video */
>  #define V4L2_CID_MPEG_VIDEO_ENCODING 		(V4L2_CID_MPEG_BASE+200)
>  enum v4l2_mpeg_video_encoding {
> -	V4L2_MPEG_VIDEO_ENCODING_MPEG_1 = 0,
> -	V4L2_MPEG_VIDEO_ENCODING_MPEG_2 = 1,
> +	V4L2_MPEG_VIDEO_ENCODING_MPEG_1     = 0,
> +	V4L2_MPEG_VIDEO_ENCODING_MPEG_2     = 1,
> +	V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC = 2,
>  };
>  #define V4L2_CID_MPEG_VIDEO_ASPECT 		(V4L2_CID_MPEG_BASE+201)
>  enum v4l2_mpeg_video_aspect {
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
