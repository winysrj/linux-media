Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m37HDiOL019956
	for <video4linux-list@redhat.com>; Mon, 7 Apr 2008 13:13:44 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m37HDVni023824
	for <video4linux-list@redhat.com>; Mon, 7 Apr 2008 13:13:32 -0400
Date: Mon, 7 Apr 2008 19:13:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Shah, Hardik" <hardik.shah@ti.com>
In-Reply-To: <010C7BAE6783F34D9AC336EE5A01A08805B4EF78@dbde01.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0804071910520.8933@axis700.grange>
References: <010C7BAE6783F34D9AC336EE5A01A08805B4EF78@dbde01.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-int-device
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

On Mon, 7 Apr 2008, Shah, Hardik wrote:

> Is there any sample driver available based on v4l2-int-device interface.  
> I found tcm825x.c based on v4l2-int-device interface but it is a slave 
> driver.  Any one having master driver as sample and also the 
> application.

If you're looking at developing drivers for new hardware, you might want 
to have a look at an int-device alternative: the soc-camera framework, 
currently in the v4l-dvb/devel tree. Just look for yourself what best 
suits your needs.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
