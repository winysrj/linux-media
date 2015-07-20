Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33075 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbGTTCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:02:44 -0400
Date: Mon, 20 Jul 2015 22:01:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	crope@iki.fi, sakari.ailus@linux.intel.com, arnd@arndb.de,
	stefanr@s5r6.in-berlin.de, ruchandani.tina@gmail.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 6/7] media: au0828 change to use Managed Media Controller
 API
Message-ID: <20150720190128.GM5422@mwanda>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
 <3643452be528b2e53cea592db22b4e0ada32456b.1436917513.git.shuahkh@osg.samsung.com>
 <20150720084220.GG5422@mwanda>
 <55AD1A06.3040902@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55AD1A06.3040902@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 20, 2015 at 09:55:50AM -0600, Shuah Khan wrote:
> >>  #ifdef CONFIG_MEDIA_CONTROLLER
> >> -	if (dev->media_dev) {
> >> -		media_device_unregister(dev->media_dev);
> >> -		kfree(dev->media_dev);
> >> -		dev->media_dev = NULL;
> >> +	if (dev->media_dev &&
> >> +		media_devnode_is_registered(&dev->media_dev->devnode)) {
> >> +			media_device_unregister_entity_notify(dev->media_dev,
> >> +							&dev->entity_notify);
> >> +			media_device_unregister(dev->media_dev);
> >> +			dev->media_dev = NULL;
> > 
> > 
> > The indenting is slightly off here.  It should be:
> > 
> > 	if (dev->media_dev &&
> > 	    media_devnode_is_registered(&dev->media_dev->devnode)) {
> > 		media_device_unregister_entity_notify(dev->media_dev,
> > 						      &dev->entity_notify);
> > 		media_device_unregister(dev->media_dev);
> > 		dev->media_dev = NULL;
> > 	}
> > 
> > Aligning if statements using spaces like that is nicer and checkpatch.pl
> > won't complain.
> > 
> 
> Yeah. I try to do that whenever. In this case, if I align, the line
> becomes longer than 80 chars adding more things to worry about. In
> such cases, I tend to not worry about aligning.

The main thing is that the body of the if statement is intended 16
spaces instead of 8.  Otherwise I wouldn't have commented.

regards,
dan carpenter
