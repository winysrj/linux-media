Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33404 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993425AbbEEPj7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 11:39:59 -0400
Received: by layy10 with SMTP id y10so130702097lay.0
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 08:39:57 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 May 2015 17:39:57 +0200
Message-ID: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
Subject: [RFC] How implement Secure Data Path ?
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Since few months I'm looking for Linaro to how do Secure Data Path (SPD).
I have tried and implemented multiple thinks but I always facing architecture
issues so I would like to get your help to solve the problem.

First what is Secure Data Path ? SDP is a set of hardware features to garanty
that some memories regions could only be read and/or write by specific hardware
IPs. You can imagine it as a kind of memory firewall which grant/revoke
accesses to memory per devices. Firewall configuration must be done in a trusted
environment: for ARM architecture we plan to use OP-TEE + a trusted
application to do that.

One typical use case for SDP in a video playback which involve those elements:
decrypt -> video decoder -> transform -> display

decrypt output contains encoded data that need to be secure: only hardware video
decoder should be able to read them.
Hardware decoder output (decoded frame) can only be read by hardware
transform and
only hardware display can read transform output.
Video decoder and transform are v4l2 devices and display is a drm/kms device.

To be able to configure the firewall SDP need to know when each device need to
have access to memory (physical address and size) and in which direction (read
or write).
SDP also need a way to transfert information that memory is secure between
different frameworks and devices.
Obviously I also want to limit the impact of SDP in userland and kernel:
For example not change the way of how buffers are allocating or how
graph/pipeline
are setup.

When looking to all those constraints I have try to use dma_buf: it is a cross
frameworks and processes way to share buffers and, with
dma_buf_map_attachment() and dma_buf_unmap_attachment() functions, have an API
that provide the informations (device, memory, direction) to configure
the firewall.

I have try 2 "hacky" approachs with dma_buf:
- add a secure field in dma_buf structure and configure firewall in
  dma_buf_{map/unmap}_attachment() functions.
- overwrite dma_buf exporter ops to have a kind of nested calls which allow to
  configure firewall without impacting the exporter code.

The both solutions have architecture issues, the first one add a "metadata"
into dma_buf structure and calls to a specific SDP environment (OP-TEE +
trusted application) and second obvious break dma_buf coding rules
when overwriting
exporter ops.

>From buffer allocation point of view I also facing a problem because when v4l2
or drm/kms are exporting buffers by using dma_buf they don't attaching
themself on it and never call dma_buf_{map/unmap}_attachment(). This is not
an issue in those framework while it is how dma_buf exporters are
supposed to work.

Using an "external" allocator (like ION) solve this problem but I think in
this case we will have the same problem than for the "constraint aware
allocator" which has never been accepted.

The goal of this RFC is to share/test ideas to solve this problem which at
least impact v4l2 and drm/kms.
Any suggestions/inputs are welcome !

Regards,
Benjamin
