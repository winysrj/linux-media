Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SHm1ib019656
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 13:48:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SHlo6D024263
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 13:47:50 -0400
Date: Fri, 28 Mar 2008 14:47:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Message-ID: <20080328144708.0ef1dad4@gaivota>
In-Reply-To: <47ED2A46.1010407@gmail.com>
References: <47ECD0CF.1020003@gmail.com> <87y783jdjo.fsf@basil.nowhere.org>
	<47ECD715.90507@gmail.com>
	<20080328113803.GQ29105@one.firstfloor.org>
	<47ECE318.1030809@gmail.com>
	<20080328133537.GS29105@one.firstfloor.org>
	<20080328142408.6c8dc198@gaivota> <47ED2A46.1010407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
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

On Fri, 28 Mar 2008 18:26:30 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 03/28/2008 06:24 PM, Mauro Carvalho Chehab wrote:
> > It seems that the problem you're suffering is specific to some driver.
> 
> It's pseudo vivi.c

Ok, I've added the handler for compat32. I didn't test with skype yet.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
