Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38416 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbcC2JrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 05:47:11 -0400
Received: by mail-wm0-f43.google.com with SMTP id 20so17904906wmh.1
        for <linux-media@vger.kernel.org>; Tue, 29 Mar 2016 02:47:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F98915.1030200@intel.com>
References: <CAO_48GGT48RZaLjg9C+51JyPKzYkkDCFCTrMgfUB+PxQyV8d+Q@mail.gmail.com>
	<1458546705-3564-1-git-send-email-daniel.vetter@ffwll.ch>
	<CANq1E4S0skXbWBOv2bgVddLmZXZE6B7es=+NHKDuJehggnzSvw@mail.gmail.com>
	<20160321171405.GP28483@phenom.ffwll.local>
	<CANq1E4S4_vmCcPZJwpHkfOYuDe3boHCsYGW8q0U4=+tLui+QYg@mail.gmail.com>
	<20160323115659.GF21717@nuc-i3427.alporthouse.com>
	<CANq1E4SFPMoE4G4XARFLyEH40OOZnR2v_PQD4=ps3KBvVXUHpA@mail.gmail.com>
	<20160323154223.GJ21717@nuc-i3427.alporthouse.com>
	<56F98915.1030200@intel.com>
Date: Tue, 29 Mar 2016 11:47:09 +0200
Message-ID: <CANq1E4Q-aXTx5YGh0yOiU8cRh_opqrUrGin7qn-9N_EszjXfvA@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Update docs for SYNC ioctl
From: David Herrmann <dh.herrmann@gmail.com>
To: Tiago Vignatti <tiago.vignatti@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	=?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	devel@driverdev.osuosl.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Mon, Mar 28, 2016 at 9:42 PM, Tiago Vignatti
<tiago.vignatti@intel.com> wrote:
> Do we have an agreement here after all? David? I need to know whether this
> fixup is okay to go cause I'll need to submit to Chrome OS then.

Sure it is fine. The code is already there, we cannot change it.

Thanks
David
