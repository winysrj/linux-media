Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:57642 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab3E0Kib (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 06:38:31 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Maarten Lankhorst' <maarten.lankhorst@canonical.com>,
	'Daniel Vetter' <daniel@ffwll.ch>,
	'Rob Clark' <robdclark@gmail.com>
Cc: 'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
 <CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
 <006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
 <CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
 <00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
 <CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
 <CAAQKjZP37koEPob6yqpn-WxxTh3+O=twyvRzDiEhVJTD8BxQzw@mail.gmail.com>
 <20130520211304.GV12292@phenom.ffwll.local>
 <20130520213033.GW12292@phenom.ffwll.local>
 <032701ce55f1$3e9ba4b0$bbd2ee10$%dae@samsung.com>
 <20130521074441.GZ12292@phenom.ffwll.local>
 <033a01ce5604$c32bd250$498376f0$%dae@samsung.com>
 <CAKMK7uHtk+A7CDZH3qHt+F3H_fdSsWwt-bEPn-N0919oOE+Jkg@mail.gmail.com>
 <012801ce57ba$a5a87fa0$f0f97ee0$%dae@samsung.com>
In-reply-to: <012801ce57ba$a5a87fa0$f0f97ee0$%dae@samsung.com>
Subject: RE: Introduce a new helper framework for buffer synchronization
Date: Mon, 27 May 2013 19:38:24 +0900
Message-id: <014501ce5ac6$511a8500$f34f8f00$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have been removed previous branch and added new one with more cleanup.
This time, the fence helper doesn't include user side interfaces and cache
operation relevant codes anymore because not only we are not sure that
coupling those two things, synchronizing caches and buffer access between
CPU and CPU, CPU and DMA, and DMA and DMA with fences, in kernel side is a
good idea yet but also existing codes for user side have problems with badly
behaved or crashing userspace. So this could be more discussed later.

The below is a new branch,
	
https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/?h=dma-f
ence-helper

And fence helper codes,
	
https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/commit/?
h=dma-fence-helper&id=adcbc0fe7e285ce866e5816e5e21443dcce01005

And example codes for device driver,
	
https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/commit/?
h=dma-fence-helper&id=d2ce7af23835789602a99d0ccef1f53cdd5caaae

I think the time is not yet ripe for RFC posting: maybe existing dma fence
and reservation need more review and addition work. So I'd glad for somebody
giving other opinions and advices in advance before RFC posting.

Thanks,
Inki Dae

