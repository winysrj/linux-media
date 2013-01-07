Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:58352 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab3AGTkw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 14:40:52 -0500
Date: Mon, 7 Jan 2013 12:40:50 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: federico.vaga@gmail.com, mchehab@redhat.com,
	m.szyprowski@samsung.com, mchehab@infradead.org, pawel@osciak.com,
	hans.verkuil@cisco.com, giancarlo.asnaghi@st.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20130107124050.3fc5031b@lwn.net>
In-Reply-To: <20130106230947.GA17979@mail.gnudd.com>
References: <3892735.vLSnhhCRFi@harkonnen>
	<1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
	<1399400.izKZgEHXnP@harkonnen>
	<12929800.xFTBAueAE0@harkonnen>
	<20130106230947.GA17979@mail.gnudd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 7 Jan 2013 00:09:47 +0100
Alessandro Rubini <rubini@gnudd.com> wrote:

> I don't expect you'll see serious performance differences on the PC. I
> think ARM users will have better benefits, due to the different cache
> architecture.  You told me Jon measured meaningful figures on a Marvel
> CPU.

It made the difference between 10 frames per second with the CPU running
flat out and 30fps mostly idle.  I think that probably counts as
meaningful, yeah...:)

jon
