Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19535 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdCHRpY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 12:45:24 -0500
Subject: Re: [Xen-devel] [PATCH 29/29] drivers, xen: convert grant_map.users
 from atomic_t to refcount_t
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-30-git-send-email-elena.reshetova@intel.com>
 <99270126-7751-eed0-5efa-fc695ff3be25@oracle.com>
 <2236FBA76BA1254E88B949DDB74E612B41C56177@IRSMSX102.ger.corp.intel.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net"
        <linux1394-devel@lists.sourceforge.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Juergen Gross <jgross@suse.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <c4ea3925-f505-3c5b-a9fc-c74ea5a7cbe9@oracle.com>
Date: Wed, 8 Mar 2017 12:45:23 -0500
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C56177@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2017 08:49 AM, Reshetova, Elena wrote:
>> On 03/06/2017 09:21 AM, Elena Reshetova wrote:
>>> refcount_t type and corresponding API should be
>>> used instead of atomic_t when the variable is used as
>>> a reference counter. This allows to avoid accidental
>>> refcounter overflows that might lead to use-after-free
>>> situations.
>>>
>>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>>> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> Signed-off-by: David Windsor <dwindsor@gmail.com>
>>> ---
>>>  drivers/xen/gntdev.c | 11 ++++++-----
>>>  1 file changed, 6 insertions(+), 5 deletions(-)
>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Is there a tree that can take this change? Turns out it is better to propagate changes via separate trees and only leftovers can be taken via Greg's tree.  
>

Sure, we can take it via Xen tree for rc3.

-boris
