Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:50789 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab2LRTMg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 14:12:36 -0500
Date: Tue, 18 Dec 2012 12:15:08 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2
 parts for soc_camera support
Message-ID: <20121218121508.7a4de314@lwn.net>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D13C8D0E3@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-11-git-send-email-twang13@marvell.com>
	<20121216093717.4be8feff@hpe.lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8CCE4@SC-VEXCH1.marvell.com>
	<20121217082832.7f363d05@lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8D0E3@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 17 Dec 2012 19:04:26 -0800
Albert Wang <twang13@marvell.com> wrote:

> [Albert Wang] So if we add B_DMA_SG and B_VMALLOC support and OLPC XO 1.0 support in soc_camera mode.
> Then we can just remove the original mode and only support soc_camera mode in marvell-ccic?

That is the idea, yes.  Unless there is some real value to supporting both
modes (that I've not seen), I think it's far better to support just one of
them.  Trying to support duplicated modes just leads to pain in the long
run, in my experience.

I can offer to *try* to find time to help with XO 1.0 testing when the
time comes.

Thanks,

jon
