Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35208 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbbELIq1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 04:46:27 -0400
Received: by lbbuc2 with SMTP id uc2so253154lbb.2
        for <linux-media@vger.kernel.org>; Tue, 12 May 2015 01:46:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150508201843.3447049b@lxorguk.ukuu.org.uk>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
	<20150505175405.2787db4b@lxorguk.ukuu.org.uk>
	<20150506083552.GF30184@phenom.ffwll.local>
	<20150506091919.GC16325@ulmo.nvidia.com>
	<20150506131532.GC30184@phenom.ffwll.local>
	<20150507132218.GA24541@ulmo.nvidia.com>
	<20150507135212.GD30184@phenom.ffwll.local>
	<20150507174003.2a5b42e6@lxorguk.ukuu.org.uk>
	<20150508083735.GB15256@phenom.ffwll.local>
	<20150508201843.3447049b@lxorguk.ukuu.org.uk>
Date: Tue, 12 May 2015 10:46:26 +0200
Message-ID: <CA+M3ks6fddVwvwiUSBkMccV7utVVuB=iBqGonURimavM=sSWUw@mail.gmail.com>
Subject: Re: [RFC] How implement Secure Data Path ?
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Thierry Reding <treding@nvidia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Clark <robdclark@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think now I have an answer to my question.

I will back come in a couple of weeks with a generic dmabuf allocator.
The feature set of this should be:
- allow to have per device specificone  allocator
- ioctl for buffer allocation and exporting dmabuf file descriptor on /dev/foo
- generic API to be able to call buffer securing module which is
platform specific.
- ioctl and kernel API to set/get dmabuf secure status

Sumit had already done a draft of this kind of dmabuf allocator with
his cenalloc [1]
I think I will start from that.

Benjamin

[1] http://git.linaro.org/people/sumit.semwal/linux-3.x.git on
cenalloc_wip branch.
