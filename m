Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SIdtrA022762
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 14:39:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SIdQbg030491
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 14:39:26 -0400
Date: Fri, 28 Mar 2008 15:38:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marton Balint <cus@fazekas.hu>
Message-ID: <20080328153851.73e7999d@gaivota>
In-Reply-To: <54d0fc010ab0225fbed9.1206497255@bluegene.athome>
References: <patchbomb.1206497254@bluegene.athome>
	<54d0fc010ab0225fbed9.1206497255@bluegene.athome>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 1 of 3] cx88: fix oops on module removal caused by IR
 worker
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

On Wed, 26 Mar 2008 03:07:35 +0100
Marton Balint <cus@fazekas.hu> wrote:

> # HG changeset patch
> # User Marton Balint <cus@fazekas.hu>
> # Date 1206487800 -3600
> # Node ID 54d0fc010ab0225fbed97df3267d26e91aa03a2a
> # Parent  cc6c65fe4ce0543e14afdd2b850c991081f7b9ac
> cx88: fix oops on module removal caused by IR worker

Applied, thanks.

I'll wait for some conclusions about the other two patches.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
