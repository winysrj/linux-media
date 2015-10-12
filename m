Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:54314 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbbJLJt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 05:49:29 -0400
Message-ID: <561B81B4.1050305@xs4all.nl>
Date: Mon, 12 Oct 2015 11:47:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	m.chehab@samsung.com, khalasa <khalasa@piap.pl>
Subject: Re: H264 headers generation for driver
References: <CAM_ZknUEP73dQ2eEtVM_A_psAwcovKeiCDhpNgW+Fo96RRKM2w@mail.gmail.com>
In-Reply-To: <CAM_ZknUEP73dQ2eEtVM_A_psAwcovKeiCDhpNgW+Fo96RRKM2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/29/2015 08:59 PM, Andrey Utkin wrote:
> This is a new chapter of tw5864 video grabber & encoder driver
> development drama.
> Last state of code is here (tw5864 branch, drivers/staging/media/tw5864):
> https://github.com/bluecherrydvr/linux/tree/tw5864/drivers/staging/media/tw5864
> 
> Currently I use a third-side LGPL library for H.264 headers generation
> - SPS, PPS and slice headers (because device doesn't generate them).
> It is included as a git submodule "h264bitstream". It is used from
> tw5864-h264.c .
> Of course we want our driver to get to upstream repository when it
> matures enough, that's why we want to ask for advice regarding this.
> I see that there is no similar case in upstream kernel repo - no
> submodules and no libraries for H264 bitstreams.
> Device datasheet
> (http://lizard.bluecherry.net/~autkin/tw5864/tw5864b1-ds.pdf , page
> 47) shows that there's almost no variety of modes, so minimally an
> implementation of bitstream writing functions ue() and se() will
> suffice.
> I guess that one acceptable way is to pre-generate all headers for all
> needed cases and ship them inlined; for correctness checking purpose,
> it is possible to ship also a script or additional source code file
> which is able to generate same headers.
> Please advise.
> 
> Thanks in advance for any kind reply.
> 

You can do something like this:

drivers/media/platform/vivid/vivid-tpg-colors.c

Both the generated tables and the code that generates them are in one
file.

An alternative is to add a source to v4l2-core that generates the tables,
but I don't know if that is feasible (i.e., if it can be made sufficiently
generic).

Regards,

	Hans
