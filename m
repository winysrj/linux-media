Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:35373 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab1D3Muk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 08:50:40 -0400
Message-ID: <4DBC0598.9060101@infradead.org>
Date: Sat, 30 Apr 2011 09:50:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Florian Mickler <florian@mickler.org>, oliver@neukum.org,
	linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media] dib0700: get rid of on-stack dma buffers
References: <1301851423-21969-1-git-send-email-florian@mickler.org>	<alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>	<4DBB2E72.3030800@infradead.org> <20110430114609.53103d67@schatten.dmk.lab>
In-Reply-To: <20110430114609.53103d67@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Patrick,

Em 30-04-2011 06:46, Florian Mickler escreveu:
> On Fri, 29 Apr 2011 18:32:34 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
>> As it is a trivial fix, I'll be picking it directly.
> 
> Zdenek reported in the bug that it doesn't fix all instances of the
> warning. 

Could you please take a look on it?

I'll apply the patch anyway, as at least it will reduce the stack size
and partially fix the issue, but, as Florian and Zdenek pointed, there
are still some cases were stack pointers are used to pass data to URB's,
and this is forbidden (and don't even work on some architectures).

Mauro.
