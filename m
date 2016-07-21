Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35029 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbcGUILU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 04:11:20 -0400
Subject: Re: [PATCH v3 0/3] support of v4l2 encoder for STMicroelectronics SOC
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
	linux-media@vger.kernel.org
References: <1469086804-21652-1-git-send-email-jean-christophe.trotin@st.com>
Cc: kernel@stlinux.com,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick Fertre <yannick.fertre@st.com>,
	Hugues Fruchet <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e71d58b2-e21a-1879-d69b-271071f27ff3@xs4all.nl>
Date: Thu, 21 Jul 2016 10:11:11 +0200
MIME-Version: 1.0
In-Reply-To: <1469086804-21652-1-git-send-email-jean-christophe.trotin@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The module is still called 'hva'. I suggest calling it sti-hva instead.

> 	Format ioctls:
> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
> 		warn: /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 2, but not ENUM_FRAMEINTERVALS

So why is S_PARM supported? I asked about that in my review, but I got no answer.

I've never seen that for m2m devices, and it really makes no sense IMHO.

The 'framerate' is typically driven by how often new frames are submitted by the
user. It's not up to the driver to mess with that.

Regards,

	Hans
