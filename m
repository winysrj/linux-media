Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59631 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753575AbdCFRlH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 12:41:07 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v26Grq34091484
        for <linux-media@vger.kernel.org>; Mon, 6 Mar 2017 11:54:51 -0500
Received: from e06smtp09.uk.ibm.com (e06smtp09.uk.ibm.com [195.75.94.105])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2917pm4jnd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 11:54:50 -0500
Received: from localhost
        by e06smtp09.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Mon, 6 Mar 2017 16:54:48 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 53B7517D8042
        for <linux-media@vger.kernel.org>; Mon,  6 Mar 2017 16:58:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v26GsjCo19726626
        for <linux-media@vger.kernel.org>; Mon, 6 Mar 2017 16:54:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4EC9AE05A
        for <linux-media@vger.kernel.org>; Mon,  6 Mar 2017 16:54:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA874AE053
        for <linux-media@vger.kernel.org>; Mon,  6 Mar 2017 16:54:38 +0000 (GMT)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.209])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-media@vger.kernel.org>; Mon,  6 Mar 2017 16:54:38 +0000 (GMT)
Date: Mon, 6 Mar 2017 17:54:44 +0100
From: Benjamin Block <bblock@linux.vnet.ibm.com>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Elena Reshetova <elena.reshetova@intel.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH 21/29] drivers, s390: convert fc_fcp_pkt.ref_cnt from
 atomic_t to refcount_t
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-22-git-send-email-elena.reshetova@intel.com>
 <536a58ba-8896-5639-cab9-bd2f13bed325@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536a58ba-8896-5639-cab9-bd2f13bed325@suse.de>
Message-Id: <20170306165444.GC7420@bblock-ThinkPad-W530>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 06, 2017 at 04:27:11PM +0100, Johannes Thumshirn wrote:
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

Yes please, I was extremely confused for a moment here.



                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
