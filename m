Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54094 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbbGWSNX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2015 14:13:23 -0400
Message-ID: <55B12EB8.9030708@osg.samsung.com>
Date: Thu, 23 Jul 2015 12:13:12 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com, perex@perex.cz, crope@iki.fi,
	arnd@arndb.de, stefanr@s5r6.in-berlin.de,
	ruchandani.tina@gmail.com, chehabrafael@gmail.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, hyun.kwon@xilinx.com, michal.simek@xilinx.com,
	soren.brinkmann@xilinx.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	skd08@gmail.com, nsekhar@ti.com,
	boris.brezillon@free-electrons.com, Julia.Lawall@lip6.fr,
	elfring@users.sourceforge.net, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com
CC: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 00/19] Update ALSA, and au0828 drivers to use Managed
 Media Controller API
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2015 04:42 PM, Shuah Khan wrote:
> This patch series updates ALSA driver, and au0828 core driver to
> use Managed Media controller API to share tuner. Please note that
> Managed Media Controller API and DVB and V4L2 drivers updates to
> use Media Controller API have been added in a prior patch series.
> 
> Media Controller API is enhanced with two new interfaces to
> register and unregister entity_notify hooks to allow drivers
> to take appropriate actions when as new entities get added to
> the shared media device.
> 
> Tested exclusion between digital, analog, and audio to ensure
> when tuner has an active link to DVB FE, analog, and audio will
> detect and honor the tuner busy conditions and vice versa.
> 
> Changes since v1:
> Link to v1: http://www.spinics.net/lists/linux-media/msg91697.html

I uploaded this patch series to my linux.git media_controller branch
on kernel.org:

git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux.git
media_controller branch

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
