Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:60353 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423404Ab3FURFY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 13:05:24 -0400
Date: Fri, 21 Jun 2013 11:05:18 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: <lbyang@marvell.com>
Cc: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>
Subject: Re: [PATCH 5/7] marvell-ccic: add new formats support for
 marvell-ccic driver
Message-ID: <20130621110518.2171f9ee@lwn.net>
In-Reply-To: <1370325463.26072.31.camel@younglee-desktop>
References: <1370325463.26072.31.camel@younglee-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 4 Jun 2013 13:57:43 +0800
lbyang <lbyang@marvell.com> wrote:

> This patch adds the new formats support for marvell-ccic.

More to the point, it adds *planar* format support.  That's something I
always meant to do, and it deserves mentioning in the changelog.

My look-over has been quick, but:

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
