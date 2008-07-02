Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m62AjaoF029616
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 06:45:36 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m62Aj7LS030063
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 06:45:09 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KDzpe-0003xM-IM
	for video4linux-list@redhat.com; Wed, 02 Jul 2008 10:45:02 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 02 Jul 2008 10:45:02 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 02 Jul 2008 10:45:02 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Wed, 02 Jul 2008 13:42:14 +0300
Message-ID: <486B5B86.5070807@teltonika.lt>
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>	
	<20080701124735.30446.89320.sendpatchset@rx1.opensource.se>	
	<486B3197.5000100@teltonika.lt>
	<aec7e5c30807020232j1181ba9s43bc0e6920b18733@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <aec7e5c30807020232j1181ba9s43bc0e6920b18733@mail.gmail.com>
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org
Subject: Re: [PATCH 06/07] videobuf: Add physically contiguous queue code
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

Magnus Damm wrote:
> On Wed, Jul 2, 2008 at 4:43 PM, Paulius Zaleckas
> <paulius.zaleckas@teltonika.lt> wrote:
>> Heh. I have written almost identical videobuf driver also :)
>> You should run checkpatch.pl on this patch to correct some style
>> problems. Since your version is a little bit more generic than mine:
>>
>> Acked-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> 
> Thanks for your ack. Just curious, which checkpatch version are you
> using? From the linux-next tree? I've checked my patches with the less
> agressive checkpatch included in the linux-2.6 tree. =)

Strange why checkpatch.pl didn't catch this:

+static void *__videobuf_alloc(size_t size)
+{
+	struct videobuf_dma_contig_memory *mem;
+	struct videobuf_buffer *vb;
+
+	vb = kzalloc(size + sizeof(*mem), GFP_KERNEL);
+	if (vb) {
+		mem = vb->priv = ((char *)vb)+size;

Should be	mem = vb->priv = ((char *)vb) + size;

+		mem->magic = MAGIC_DC_MEM;
+	}
+
+	return vb;
+}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
