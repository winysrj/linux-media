Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35943 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263AbbDXWen (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 18:34:43 -0400
Date: Fri, 24 Apr 2015 16:35:50 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] marvell-ccic: fix RGB444 format
Message-ID: <20150424163550.7f9d62df@lwn.net>
In-Reply-To: <553A126F.7040102@xs4all.nl>
References: <553A126F.7040102@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Apr 2015 11:52:47 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> The RGB444 format swapped the red and blue components, fix this.
> 
> Rather than making a new BGR444 format (as I proposed initially), Jon prefers
> to just fix this and return the colors in the right order. I think that makes
> sense in this case.
> 
> Since the RGB444 pixel format is deprecated due to the ambiguous specification
> of the alpha component we use the XRGB444 pixel format instead (specified as having
> no alpha channel).

Seems good to me.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
