Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:59353 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbGXOeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:34:15 -0400
Message-ID: <55B24CE2.50904@codethink.co.uk>
Date: Fri, 24 Jul 2015 15:34:10 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [Linux-kernel] [PATCH 03/13] media: adv7604: fix probe of ADV7611/7612
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-4-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-4-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/07/15 13:21, William Towle wrote:
> Prior to commit f862f57d ("[media] media: i2c: ADV7604: Migrate to
> regmap"), the local variable 'val' contained the combined register
> reads used in the chipset version ID test. Restore this expectation
> so that the comparison works as it used to.

Forgot the Signed-off-by: line here.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
