Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58901 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965189Ab2CUOqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 10:46:21 -0400
Received: by pbcun15 with SMTP id un15so839928pbc.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 07:46:21 -0700 (PDT)
Date: Wed, 21 Mar 2012 07:46:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-mm@kvack.org,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	John Stultz <john.stultz@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 05/16] mm/drivers: use vm_flags_t for vma flags
Message-ID: <20120321144617.GA14149@kroah.com>
References: <20120321065140.13852.52315.stgit@zurg>
 <20120321065633.13852.11903.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120321065633.13852.11903.stgit@zurg>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 21, 2012 at 10:56:33AM +0400, Konstantin Khlebnikov wrote:
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: linux-media@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: "Arve Hjønnevåg" <arve@android.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

