Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33690 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754735AbdCGKsv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 05:48:51 -0500
Received: by mail-lf0-f52.google.com with SMTP id a6so85014878lfa.0
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 02:48:03 -0800 (PST)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 11/29] drivers, media: convert cx88_core.refcount from
 atomic_t to refcount_t
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-12-git-send-email-elena.reshetova@intel.com>
 <c6987419-f708-9923-0f9f-87b715600045@cogentembedded.com>
 <2236FBA76BA1254E88B949DDB74E612B41C556E2@IRSMSX102.ger.corp.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Message-ID: <71ea983c-c2e4-9145-634b-78aef993d982@cogentembedded.com>
Date: Tue, 7 Mar 2017 13:40:07 +0300
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C556E2@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/7/2017 10:52 AM, Reshetova, Elena wrote:

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
>> [...]
>>> diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
>>> index 115414c..16c1313 100644
>>> --- a/drivers/media/pci/cx88/cx88.h
>>> +++ b/drivers/media/pci/cx88/cx88.h
[...]
>>> @@ -339,7 +340,7 @@ struct cx8802_dev;
>>>
>>>  struct cx88_core {
>>>  	struct list_head           devlist;
>>> -	atomic_t                   refcount;
>>> +	refcount_t                   refcount;
>>
>>     Could you please keep the name aligned with above and below?
>
> You mean "not aligned" to devlist, but with a shift like it was before?

    I mean aligned, like it was before. :-)

> Sure, will fix. Is the patch ok otherwise?

    I haven't noticed anything else...

> Best Regards,
> Elena.
[...]

MBR, Sergei
