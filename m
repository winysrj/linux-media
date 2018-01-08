Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:20342 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932349AbeAHQUV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 11:20:21 -0500
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative
 execution
To: Dan Williams <dan.j.williams@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alan Cox <alan.cox@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Zhang Rui <rui.zhang@intel.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, qla2xxx-upstream@qlogic.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87y3lbpvzp.fsf@xmission.com>
 <CAPcyv4hVisGeXbTH985Hb6dkYKA9Sr8wwZHudNF-CtH0=ADFug@mail.gmail.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Message-ID: <c2fd13f6-a2c9-d11f-d439-abb847ebed3c@wdc.com>
Date: Mon, 8 Jan 2018 08:20:19 -0800
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hVisGeXbTH985Hb6dkYKA9Sr8wwZHudNF-CtH0=ADFug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/05/18 22:30, Dan Williams wrote:
> On Fri, Jan 5, 2018 at 6:22 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Please expand this.
>>
>> It is not clear what the static analysis is looking for.  Have a clear
>> description of what is being fixed is crucial for allowing any of these
>> changes.
>>
>> For the details given in the change description what I read is magic
>> changes because a magic process says this code is vulnerable.
> 
> Yes, that was my first reaction to the patches as well, I try below to
> add some more background and guidance, but in the end these are static
> analysis reports across a wide swath of sub-systems. It's going to
> take some iteration with domain experts to improve the patch
> descriptions, and that's the point of this series, to get the better
> trained eyes from the actual sub-system owners to take a look at these
> reports.

More information about what the static analysis is looking for would 
definitely be welcome.

Additionally, since the analysis tool is not publicly available, how are 
authors of new kernel code assumed to verify whether or not their code 
needs to use nospec_array_ptr()? How are reviewers of kernel code 
assumed to verify whether or not nospec_array_ptr() is missing where it 
should be used?

Since this patch series only modifies the upstream kernel, how will 
out-of-tree drivers be fixed, e.g. the nVidia driver and the Android 
drivers?

Thanks,

Bart.
