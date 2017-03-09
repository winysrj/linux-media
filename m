Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47197 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751375AbdCIJcw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 04:32:52 -0500
Subject: Re: [PATCH 22/29] drivers, scsi: convert iscsi_task.refcount from
 atomic_t to refcount_t
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
        Chris Leech <cleech@redhat.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-23-git-send-email-elena.reshetova@intel.com>
 <20170308184740.4gueok5csdkt7u62@straylight.hirudinean.org>
 <2236FBA76BA1254E88B949DDB74E612B41C569DC@IRSMSX102.ger.corp.intel.com>
 <5a1f7860-b650-9fe7-fafb-1f0c7cae00e7@suse.de>
 <2236FBA76BA1254E88B949DDB74E612B41C56ABF@IRSMSX102.ger.corp.intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <b1abd29e-5bce-59a4-a66d-d78310921545@suse.de>
Date: Thu, 9 Mar 2017 10:32:03 +0100
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C56ABF@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2017 10:26 AM, Reshetova, Elena wrote:
> 
>> On 03/09/2017 08:18 AM, Reshetova, Elena wrote:
>>>> On Mon, Mar 06, 2017 at 04:21:09PM +0200, Elena Reshetova wrote:
>>>>> refcount_t type and corresponding API should be
>>>>> used instead of atomic_t when the variable is used as
>>>>> a reference counter. This allows to avoid accidental
>>>>> refcounter overflows that might lead to use-after-free
>>>>> situations.
>>>>>
>>>>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>>>>> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
>>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>>> Signed-off-by: David Windsor <dwindsor@gmail.com>
>>>>
>>>> This looks OK to me.
>>>>
>>>> Acked-by: Chris Leech <cleech@redhat.com>
>>>
>>> Thank you for review! Do you have a tree that can take this change?
>>
>> Hi Elena,
>>
>> iscsi like fcoe should go via the SCSI tree.
> 
> Thanks Johannes! Should I resend with "Acked-by" added in order for it to be picked up? 

Yes I think this would be a good way to go.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
