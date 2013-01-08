Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39976 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3AHGuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 01:50:51 -0500
Message-id: <50EBC1C1.3060208@samsung.com>
Date: Tue, 08 Jan 2013 07:50:41 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Alessandro Rubini <rubini@gnudd.com>, federico.vaga@gmail.com,
	mchehab@infradead.org, pawel@osciak.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
References: <3892735.vLSnhhCRFi@harkonnen>
 <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
 <1399400.izKZgEHXnP@harkonnen> <12929800.xFTBAueAE0@harkonnen>
 <20130106230947.GA17979@mail.gnudd.com> <20130107124050.3fc5031b@lwn.net>
 <20130107181500.24c56803@redhat.com>
In-reply-to: <20130107181500.24c56803@redhat.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 1/7/2013 9:15 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 7 Jan 2013 12:40:50 -0700
> Jonathan Corbet <corbet@lwn.net> escreveu:
>
> > On Mon, 7 Jan 2013 00:09:47 +0100
> > Alessandro Rubini <rubini@gnudd.com> wrote:
> >
> > > I don't expect you'll see serious performance differences on the PC. I
> > > think ARM users will have better benefits, due to the different cache
> > > architecture.  You told me Jon measured meaningful figures on a Marvel
> > > CPU.
> >
> > It made the difference between 10 frames per second with the CPU running
> > flat out and 30fps mostly idle.  I think that probably counts as
> > meaningful, yeah...:)
>
> Couldn't this performance difference be due to the usage of GFP_DMA inside
> the VB2 code, like Federico's new patch series is proposing?
>
> If not, why are there a so large performance penalty?

Nope, this was caused rather by a very poor CPU access to non-cached (aka
'coherent') memory and the way the video data has been accessed/read 
with CPU.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


