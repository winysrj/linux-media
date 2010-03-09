Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o29AsLba015978
	for <video4linux-list@redhat.com>; Tue, 9 Mar 2010 05:54:21 -0500
Received: from gateway.tuioptics.com (gateway.tuioptics.com [213.183.22.85])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o29As53v020117
	for <video4linux-list@redhat.com>; Tue, 9 Mar 2010 05:54:06 -0500
Received: from tomcat.toptica.com (localhost [127.0.0.1])
	by gateway.tuioptics.com (8.13.6/8.13.6/SuSE Linux 0.8) with ESMTP id
	o29As6PJ025319
	for <video4linux-list@redhat.com>; Tue, 9 Mar 2010 11:54:06 +0100
Date: Tue, 9 Mar 2010 11:51:39 +0100
From: Arno Euteneuer <arno.euteneuer@toptica.com>
To: video4linux-list@redhat.com
Message-ID: <4B96283B.2080800@toptica.com>
In-Reply-To: <4B960AE2.3090803@toptica.com>
References: <4B960AE2.3090803@toptica.com>
Subject: Re: soc-camera driver for i.MX25
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Am 09.03.2010 09:46, schrieb Arno Euteneuer:
> However, reducing the frame size to e.g. 640 x 480 leads to corrupted
> pictures sometimes when using multiple buffers.

Ooops, removing my residual printks in some other v4l2 modules seems to resolve 
that problem ...

Arno

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
