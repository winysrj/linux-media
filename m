Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:37475 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755148AbbLBMaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2015 07:30:52 -0500
Subject: Re: [RFC PATCH 04/11] v4l2-ctrls: add config store support
To: Enric Balletbo Serra <eballetbo@gmail.com>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
 <1411310909-32825-5-git-send-email-hverkuil@xs4all.nl>
 <20141114154433.GF8907@valkosipuli.retiisi.org.uk>
 <5469B5EF.6070408@xs4all.nl>
 <CAFqH_52f6Nh7LsjpkWavFXUAMDMqHX3E4DFYzMGonHDzucsasA@mail.gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <565EE51C.2010509@xs4all.nl>
Date: Wed, 2 Dec 2015 13:33:32 +0100
MIME-Version: 1.0
In-Reply-To: <CAFqH_52f6Nh7LsjpkWavFXUAMDMqHX3E4DFYzMGonHDzucsasA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/02/15 13:03, Enric Balletbo Serra wrote:
> Dear Hans,
> 
> We've a driver that uses your confstore stuff and we'd like to push
> upstream. I'm wondering if there is any plan to upstream the confstore
> patches or if this was abandoned for some reason. Thanks

Ouch, that's really old code you're using.

The latest version is here:

http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=requests

But that too won't be the final version.

There is still work going on in this area (specifically by Laurent Pinchart)
since we really need this functionality. But we need to make sure that the
API is good enough to handle complex hardware before it can be upstreamed.

I suspect that once Laurent has it working for his non-trivial use-case we
can start looking at upstreaming it.

I recommend rebasing to at least the version in my git tree as that will
be much closer to the final version. I'll try to rebase that branch to
the latest kernel, but that's a bit difficult and takes more time than I
have at the moment.

Regards,

	Hans
