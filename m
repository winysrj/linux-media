Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m68Egr4O011197
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 10:42:53 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m68Egeiu007359
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 10:42:41 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 8 Jul 2008 16:42:33 +0200
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
	<20080705025405.27137.16206.sendpatchset@rx1.opensource.se>
	<48737AA3.3080902@teltonika.lt>
In-Reply-To: <48737AA3.3080902@teltonika.lt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081642.34261.laurent.pinchart@skynet.be>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 03/04] videobuf: Add physically contiguous queue code V2
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

On Tuesday 08 July 2008, Paulius Zaleckas wrote:
> Magnus Damm wrote:
> > This is V2 of the physically contiguous videobuf queues patch.
> > Useful for hardware such as the SuperH Mobile CEU which doesn't
> > support scatter gatter bus mastering.
> 
> spelling gatther :)

gather would be even better :-)

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
