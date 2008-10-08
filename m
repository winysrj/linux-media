Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m98Gv53v019954
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 13:00:35 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m98GaXXH011013
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 12:36:33 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: "Alexey Klimov" <klimov.linux@gmail.com>
Date: Wed, 8 Oct 2008 18:36:30 +0200
References: <208cbae30810080843v49e35a66k8ecd3641caa82b5f@mail.gmail.com>
In-Reply-To: <208cbae30810080843v49e35a66k8ecd3641caa82b5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081836.30367.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] radio-si470x: correct module name in radio/Kconfig
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

Am Mittwoch, 8. Oktober 2008 17:43:23 schrieb Alexey Klimov:
> Hello, Tobias and video4linux-list.
> Well, it's very simple patch - just replace module name in Kconfig.
> 
> Please, apply it carefully. It's unsafe to apply it to mainstream
> kernel (may be i'm wrong) because of different end of Kconfig-file.
> It's safe to apply it to development Mercurial repository on linuxtv.org.
> 
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
> 

Approved. Thanks :-)

Toby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
