Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbFALis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 07:38:48 -0400
Message-ID: <556C4444.4070808@suse.de>
Date: Mon, 01 Jun 2015 13:38:44 +0200
From: Alexander Graf <agraf@suse.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-kernel@vger.kernel.org
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-metag@vger.kernel.org, kvm-ppc@vger.kernel.org,
	linux-wireless@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] treewide: Fix typo compatability -> compatibility
References: <1432728342-32748-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1432728342-32748-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27.05.15 14:05, Laurent Pinchart wrote:
> Even though 'compatability' has a dedicated entry in the Wiktionary,
> it's listed as 'Mispelling of compatibility'. Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  arch/metag/include/asm/elf.h             | 2 +-


>  arch/powerpc/kvm/book3s.c                | 2 +-

Acked-by: Alexander Graf <agraf@suse.de>

for the PPC KVM bit.


Alex
