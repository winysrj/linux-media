Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38530 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2AER0W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 12:26:22 -0500
Message-ID: <4F05DD37.6010407@redhat.com>
Date: Thu, 05 Jan 2012 18:26:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
	linux-kernel@vger.kernel.org, security@kernel.org,
	pmatouse@redhat.com, agk@redhat.com, jbottomley@parallels.com,
	mchristi@redhat.com, msnitzer@redhat.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI
 passthrough ioctls on partition devices)
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
In-Reply-To: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/05/2012 06:02 PM, Linus Torvalds wrote:
> +	return	ret == -EINVAL ||
> +		ret == -ENOTTY ||
> +		ret == ENOIOCTLCMD;

Missing minus before ENOIOCTLCMD.

Paolo
