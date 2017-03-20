Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35579 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755616AbdCTPFh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 11:05:37 -0400
Received: by mail-pg0-f44.google.com with SMTP id t143so12910301pgb.2
        for <linux-media@vger.kernel.org>; Mon, 20 Mar 2017 08:05:31 -0700 (PDT)
Date: Mon, 20 Mar 2017 08:05:17 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 3/9] stating/atomisp: fix -Wold-style-definition warning
Message-ID: <20170320080517.5b748830@xeon-e3>
In-Reply-To: <20170320093225.1180723-3-arnd@arndb.de>
References: <20170320093225.1180723-1-arnd@arndb.de>
        <20170320093225.1180723-3-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Mar 2017 10:32:19 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> -void ia_css_dequeue_param_buffers(/*unsigned int pipe_num*/)
> +void ia_css_dequeue_param_buffers(/*unsigned int pipe_num*/ void)
>  {
Why keep the comment?
