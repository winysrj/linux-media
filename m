Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33399 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932285AbdCINi5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 08:38:57 -0500
Received: by mail-wr0-f174.google.com with SMTP id u48so45257022wrc.0
        for <linux-media@vger.kernel.org>; Thu, 09 Mar 2017 05:38:55 -0800 (PST)
Date: Thu, 9 Mar 2017 17:39:36 +0400
From: Anton Sviridenko <anton@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] solo6x10: release vb2 buffers in
 solo_stop_streaming()
Message-ID: <20170309133935.GA16983@magpie-gentoo>
References: <20170308174704.GA22020@magpie-gentoo>
 <0124df98-baa4-5165-57e5-a7e95d2d43e4@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0124df98-baa4-5165-57e5-a7e95d2d43e4@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 09, 2017 at 12:55:35PM +0100, Hans Verkuil wrote:
> > +		dbg_buf_cnt++;
> 
> Left-over from debugging? This variable doesn't exist in the mainline code, so
> this patch doesn't compile.
> 
> Regards,
> 
> 	Hans

Exactly, left-over from debugging, thank you. Going to resubmit fixed
patch.

Anton
