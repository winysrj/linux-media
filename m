Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16991 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbbLNUEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 15:04:43 -0500
Date: Mon, 14 Dec 2015 23:04:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] media-entity: protect object creation/removal using spin
 lock
Message-ID: <20151214200434.GF5177@mwanda>
References: <20151214195053.GA15098@mwanda>
 <20151214180052.4262a0a8@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151214180052.4262a0a8@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 14, 2015 at 06:00:52PM -0200, Mauro Carvalho Chehab wrote:
> I guess gcc optimizer actually does the right thing, but we should
> fix it to remove the static analyzer warnings.

It probably crashes if you enable poisoning freed memory?  (I haven't
tested).

regards,
dan carpenter

