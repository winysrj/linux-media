Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CIWLou021840
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 14:32:21 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4CIW90G024348
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 14:32:09 -0400
Date: Mon, 12 May 2008 20:32:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius <augulis.darius@gmail.com>
In-Reply-To: <g09j17$3m9$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0805122030310.5526@axis700.grange>
References: <g09j17$3m9$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: question about SoC Camera driver (Micron)
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

On Mon, 12 May 2008, Darius wrote:

> I have question regarding both camera drivers for mt9v022 and mt9m001.
> How does attach these drivers to i2c adapter? In i2c_driver structure there
> are neither .attach_adapter nor .detach_client members. So, how does these
> drivers comunicate via i2c bus? Have I something missed...?

They are, so called, new style i2c drivers. They use .probe and .remove 
members, see source code for details.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
