Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4835 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab3FTPYE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 11:24:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: lbyang@marvell.com
Subject: Re: [PATCH 0/7] marvell-ccic: update ccic driver to support some features
Date: Thu, 20 Jun 2013 17:23:46 +0200
Cc: corbet@lwn.net, g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org, albert.v.wang@gmail.com
References: <1370324144.26072.17.camel@younglee-desktop>
In-Reply-To: <1370324144.26072.17.camel@younglee-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201723.46138.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon,

Can you ack this series? I don't see anything wrong with it, but neither am
I a marvell-ccic expert.

I'd like to have your input before I merge this.

Regards,

	Hans

On Tue June 4 2013 07:35:44 lbyang wrote:
> The patch set adds some feature into the marvell ccic driver
> 
> Patch 1: Support MIPI sensor
> Patch 2: Support clock tree
> Patch 3: reset ccic when stop streaming, which makes CCIC more stable
> Patch 4: refine the mcam_set_contig_buffer function
> Patch 5: add some new fmts to support
> Patch 6: add SOF-EOF pair check to make the CCIC more stable
> Patch 7: use resource managed allocation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
