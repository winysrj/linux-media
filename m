Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:32695 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753130AbdCHNzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 08:55:16 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Johannes Thumshirn <jthumshirn@suse.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net"
        <linux1394-devel@lists.sourceforge.net>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: RE: [PATCH 21/29] drivers, s390: convert fc_fcp_pkt.ref_cnt from
 atomic_t to refcount_t
Date: Wed, 8 Mar 2017 13:48:01 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C5615F@IRSMSX102.ger.corp.intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-22-git-send-email-elena.reshetova@intel.com>
 <536a58ba-8896-5639-cab9-bd2f13bed325@suse.de>
In-Reply-To: <536a58ba-8896-5639-cab9-bd2f13bed325@suse.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On 03/06/2017 03:21 PM, Elena Reshetova wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> 
> The subject is wrong, should be something like "scsi: libfc convert
> fc_fcp_pkt.ref_cnt from atomic_t to refcount_t" but not s390.
> 
> Other than that
> Acked-by: Johannes Thumshirn <jth@kernel.org>

Turns out that it is better that all these patches go through the respective maintainer trees, if present. 
If I send an updated patch (with subject fixed), could you merge it through your tree?

Best Regards,
Elena.
> 
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: Felix Imendörffer, Jane Smithard, Graham Norton
> HRB 21284 (AG Nürnberg)
> Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
