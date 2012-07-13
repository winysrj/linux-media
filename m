Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34480 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2GMKFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 06:05:53 -0400
Date: Fri, 13 Jul 2012 11:05:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	KS2012 <ksummit-2012-discuss@lists.linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] Device-tree cross-subsystem binding
 workshop [was Media system Summit]
Message-ID: <20120713100549.GB8925@sirena.org.uk>
References: <CAOesGMgs7sBn=Tfk6YP7BE=O0s8qQrz17n-GfEi_Vr2HDy6xZA@mail.gmail.com>
 <4FFF8E0B.5020103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFF8E0B.5020103@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2012 at 09:55:07PM -0500, Rob Herring wrote:

> Perhaps part of the issue is we're trying to put too much into DT?

I think this is definitely part of it, at times it feels like people
have a shiny new toy so we're jumping into device tree really quickly
for things that perhaps don't need to be pulled out of the code.

Another part of it (and the big problem with translating platform data
directly) is that platform data is easily fungible whereas device tree
should in theory be an ABI and hence needs much closer scrutiny.
