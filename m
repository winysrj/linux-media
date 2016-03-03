Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33959 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbcCCP5J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 10:57:09 -0500
Subject: Re: [PATCH v3 02/22] uapi/media.h: Declare interface types for ALSA
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@osg.samsung.com,
	tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
 <a1b468c2933dc2b4f2b6cc6d1ac30baee2a89f77.1455233152.git.shuahkh@osg.samsung.com>
 <56D85161.5070103@xs4all.nl>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi,
	ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com,
	k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	elfring@users.sourceforge.net, prabhakar.csengg@gmail.com,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com, labbott@fedoraproject.org,
	pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com,
	julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de,
	misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56D85ECF.40807@osg.samsung.com>
Date: Thu, 3 Mar 2016 08:57:03 -0700
MIME-Version: 1.0
In-Reply-To: <56D85161.5070103@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2016 07:59 AM, Hans Verkuil wrote:
> On 02/12/16 00:41, Shuah Khan wrote:
>> Declare the interface types to be used on alsa for
>> the new G_TOPOLOGY ioctl.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/media-entity.c | 16 ++++++++++++++++
>>  include/uapi/linux/media.h   | 10 ++++++++++
>>  2 files changed, 26 insertions(+)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index f2e4360..6179543 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -65,6 +65,22 @@ static inline const char *intf_type(struct media_interface *intf)
>>  		return "v4l2-subdev";
>>  	case MEDIA_INTF_T_V4L_SWRADIO:
>>  		return "swradio";
>> +	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
>> +		return "pcm-capture";
>> +	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
>> +		return "pcm-playback";
>> +	case MEDIA_INTF_T_ALSA_CONTROL:
>> +		return "alsa-control";
>> +	case MEDIA_INTF_T_ALSA_COMPRESS:
>> +		return "compress";
>> +	case MEDIA_INTF_T_ALSA_RAWMIDI:
>> +		return "rawmidi";
>> +	case MEDIA_INTF_T_ALSA_HWDEP:
>> +		return "hwdep";
>> +	case MEDIA_INTF_T_ALSA_SEQUENCER:
>> +		return "sequencer";
>> +	case MEDIA_INTF_T_ALSA_TIMER:
>> +		return "timer";
> 
> Wouldn't it be better to add an 'alsa' prefix for all of these?
> 
> And 'dvb-' or 'v4l2-' (or v4l-) for the others as well.
> 
> Names like 'timer' are very generic. I think it would be a good idea to
> make the naming more regular and have it include the subsystem name just
> as the define does.
> 
> Regards,
> 
> 	Hans
> 

Yes adding more information 'dvb-' or 'v4l2-' (or v4l-), alsa
to strings would help. I can fix all of them in a separate
patch if that is okay with you.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
