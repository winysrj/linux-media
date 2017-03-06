Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40665 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754086AbdCFP1R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 10:27:17 -0500
Subject: Re: [PATCH 21/29] drivers, s390: convert fc_fcp_pkt.ref_cnt from
 atomic_t to refcount_t
To: Elena Reshetova <elena.reshetova@intel.com>,
        gregkh@linuxfoundation.org
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-22-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
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
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <536a58ba-8896-5639-cab9-bd2f13bed325@suse.de>
Date: Mon, 6 Mar 2017 16:27:11 +0100
MIME-Version: 1.0
In-Reply-To: <1488810076-3754-22-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2017 03:21 PM, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.

The subject is wrong, should be something like "scsi: libfc convert
fc_fcp_pkt.ref_cnt from atomic_t to refcount_t" but not s390.

Other than that
Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N�rnberg
GF: Felix Imend�rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N�rnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
