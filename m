Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34815 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab0FKQJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 12:09:08 -0400
MIME-Version: 1.0
In-Reply-To: <201006111707.34463.laurent.pinchart@ideasonboard.com>
References: <201006091227.29175.laurent.pinchart@ideasonboard.com>
	<AANLkTilPWyHcoT6q1T-o-UMvcMSs2_If45f9UocVtrbl@mail.gmail.com>
	<A24693684029E5489D1D202277BE894455DDEC44@dlee02.ent.ti.com>
	<201006111707.34463.laurent.pinchart@ideasonboard.com>
Date: Fri, 11 Jun 2010 19:09:06 +0300
Message-ID: <AANLkTikdUanfxhkbb0sYZ-Yhd_9dVywv9Yj1a5DL18oN@mail.gmail.com>
Subject: Re: Alternative for defconfig
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	"Nagarajan, Rajkumar" <x0133774@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 11, 2010 at 6:07 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> My understanding is that Linus will remove all ARM defconfigs in 2.6.36,
> unless someone can convince him not to.

Huh? I thought he was only threatening to remove them[1]. I don't
think he said he was going to do that without any alternative in
place.

My suggestion[2] was to have minimal defconfigs so that we could do
$ cp arch/arm/configs/omap3_beagle_baseconfig .config
$ echo "" | make ARCH=arm oldconfig

[1] http://article.gmane.org/gmane.linux.kernel/994194
[2] http://article.gmane.org/gmane.linux.kernel/995412

-- 
Felipe Contreras
