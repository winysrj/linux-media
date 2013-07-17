Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:44159 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3GQKtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 06:49:53 -0400
Message-ID: <1374058189.3146.107.camel@hornet>
Subject: Re: [PATCH 0/2][RFC] CDFv2 for VExpress HDLCD DVI output support
From: Pawel Moll <pawel.moll@arm.com>
To: Show Liu <show.liu@linaro.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"tom.gall@linaro.org" <tom.gall@linaro.org>,
	"t.katayama@jp.fujitsu.com" <t.katayama@jp.fujitsu.com>,
	"vikas.sajjan@linaro.org" <vikas.sajjan@linaro.org>,
	"linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Date: Wed, 17 Jul 2013 11:49:49 +0100
In-Reply-To: <1374055737-6643-1-git-send-email-show.liu@linaro.org>
References: <1374055737-6643-1-git-send-email-show.liu@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-07-17 at 11:08 +0100, Show Liu wrote:
> This series patches extend Pawel's patches to 
> Versatile Express HDLCD DVI output support.
> Before apply this patches, please apply Pawel's patches first.
> This series patches implements base on Linaro release 13.06 branch "ll_20130621.0".
> 
> here is Pawel's patches
> [1] http://lists.freedesktop.org/archives/dri-devel/2013-April/037519.html

Glad to see someone thinking the same way ;-) Thanks for trying it and
particularly for the fixes in vexpress-* code. I'll keep them in mind
when the time comes :-)

Of course neither the CDF patch nor the HDLCD driver are upstream yet.
Laurent promised to post next (hopefully final ;-) version of his
patches soon, but the API has apparently changed so we'll have to adapt
to it. As to the HDLCD driver - there is some work going on converting
it to DRM/KMS and upstreaming as such, using CDF if it's available by
that time as well.

Paweł




