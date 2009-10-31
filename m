Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbZJaJgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 05:36:01 -0400
Date: Sat, 31 Oct 2009 07:34:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Massimo Del Fedele <max@veneto.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH]: Add support for Pinnacle PCTV310e card
Message-ID: <20091031073435.09fbe259@caramujo.chehab.org>
In-Reply-To: <4AE32775.8020605@veneto.com>
References: <4AE32775.8020605@veneto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Massimo,

Em Sat, 24 Oct 2009 18:12:37 +0200
Massimo Del Fedele <max@veneto.com> escreveu:

> This one adds support to Pinnacle PCTV310e hybrid tuner card,
> for DVB-T and remote control, still no analog video.

There are a few CodingStyle issues on your patch. Always chech them with
checkpatch.pl.

Also, you forgot your Signed-off-by. Please send it.



Cheers,
Mauro
