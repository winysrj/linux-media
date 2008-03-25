Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2P9OpcK010056
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 05:24:51 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2P9OHF7002757
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 05:24:17 -0400
Received: by ti-out-0910.google.com with SMTP id 11so840691tim.7
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 02:24:16 -0700 (PDT)
Message-ID: <9618a85a0803250224y8d8b48djd714410b1b8eec59@mail.gmail.com>
Date: Tue, 25 Mar 2008 17:24:14 +0800
From: "kevin liu" <lwtbenben@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: saa7134 driver question.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dear List:
    When I read the source code of saa7134 driver, I was just confused
by the function
saa7134_pgtable_build();
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     __le32        *ptr;
     unsigned int  i,p;

     BUG_ON(NULL == pt || NULL == pt->cpu);

     ptr = pt->cpu + startpage;
     for (i = 0; i < length; i++, list++)
         for (p = 0; p * 4096 < list->length; p++, ptr++)
             *ptr = );
     return 0;
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Through, "" *ptr = cpu_to_le32(sg_dma_address(list)-list->offset); ""
we write bus_addr to the corresponding page table entry, but
for(p=0; p*4096 < list->length; p++, ptr++)
why we always write the same thing(cpu_to_le32(sg_dma_address(list) -
list->offset)
to different page table entry?? Poiter ptr does change while the for
loop statement ends.

Is there anything I misunderstand?

Thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
