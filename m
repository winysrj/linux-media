Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3MBVl3h022790
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 07:31:47 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.26])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3MBVSP5023460
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 07:31:28 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1540799qwd.39
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 04:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49EEE84A.5090400@parrot.com>
References: <49EEE84A.5090400@parrot.com>
Date: Wed, 22 Apr 2009 20:31:28 +0900
Message-ID: <aec7e5c30904220431l55a48efah8881b562928eae5a@mail.gmail.com>
From: Magnus Damm <magnus.damm@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: videobuf-dma-contig sync question
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

Hi Matthieu,

[CC Paul, Paulius]

On Wed, Apr 22, 2009 at 6:50 PM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> I don't understand why __videobuf_sync in videobuf-dma-contig isn't a nop.
>
> All the memory allocated by videobuf-dma-contig is coherent memory. And
> Documentation/DMA-API.txt seems to imply that this memory is coherent
> and doesn't need extra cache operation for synchronization.

Sounds correct. With that in mind the sync doesn't make much sense.
Fixing the videobuf-dma-contig code seems like a good idea to me. Or
is it architecture code that needs to be fixed? Any thoughts Paul?

> Also calling dma_sync_single_for_cpu cause panic on arm for per-device
> coherent memory, because the memory isn't in the main memory[1].
>
> Why __videobuf_sync need dma_sync_single_for_cpu ?

Initially in V1 of the patch the sync was just a nop, but in V2 the
current behaviour was introduced. I think Paulius requested the sync
implementation and I just blindly added it since it worked well for me
on SuperH anyway:

http://osdir.com/ml/linux.ports.sh.devel/2008-07/msg00038.html

Paulius, do you really need the sync?

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
