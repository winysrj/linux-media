Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58128 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965376AbcA1Q7m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 11:59:42 -0500
Subject: Re: [PATCH 15/31] media: dvb-frontend invoke enable/disable_source
 handlers
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <1591b6cf2025fa95a13e3b7dde52aa0e0bde0bb4.1452105878.git.shuahkh@osg.samsung.com>
 <20160128135304.3daa79f1@recife.lan>
 <20160128160711.029f3faf@lxorguk.ukuu.org.uk>
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
Message-ID: <56AA48FA.7070203@osg.samsung.com>
Date: Thu, 28 Jan 2016 09:59:38 -0700
MIME-Version: 1.0
In-Reply-To: <20160128160711.029f3faf@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/2016 09:07 AM, One Thousand Gnomes wrote:
> On Thu, 28 Jan 2016 13:53:04 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
>> Em Wed,  6 Jan 2016 13:27:04 -0700
>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>
>>> Checking for tuner availability from frontend thread start
>>> disrupts video stream. Change to check for tuner and start
>>> pipeline from frontend open instead and stop pipeline from
>>> frontend release.  
>>
>> That's wrong, as DVB can be opened on read-only mode, where
>> it won't be changing anything.

Correct. Please check the code. Tuner availability check is
done when the device is opened in Write mode in the following
conditional.

       if ((file->f_flags & O_ACCMODE) != O_RDONLY) {

>>
>> Also, I don't think POSIX allows to return an error like EBUSY
>> on open:
>> 	http://pubs.opengroup.org/onlinepubs/9699919799/functions/open.html
> 
> It doesn't document all the errors you may return. Quite a lot of
> kernel drivers return EBUSY when they are "single open" things.
> 
> POSIX documents certain cases that *must* error and what the error code
> is. It documents certain possible failures and what their error code is.
> Beyond that it's up to you.
> 

Returning EBUSY clearly indicates the reason why the device
can't be opened in this case.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
