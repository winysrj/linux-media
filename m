Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53566 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbbGTOWd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 10:22:33 -0400
Message-ID: <55AD0417.5000401@osg.samsung.com>
Date: Mon, 20 Jul 2015 08:22:15 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>,
	Dan Carpenter <dan.carpenter@oracle.com>
CC: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, perex@perex.cz, crope@iki.fi,
	sakari.ailus@linux.intel.com, arnd@arndb.de,
	stefanr@s5r6.in-berlin.de, ruchandani.tina@gmail.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 7/7] sound/usb: Update ALSA driver to use Managed Media
 Controller API
References: <cover.1436917513.git.shuahkh@osg.samsung.com> <656c6578247d86262b7999d85db9f9995058eb36.1436917513.git.shuahkh@osg.samsung.com> <20150720084746.GH5422@mwanda> <s5hio9ffbjw.wl-tiwai@suse.de>
In-Reply-To: <s5hio9ffbjw.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2015 03:00 AM, Takashi Iwai wrote:
> On Mon, 20 Jul 2015 10:47:46 +0200,
> Dan Carpenter wrote:
>>
>> On Tue, Jul 14, 2015 at 06:34:06PM -0600, Shuah Khan wrote:
>>> +		ret = media_entity_setup_link(link, flags);
>>> +		if (ret) {
>>> +			dev_err(mctl->media_dev->dev,
>>> +				"Couldn't change tuner link",
>>> +				"%s->%s to %s. Error %d\n",
>>
>> Add a space after "link".
>>
>> 				"Couldn't change tuner link ",
>> 				"%s->%s to %s. Error %d\n",
> 
> Such a message string would be better to be in a single line even if
> it's over 80 chars.  Otherwise it becomes hard to grep.
> 

Right. The above generates a warning and I found it after I sent
the patch. I will have to re-do this patch to fix this. I prefer
not splitting the message, but checkpatch compains if I don't.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
