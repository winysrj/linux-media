Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36328 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759087AbcCDUoh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 15:44:37 -0500
Subject: Re: [PATCH] media: add prefixes to interface types
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com
References: <1457050112-6831-1-git-send-email-shuahkh@osg.samsung.com>
 <56D9468C.3090205@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56D9F3B3.2070601@osg.samsung.com>
Date: Fri, 4 Mar 2016 13:44:35 -0700
MIME-Version: 1.0
In-Reply-To: <56D9468C.3090205@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

Mauro,

Do you prefer dvb-conditional-access or dvb-ca?

thanks,
-- Shuah

On 03/04/2016 01:25 AM, Hans Verkuil wrote:
> 
> 
> On 03/04/2016 01:08 AM, Shuah Khan wrote:
>> Add missing prefixes for DVB, V4L, and ALSA interface types.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/media-entity.c | 32 ++++++++++++++++----------------
>>  1 file changed, 16 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index bcd7464..561c939 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -46,41 +46,41 @@ static inline const char *intf_type(struct media_interface *intf)
>>  {
>>  	switch (intf->type) {
>>  	case MEDIA_INTF_T_DVB_FE:
>> -		return "frontend";
>> +		return "dvb-frontend";
>>  	case MEDIA_INTF_T_DVB_DEMUX:
>> -		return "demux";
>> +		return "dvb-demux";
>>  	case MEDIA_INTF_T_DVB_DVR:
>> -		return "DVR";
>> +		return "dvb-DVR";
> 
> 'dvb-dvr', everything else is lower case as well.
> 
>>  	case MEDIA_INTF_T_DVB_CA:
>> -		return  "CA";
>> +		return  "dvb-conditional-access";
> 
> I'd keep this 'dvb-ca', unless Mauro likes this better.
> 
>>  	case MEDIA_INTF_T_DVB_NET:
>> -		return "dvbnet";
>> +		return "dvb-net";
>>  	case MEDIA_INTF_T_V4L_VIDEO:
>> -		return "video";
>> +		return "v4l-video";
>>  	case MEDIA_INTF_T_V4L_VBI:
>> -		return "vbi";
>> +		return "v4l-vbi";
>>  	case MEDIA_INTF_T_V4L_RADIO:
>> -		return "radio";
>> +		return "v4l-radio";
>>  	case MEDIA_INTF_T_V4L_SUBDEV:
>>  		return "v4l2-subdev";
> 
> Change this to 'v4l-subdev'.
> 
>>  	case MEDIA_INTF_T_V4L_SWRADIO:
>> -		return "swradio";
>> +		return "v4l-swradio";
>>  	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
>> -		return "pcm-capture";
>> +		return "alsa-pcm-capture";
>>  	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
>> -		return "pcm-playback";
>> +		return "alsa-pcm-playback";
>>  	case MEDIA_INTF_T_ALSA_CONTROL:
>>  		return "alsa-control";
>>  	case MEDIA_INTF_T_ALSA_COMPRESS:
>> -		return "compress";
>> +		return "alsa-compress";
>>  	case MEDIA_INTF_T_ALSA_RAWMIDI:
>> -		return "rawmidi";
>> +		return "alsa-rawmidi";
>>  	case MEDIA_INTF_T_ALSA_HWDEP:
>> -		return "hwdep";
>> +		return "alsa-hwdep";
>>  	case MEDIA_INTF_T_ALSA_SEQUENCER:
>> -		return "sequencer";
>> +		return "alsa-sequencer";
>>  	case MEDIA_INTF_T_ALSA_TIMER:
>> -		return "timer";
>> +		return "alsa-timer";
>>  	default:
>>  		return "unknown-intf";
>>  	}
>>
> 
> Regards,
> 
> 	Hans
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
