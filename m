Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33594 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbbL3E3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 23:29:08 -0500
Date: Wed, 30 Dec 2015 09:58:57 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/5] staging: media: lirc: replace NULL comparisons with
 !var
Message-ID: <20151230042857.GA11586@sudip-pc>
References: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 18, 2015 at 06:35:25PM +0530, Sudip Mukherjee wrote:
> A NULL comparison can be written as if (var) or if (!var).
> Reported by checkpatch.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---

Hi Mauro,

A gentle ping.   
Can this series be considered for 4.5?

regards
sudip
