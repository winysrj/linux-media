Return-path: <linux-media-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:47595 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbbJUOdC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 10:33:02 -0400
Date: Thu, 22 Oct 2015 01:32:39 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, treding@nvidia.com, sumit.semwal@linaro.org,
	tom.cooksey@arm.com, daniel.stone@collabora.com,
	linux-security-module@vger.kernel.org, xiaoquan.li@vivantecorp.com,
	labbott@redhat.com, tom.gall@linaro.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v5 1/3] create SMAF module
In-Reply-To: <1445419340-11471-2-git-send-email-benjamin.gaignard@linaro.org>
Message-ID: <alpine.LRH.2.20.1510220119590.6421@namei.org>
References: <1445419340-11471-1-git-send-email-benjamin.gaignard@linaro.org> <1445419340-11471-2-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Oct 2015, Benjamin Gaignard wrote:

> Secure Memory Allocation Framework goal is to be able
> to allocate memory that can be securing.
> There is so much ways to allocate and securing memory that SMAF
> doesn't do it by itself but need help of additional modules.
> To be sure to use the correct allocation method SMAF implement
> deferred allocation (i.e. allocate memory when only really needed)
> 
> Allocation modules (smaf-alloctor.h):
> SMAF could manage with multiple allocation modules at same time.
> To select the good one SMAF call match() to be sure that a module
> can allocate memory for a given list of devices. It is to the module
> to check if the devices are compatible or not with it allocation
> method.
> 
> Securing module (smaf-secure.h):
> The way of how securing memory it is done is platform specific.
> Secure module is responsible of grant/revoke memory access.
> 

This documentation is highly inadequate.

What does "allocate memory that can be securing" mean?


-- 
James Morris
<jmorris@namei.org>

