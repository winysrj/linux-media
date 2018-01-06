Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:23197 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753141AbeAFS7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 Jan 2018 13:59:09 -0500
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative
 execution
To: Florian Fainelli <f.fainelli@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, peterz@infradead.org,
        Alan Cox <alan.cox@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Zhang Rui <rui.zhang@intel.com>, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, qla2xxx-upstream@qlogic.com,
        tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, alan@linux.intel.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        netdev@vger.kernel.org, torvalds@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dan.carpenter@oracle.com
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <ca6f24c0-d6cf-e309-aa68-92f1378ee75a@gmail.com>
From: Arjan van de Ven <arjan@linux.intel.com>
Message-ID: <e567c704-e141-63db-5d59-7294e0c78e26@linux.intel.com>
Date: Sat, 6 Jan 2018 10:59:06 -0800
MIME-Version: 1.0
In-Reply-To: <ca6f24c0-d6cf-e309-aa68-92f1378ee75a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> It sounds like Coverity was used to produce these patches? If so, is
> there a plan to have smatch (hey Dan) or other open source static
> analysis tool be possibly enhanced to do a similar type of work?

I'd love for that to happen; the tricky part is being able to have even a
sort of sensible concept of "trusted" vs "untrusted" value...

if you look at a very small window of code, that does not work well;
you likely need to even look (as tool) across .c file boundaries
