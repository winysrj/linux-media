Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33542 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbdCHHzv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 02:55:51 -0500
Message-ID: <1488958624.10589.10.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 24/29] drivers: convert iblock_req.pending from atomic_t
 to refcount_t
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Date: Tue, 07 Mar 2017 23:37:04 -0800
In-Reply-To: <1488810076-3754-25-git-send-email-elena.reshetova@intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
         <1488810076-3754-25-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Elena,

On Mon, 2017-03-06 at 16:21 +0200, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  drivers/target/target_core_iblock.c | 12 ++++++------
>  drivers/target/target_core_iblock.h |  3 ++-
>  2 files changed, 8 insertions(+), 7 deletions(-)

For the target_core_iblock part:

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
