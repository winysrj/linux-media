Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59361 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934499AbcA1Ubc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 15:31:32 -0500
Subject: Re: [PATCH 31/31] media: au0828 change to check media device
 unregister progress state
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <eed3343dc1c690e8c7e656d1cc162777d73fc62b.1452105878.git.shuahkh@osg.samsung.com>
 <20160128150538.1ba8fc7c@recife.lan>
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
Message-ID: <56AA7A9B.40204@osg.samsung.com>
Date: Thu, 28 Jan 2016 13:31:23 -0700
MIME-Version: 1.0
In-Reply-To: <20160128150538.1ba8fc7c@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/2016 10:05 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:27:20 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Change au0828_unregister_media_device() to check media
>> device media device unregister is in progress and avoid
>> calling media_device_unregister() and other cleanup done
>> in au0828_unregister_media_device().
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/usb/au0828/au0828-core.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
>> index 886fb28..de357a2 100644
>> --- a/drivers/media/usb/au0828/au0828-core.c
>> +++ b/drivers/media/usb/au0828/au0828-core.c
>> @@ -136,7 +136,9 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
>>  
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>  	if (dev->media_dev &&
>> -		media_devnode_is_registered(&dev->media_dev->devnode)) {
>> +		media_devnode_is_registered(&dev->media_dev->devnode) &&
>> +		!media_device_is_unregister_in_progress(dev->media_dev)) {
>> +
> 
> A kref would likely work better here.

Hope you saw my response to[PATCH 29/31] on why ensuring
two drivers don't get into unregister is necessary.

Could you please elaborate on kref. Are you saying adding
kref to struct media_device?

thanks,
-- Shuah
> 
>>  		media_device_unregister(dev->media_dev);
>>  		media_device_cleanup(dev->media_dev);
>>  		dev->media_dev = NULL;


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
