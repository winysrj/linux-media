Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:41495 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938417AbdD1MFh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:05:37 -0400
Subject: Re: [PATCH 0/8] omapdrm: add OMAP4 CEC support
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <15ba27fd-ed40-4bb4-ed7e-ebd3428ae7f4@ti.com>
Cc: dri-devel@lists.freedesktop.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <db859e0b-19f6-35d5-2ed7-ada2cb3ec5e6@xs4all.nl>
Date: Fri, 28 Apr 2017 14:05:34 +0200
MIME-Version: 1.0
In-Reply-To: <15ba27fd-ed40-4bb4-ed7e-ebd3428ae7f4@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/04/17 13:52, Tomi Valkeinen wrote:
> On 14/04/17 13:25, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch series adds support for the OMAP4 HDMI CEC IP core.
> 
> What is this series based on? It doesn't apply to drm-next, and:
> fatal: sha1 information is lacking or useless
> (drivers/gpu/drm/omapdrm/dss/hdmi4.c).

That patch series was based on the media_tree master since I needed the latest
CEC core code that supports CEC while HPD is down. I have rebased my series
to the latest media_tree version. It's available in my panda-cec branch from
my repo: git://linuxtv.org/hverkuil/media_tree.git.

As mentioned, once 4.12-rc1 has been released I'll rebase and repost.

Regards,

	Hans
