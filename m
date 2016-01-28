Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58772 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbcA1S5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 13:57:15 -0500
Subject: Re: [PATCH 13/31] media: au0828 fix au0828_create_media_graph()
 entity checks
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <ab77ed92dafb05b262a33fcd827f35ad8be3d619.1452105878.git.shuahkh@osg.samsung.com>
 <20160128133728.5fa54fa3@recife.lan>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
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
	johan@oljud.se, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-api@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56AA6487.5040300@osg.samsung.com>
Date: Thu, 28 Jan 2016 11:57:11 -0700
MIME-Version: 1.0
In-Reply-To: <20160128133728.5fa54fa3@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/2016 08:37 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:27:02 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> au0828_create_media_graph() doesn't do any checks to determine,
>> if vbi_dev, vdev, and input entities have been registered prior
>> to creating pad links. Checking graph_obj.mdev field works as
>> the graph_obj.mdev field gets initialized in the entity register
>> interface. Fix it to check graph_obj.mdev field before creating
>> pad links.
> 
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/usb/au0828/au0828-core.c | 27 +++++++++++++++++----------
>>  1 file changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
>> index f46fb43..8ef7c71 100644
>> --- a/drivers/media/usb/au0828/au0828-core.c
>> +++ b/drivers/media/usb/au0828/au0828-core.c
>> @@ -291,20 +291,27 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  		if (ret)
>>  			return ret;
>>  	}
>> -	ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
>> -				    &dev->vdev.entity, 0,
>> -				    MEDIA_LNK_FL_ENABLED);
>> -	if (ret)
>> -		return ret;
>> -	ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
>> -				    &dev->vbi_dev.entity, 0,
>> -				    MEDIA_LNK_FL_ENABLED);
>> -	if (ret)
>> -		return ret;
>> +	if (dev->vdev.entity.graph_obj.mdev) {
>> +		ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
>> +					    &dev->vdev.entity, 0,
>> +					    MEDIA_LNK_FL_ENABLED);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> Those new if() doesn't look right. We can't continue if the entities
> weren't registered, as the graph would have troubles. The logic should
> ensure that the entities will always be created before running 
> au0828_create_media_graph(). If this is not the case, some async
> logic is needed to ensure that.

There have been some changes in au0828 media init and
register sequence in 4.5-rc1. wau0828 does its graph
creation before it registers media_device.

I needed these checks before this above. It looks
like I might have simply rebased my patch over
without taking this change into account. I will
try without these checks.

Async method is already in place for snd-usb-audio
part of the graph. Please see patch 20 in the series.

thanks,
-- Shuah

> 
>> +	if (dev->vbi_dev.entity.graph_obj.mdev) {
>> +		ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
>> +					    &dev->vbi_dev.entity, 0,
>> +					    MEDIA_LNK_FL_ENABLED);
>> +		if (ret)
>> +			return ret;
>> +	}
>>  
>>  	for (i = 0; i < AU0828_MAX_INPUT; i++) {
>>  		struct media_entity *ent = &dev->input_ent[i];
>>  
>> +		if (!ent->graph_obj.mdev)
>> +			continue;
>> +
>>  		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
>>  			break;
>>  


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
