Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbbDAPIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 11:08:21 -0400
Date: Wed, 1 Apr 2015 17:08:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: John Hunter <zhjwpku@gmail.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	virtio-dev@lists.oasis-open.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	open list <linux-kernel@vger.kernel.org>, airlied@redhat.com,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] break kconfig dependency loop
Message-ID: <20150401170706-mutt-send-email-mst@redhat.com>
References: <1427894130-14228-1-git-send-email-kraxel@redhat.com>
 <1427894130-14228-2-git-send-email-kraxel@redhat.com>
 <CAEG8a3+Wp-jgtwKmcBhG2gVAOP2tQ5MHuJwYe-m2HwYQRB06HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEG8a3+Wp-jgtwKmcBhG2gVAOP2tQ5MHuJwYe-m2HwYQRB06HQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 01, 2015 at 10:55:01PM +0800, John Hunter wrote:
> Hi Gerd,
> I've read the patches about the virtio-gpu, it's a nice design.
> As far as I know, there are two other drivers used by qemu, CIRRUS and BOCHS.
> I have a question about the relationship of these three drivers, is that the
> virtio-gpu
> designed to replace the other two drivers? I mean are the CIRRUS and BOCHS
> going to be deprecated in the future?
> 
> Would you please kindly explain this a little bit?
> 
> Actually, this is a problem by Martin Peres who is the GSoC xorg administor. 
> My proposal is "Convert the BOCHS and CIRRUS drivers to atomic mode-setting".
> Martin wonder if the two drivers are going to be deprecated, there is no need
> for
> me to do the job.
> 
> Best regards,
> John 

Hypervisors are going to support BOCHS and CIRRUS for years to come.

-- 
MST
