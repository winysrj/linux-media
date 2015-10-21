Return-path: <linux-media-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:47606 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbbJUOeW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 10:34:22 -0400
Date: Thu, 22 Oct 2015 01:34:09 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, treding@nvidia.com, sumit.semwal@linaro.org,
	tom.cooksey@arm.com, daniel.stone@collabora.com,
	linux-security-module@vger.kernel.org, xiaoquan.li@vivantecorp.com,
	labbott@redhat.com, tom.gall@linaro.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v5 0/3] RFC: Secure Memory Allocation Framework
In-Reply-To: <1445419340-11471-1-git-send-email-benjamin.gaignard@linaro.org>
Message-ID: <alpine.LRH.2.20.1510220132490.6421@namei.org>
References: <1445419340-11471-1-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Oct 2015, Benjamin Gaignard wrote:

> 
> The outcome of the previous RFC about how do secure data path was the need
> of a secure memory allocator (https://lkml.org/lkml/2015/5/5/551)
> 

Have you addressed all the questions raised by Alan here:

https://lkml.org/lkml/2015/5/8/629

Also, is there any application of this beyond DRM?


- James
-- 
James Morris
<jmorris@namei.org>

