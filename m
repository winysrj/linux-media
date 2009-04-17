Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3HFi0fl019434
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 11:44:00 -0400
Received: from seiner.com (flatoutfitness.com [66.178.130.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3HFhiRq025743
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 11:43:44 -0400
Message-ID: <85783c99cf49f6333a835f1022a874f3.squirrel@mail.seiner.com>
In-Reply-To: <alpine.LRH.2.00.0904170940260.7851@rray2>
References: <alpine.LRH.2.00.0904170940260.7851@rray2>
Date: Fri, 17 Apr 2009 08:43:43 -0700 (PDT)
From: "Yan Seiner" <yan@seiner.com>
To: rray_1@comcast.net
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Adding memory to systems screws up playback
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


On Fri, April 17, 2009 7:46 am, rray_1@comcast.net wrote:
> I increased my system memory from 2GB to 4GB and things are not well
> System board is Intel DG965OT
> Has 4 memory slots
> I've had the machine for a couple of years with 2 1GB dimms in slots 1 & 3
> I added 2 1GB dimms in slots 2 & 4
> As far as I can tell everything is working OK except for playback to LML33
>
> I removed the original dimms and put the new ones in slots 1 & 3, 2GB
> Lavplay works OK
> Put original dimms in slots 2 & 4 (4GB total) and lavplay fails
>

It may be a defective mobo; I've had issues like that with an Asus mobo
and an intel chipset (I forget the details...)  You may want to google
about for similar issues.

The only other thing I can think of is that 2.6.18 is fairly old; you may
want to try something more recent.

-- 
Yan Seiner, PE

Support my bid for the 4J School Board
http://www.seiner.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
