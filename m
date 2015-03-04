Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:48071 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758924AbbCDJWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 04:22:04 -0500
Message-ID: <54F6CEA7.5080601@xs4all.nl>
Date: Wed, 04 Mar 2015 10:21:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.1] v4l2-subdev: removal of duplicate video enum
 ops
References: <54F5D9CA.2010103@xs4all.nl>
In-Reply-To: <54F5D9CA.2010103@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/15 16:56, Hans Verkuil wrote:
> Hi Mauro,
> 
> This patch series prepares for the removal of duplicate video enum ops. See this
> post for the background for this series:
> 
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/87869
> 
> The patches in this pull request are the same as the posted series, except for
> being rebased and with patch 6/7 being dropped. This patch is found here:
> 
> https://patchwork.linuxtv.org/patch/28220/
> 
> The reason for dropping it is that I don't have an Ack from Jon Corbet yet.
> I'm trying to test it myself, at least on my OLPC laptop, but that's painful
> and takes longer than I hoped.
> 
> So I don't want to wait for that and I am posting the other patches now.
> Laurent needs these patches as well so he can rebase his xilinx driver on top
> of it.
> 
> Patch 6/7 will be posted in a later pull request, once I (or Jon) managed to
> test it.

I'm setting this to superseded: I found an am437 problem and now that I
tested patch 6/7 I'm going to include that one as well.

Regards,

	Hans
