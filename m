Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:40154 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755102AbdCTON7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:13:59 -0400
Message-ID: <1490018824.24765.54.camel@linux.intel.com>
Subject: Re: [bug report] staging/atomisp: Add support for the Intel IPU v2
From: Alan Cox <alan@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:07:04 +0000
In-Reply-To: <20170313123445.GA9464@mwanda>
References: <20170313123445.GA9464@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>    674  
>    675          /* To avoid owerflows when calling the efivar API */
>    676          if (*out_len > ULONG_MAX)
>                     ^^^^^^^^^^^^^^^^^^^^
> This is impossible.  Was UINT_MAX intended?

I am really not sure. The only case I can imagine is 32bit EFI on a
64bit system, but even then I don't see what the check is about at this
point.

Alan
